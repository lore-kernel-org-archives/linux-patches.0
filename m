Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A91330B0F;
	Fri, 17 Oct 2025 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716612; cv=none; b=FcXV2rz6lqE6BiRAei2MhLqNam5z0rqBH7FsPmzzsZP7r4ZE5Q/TCO37UBLDz5SWq/Rw2V/pLmRxfEfw8eb+7Wb2/tfMVSPpNVO2gsVhuJKChTNFzmbZhEwAhiVKUGexxT5Dva0KCQxzfViVFfn8UbzUundFs7/EnkMzIutscNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716612; c=relaxed/simple;
	bh=ZFc3S19sSIeN+2xhZDaq4WreA90qOmFBd4BzcBZhzNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foTcJBMr5Hb3n1zQIwtsyAk44c5QDnAg7nkCqmh87Ij2f2+FcH7Kn6PEphuXpzcmMhCkYoMT5o956QOr6FQbjheWh6d2X4RqTKtYq32KGyGmz5Npv0VWcvvRDIGtYw8LE7RwbfclGPgYrdOBcvlHXFAPxeMX3n+gUWAMfOd+8tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zykGtYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zykGtYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FDCC4CEE7;
	Fri, 17 Oct 2025 15:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716612;
	bh=ZFc3S19sSIeN+2xhZDaq4WreA90qOmFBd4BzcBZhzNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zykGtYauAFO+yRJxTf1ZOciO8Yi4OF2+6sVsu87yJuQpepVnHkJMybdFJjqwVqJA
	 cTnAZXsINJZ+7eqJJrx1a+0mk8HyY+uhsqwQfi99yZ78furS7h3M2MOCIed1qs4VQY
	 0XXO3M880SlxGFuPZ/AnegLrJgnoyw+knT1t31Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 217/276] NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()
Date: Fri, 17 Oct 2025 16:55:10 +0200
Message-ID: <20251017145150.385082282@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1335,7 +1335,7 @@ try_again:
 		return 0;
 	}
 	if (work) {
-		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr) - 1);
+		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr));
 		refcount_set(&work->nsui_refcnt, 2);
 		work->nsui_busy = true;
 		list_add_tail(&work->nsui_list, &nn->nfsd_ssc_mount_list);


