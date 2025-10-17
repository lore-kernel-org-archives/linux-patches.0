Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F032B2F12D2;
	Fri, 17 Oct 2025 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713866; cv=none; b=rVENDpiu6IWa/mVOghg0NsHIzIGfmtiCBvgycuTZY6xUoKEWuocntuiVElM4+reJWe1XhN+0gmSs/Z2LQ09pgSuqMioGT8DhEmmGBYkeOyb5LtqQbng9CGR9H3R/n9rLzJYcssBHoBmGRKKqipx0Vi405oONuVPZYFwNBaPWS4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713866; c=relaxed/simple;
	bh=3pe2rHf32ueIWHO79V4Vui1TPnNwg1tUQL+rtZMlnc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRSWTnCBeDo6z8Yqa0r1Dl5p68U2SQoqCseDAKuBMuqkGA+Py2hUbHiiolrfzIPg7GG0dQbq9Q4B2EmmpFACW+NJriggI+umcskjZpRm+eqPo1BTULEbf54iohOaKFy7gy9Y4/5GVQ3BkM8qXotNEaXblaxQtLz4EhMcfJuSneA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaM7CG3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaM7CG3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD7EC4CEE7;
	Fri, 17 Oct 2025 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713865;
	bh=3pe2rHf32ueIWHO79V4Vui1TPnNwg1tUQL+rtZMlnc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaM7CG3WPi+ldJ0KUsEx0pzetTsIkVEBlA5VFM77RhyOxXSgZeab5qUQSjEvsPuak
	 vJxZAvC+lYvF2BvFCR1ccS5EKPyObqU2rw+cFi7vlSwNU5f3JKh/tF3ATzmOuJ8hOF
	 1l37CKxX9KeFN66qNudSVfImxV8hjSXs847q2ggQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 146/201] NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()
Date: Fri, 17 Oct 2025 16:53:27 +0200
Message-ID: <20251017145140.096760122@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit ab1c282c010c4f327bd7addc3c0035fd8e3c1721 upstream.

Commit 5304877936c0 ("NFSD: Fix strncpy() fortify warning") replaced
strncpy(,, sizeof(..)) with strlcpy(,, sizeof(..) - 1), but strlcpy()
already guaranteed NUL-termination of the destination buffer and
subtracting one byte potentially truncated the source string.

The incorrect size was then carried over in commit 72f78ae00a8e ("NFSD:
move from strlcpy with unused retval to strscpy") when switching from
strlcpy() to strscpy().

Fix this off-by-one error by using the full size of the destination
buffer again.

Cc: stable@vger.kernel.org
Fixes: 5304877936c0 ("NFSD: Fix strncpy() fortify warning")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1368,7 +1368,7 @@ try_again:
 		return 0;
 	}
 	if (work) {
-		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr) - 1);
+		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr));
 		refcount_set(&work->nsui_refcnt, 2);
 		work->nsui_busy = true;
 		list_add_tail(&work->nsui_list, &nn->nfsd_ssc_mount_list);


