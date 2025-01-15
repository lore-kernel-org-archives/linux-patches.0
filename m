Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF372248BC8;
	Wed, 15 Jan 2025 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937629; cv=none; b=ZQFkQT7juhHx23SdfZDntlGu/dlVvY6sLD6CeMuJTFyKifYSFrRbce+kdk6CYz0Ml1vLTa09ayVwEDnw4Dl7k1qrTMvuz4NWMtHV3yuN6KJEPdQUpC1x8NbVfm+bQ6ZGq6Afu6f0m68cYFrAOYaEfUBraMtg/fOekAr0BM7RC1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937629; c=relaxed/simple;
	bh=mQonhShtlN0f65bSkoCyKsiQbGDpGFl0QNG7eMZ2j/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZeIEtlYlMHVWPNuhTSyab66LUByb6YA2VMBvd0QENMuYofk6A8OyDkLz9L/l1joc+5NSNP9C0H0X65jWvo0KggeLGCvO1GrfmXUrGfxm9ID138oSv2CZ2O5QtAUalThXz8SL2Hv1rlqjN6JC8IAiVQ1gvTt0YbY82MvFODHGVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sck/ZGH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sck/ZGH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC389C4CEE1;
	Wed, 15 Jan 2025 10:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937628;
	bh=mQonhShtlN0f65bSkoCyKsiQbGDpGFl0QNG7eMZ2j/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sck/ZGH914Bu9Lx2Km0PO0a+7ePgsvqupESCv0ViUw9FUfJgxnajQJxLgVfNvDudA
	 16I8prkTFAP+mzTgTeV/t+kOqEXtQRUfAu9gSLJrsA5d/p9Td2hLtcBHgiKU57DN3U
	 lOzu5x8mKlP5tn2epqkcF7UVBn+bGlLNpLKDHZX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 36/92] dm thin: make get_first_thin use rcu-safe list first function
Date: Wed, 15 Jan 2025 11:36:54 +0100
Message-ID: <20250115103548.972263713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krister Johansen <kjlx@templeofstupid.com>

commit 80f130bfad1dab93b95683fc39b87235682b8f72 upstream.

The documentation in rculist.h explains the absence of list_empty_rcu()
and cautions programmers against relying on a list_empty() ->
list_first() sequence in RCU safe code.  This is because each of these
functions performs its own READ_ONCE() of the list head.  This can lead
to a situation where the list_empty() sees a valid list entry, but the
subsequent list_first() sees a different view of list head state after a
modification.

In the case of dm-thin, this author had a production box crash from a GP
fault in the process_deferred_bios path.  This function saw a valid list
head in get_first_thin() but when it subsequently dereferenced that and
turned it into a thin_c, it got the inside of the struct pool, since the
list was now empty and referring to itself.  The kernel on which this
occurred printed both a warning about a refcount_t being saturated, and
a UBSAN error for an out-of-bounds cpuid access in the queued spinlock,
prior to the fault itself.  When the resulting kdump was examined, it
was possible to see another thread patiently waiting in thin_dtr's
synchronize_rcu.

The thin_dtr call managed to pull the thin_c out of the active thins
list (and have it be the last entry in the active_thins list) at just
the wrong moment which lead to this crash.

Fortunately, the fix here is straight forward.  Switch get_first_thin()
function to use list_first_or_null_rcu() which performs just a single
READ_ONCE() and returns NULL if the list is already empty.

This was run against the devicemapper test suite's thin-provisioning
suites for delete and suspend and no regressions were observed.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Fixes: b10ebd34ccca ("dm thin: fix rcu_read_lock being held in code that can sleep")
Cc: stable@vger.kernel.org
Acked-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2306,10 +2306,9 @@ static struct thin_c *get_first_thin(str
 	struct thin_c *tc = NULL;
 
 	rcu_read_lock();
-	if (!list_empty(&pool->active_thins)) {
-		tc = list_entry_rcu(pool->active_thins.next, struct thin_c, list);
+	tc = list_first_or_null_rcu(&pool->active_thins, struct thin_c, list);
+	if (tc)
 		thin_get(tc);
-	}
 	rcu_read_unlock();
 
 	return tc;


