Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8CD1E7C27;
	Thu, 30 Jan 2025 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246914; cv=none; b=f+JX5ws/AjAdnvCDyQ2EpAD8z+8BtHFmQV0e+LVekClM3yuCoTveDcTYA4I3FeTLYgHWb51jrt8H0689Zy5WeqJ38wy81YSzV5h79B1CAVueOOo0PXjwK8SeWFv+kh38B8VnFBajNsSdDy+KIFcqgYXpGkIWc/iVBOe89AsqiZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246914; c=relaxed/simple;
	bh=ejO7E/3J1GJTKYSjhzCw02/iA6ShxDUvUQw4xuUfDdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfQVamj17NyQR9UuLoDVX15PbF0RbTOOvIJ03quzcBKyZw0o8oFmyN9CvXrp1oZSgtmQ1Yzun2CY2+8PS2yHWRtc90k/eU5cjD8yL6EwV93JbmTgf9i304GlKXgHq8jtOVZYX2EWrIyxOp8gYzEfZ+bVwISCuqJZWBeVcubK62A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTLf7CYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTLf7CYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AABC4CED2;
	Thu, 30 Jan 2025 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246913;
	bh=ejO7E/3J1GJTKYSjhzCw02/iA6ShxDUvUQw4xuUfDdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTLf7CYCcYz1TbpRsEHZoMwhxYCMO9T2K6k48zFWfraqoBpCzQDJ/HAvZKhsBk+3i
	 BONXLlXN3Tj6ijMLL1mw4h4z+oPEivAZTwPKjeX2vV3FkHzhzEIPp7LOr1Nbw1puW3
	 5pc49hZG4+2+ejTC26zsTcMZ+wLA6U3CKQlcSdhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 019/133] dm thin: make get_first_thin use rcu-safe list first function
Date: Thu, 30 Jan 2025 15:00:08 +0100
Message-ID: <20250130140143.279255272@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2317,10 +2317,9 @@ static struct thin_c *get_first_thin(str
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


