Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816E743A80C;
	Tue, 21 Jul 2026 21:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670035; cv=none; b=XNCmvyXFboiaXzREbQcFKxcSUV9CIgsopFo7SXmaplTjR82A5fidgJ6pgd/g6U89dWEkqycisRTKfme0ltUbGYIlvQqbCgWpb0ttws7sYkjUr3Q6PNVwOJ191uIZNhYalLNZN0Y/4qWGYf75q/tI9iJmfFAuoVe2ZDofZ7qX9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670035; c=relaxed/simple;
	bh=d9hiKcBDPuOzlrTHLLoHCbvQQKnGRkozhFPsttts14c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHolr9LCs28UvNM8UVtKPAYKF34KqJ+k3s2DBmuihfCJreC7JFcqgcSU/zWVFWfD15w+AZVwEuO2DIcB/YkLn7XilrgVAUSLGBLyqwYoXuYyFFvtpEVHtssMs/1qtNTt9e9lg0gsifIsuduZfTt5yY2nS0ybLF+OwT8n+yf+bG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njxou7tG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njxou7tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E632E1F000E9;
	Tue, 21 Jul 2026 21:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670034;
	bh=5jHVzdrGWlM3Gl8W8fm3LsHMaJnioEsIVV9QGAhMAwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njxou7tGhaYbl89tBo1infT/ZwCE37ZFbauOWi1UTFmA3rdvws9lCmnQDJrrnAUwv
	 P95VRYUFfxP9l2sj1PRK/a9UwWlBZ2UDdz5mClTK8Yw67eKHo+ASD3CZjaRs3Ia4vD
	 iU8OY71z8MnRhAM/f+16RLyD4qyJF6swHReWVqfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0779/1067] lockd: Plug nlm_file leak when nlm_do_fopen() fails
Date: Tue, 21 Jul 2026 17:23:00 +0200
Message-ID: <20260721152441.997646959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit f16a1513452edb532fec81e591c64c320866719c upstream.

A client can repeatedly drive nlm_do_fopen() failures by presenting
file handles that the underlying export rejects. After kzalloc_obj()
succeeds in nlm_lookup_file(), the freshly allocated nlm_file is not
yet inserted into nlm_files[]. The nlm_do_fopen() failure path jumps
to out_unlock, which releases nlm_file_mutex and returns without
freeing the allocation, so each failure leaks one nlm_file.

Route the failure through out_free so kfree() runs before the
function returns.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -139,7 +139,7 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 
 	nfserr = nlm_do_fopen(rqstp, file, mode);
 	if (nfserr)
-		goto out_unlock;
+		goto out_free;
 
 	hlist_add_head(&file->f_list, &nlm_files[hash]);
 


