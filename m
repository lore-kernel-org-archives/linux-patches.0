Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00278248BBD;
	Wed, 15 Jan 2025 10:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938110; cv=none; b=ejOBip8EpovGr/dATwMTWQTLUXIofGu7dFy7Vfb9fRv9wf8Ax31BxI8qQdIF8MyYZjbFQIlwVS5Khv8v+UhIVilbRZLCmiHbehpqW3EVrKpMH4NDOMsjZRWZyyJn/RaXVDO+WIQMJX3vy1t/aZBg4ywGECTuM0TxJx6JzCP8wYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938110; c=relaxed/simple;
	bh=UI+4AuJ2c0DMYlSZGc3f3t+Aufb1fjOgq3ezBKV+t0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoVBszewMHiPthbW1An+0zxyaOfVAfH2LraUnJhsUebJ6FiRoDdIhfH8t5tEHOdoY3zgDi2P+ckqcDFq101+cvy0z+J5MgW5Slg80GaFDAmi0GFYun+snMGPe/RN4umFnP4/1aa77Tuj5oN3v9Lrhp2hwH6tpuA4MmExyac9OHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRWtlcoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRWtlcoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73511C4CEDF;
	Wed, 15 Jan 2025 10:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938109;
	bh=UI+4AuJ2c0DMYlSZGc3f3t+Aufb1fjOgq3ezBKV+t0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRWtlcoosQ7e0t26AgRy3prkEBOXY1XByE90e86i1ZDL69X9cSTX50mLQoqdA5Bf5
	 GE46CgUQpRsQM493bIj4PRglmAwflS9KMsZ0j1p4bNzlBTkkI7loL8toVbHrZj4eWX
	 v0hAh1vOpU99rbGF9sfA2U8VHTJim5fo7ZkWcgMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 085/189] dm thin: make get_first_thin use rcu-safe list first function
Date: Wed, 15 Jan 2025 11:36:21 +0100
Message-ID: <20250115103609.730076127@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2332,10 +2332,9 @@ static struct thin_c *get_first_thin(str
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


