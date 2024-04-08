Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCAB42046;
	Mon,  8 Apr 2024 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584310; cv=none; b=MevKm1uv9ktIxV+QT0BhNwvVR1tmv7uav733CO8qI3ygidnEYJzRX4+5CtNCMkBPTodB0I8G/tXyaKs2u1tYiLEwmrC+SfA1osP5gIeAQ7nmEddCbCr3n30ogf7Xl568Lkk37ypWd2yz8ymoVoDfdghOrVHZE1URusxccJZRa9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584310; c=relaxed/simple;
	bh=cRjOxyFVd84IIGZjnSDyXQ+H0gfTWSxJ2h3YTqGWoo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUhHQtFXPM1Frxa5XleIfUNt3NORT4Wgg8cv6paIpGFNbbOKrENpKObfQc3uHXryillpG8XbKvCBwHadeeFl7iVoNWKYzi++c3htBE+7wLM91r19/UAfFDfl0fHP9/Ca9UwXzQwMAKCSiserANMeWECiaMLafxrcC/MskNRSm8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOEcBQGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOEcBQGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715B1C433F1;
	Mon,  8 Apr 2024 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584309;
	bh=cRjOxyFVd84IIGZjnSDyXQ+H0gfTWSxJ2h3YTqGWoo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOEcBQGJ+4b796IuLH8rB2kdvUVVabuLW8BiB50w0BhmT/bCliF3ksvlwWcXy0qnM
	 DeT6s4tJecZveAwhwLFiZ3aR+ev6MWHZ/j79OgZ/KM4j3f79cGxMWp4XieXMobXxnY
	 GJ/NG+Q4Kx5/h6j+oCakgQrdnOozqCJxDCLsOrJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 395/690] NFSD: Refactor nfsd4_cleanup_inter_ssc() (1/2)
Date: Mon,  8 Apr 2024 14:54:21 +0200
Message-ID: <20240408125413.850126511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 24d796ea383b8a4c8234e06d1b14bbcd371192ea ]

The @src parameter is sometimes a pointer to a struct nfsd_file and
sometimes a pointer to struct file hiding in a phony struct
nfsd_file. Refactor nfsd4_cleanup_inter_ssc() so the @src parameter
is always an explicit struct file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4fd6611d29ce4..238df435b395d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1550,7 +1550,7 @@ nfsd4_setup_inter_ssc(struct svc_rqst *rqstp,
 }
 
 static void
-nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
+nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct file *filp,
 			struct nfsd_file *dst)
 {
 	bool found = false;
@@ -1559,9 +1559,9 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
 	struct nfsd4_ssc_umount_item *ni = NULL;
 	struct nfsd_net *nn = net_generic(dst->nf_net, nfsd_net_id);
 
-	nfs42_ssc_close(src->nf_file);
+	nfs42_ssc_close(filp);
 	nfsd_file_put(dst);
-	fput(src->nf_file);
+	fput(filp);
 
 	if (!nn) {
 		mntput(ss_mnt);
@@ -1604,7 +1604,7 @@ nfsd4_setup_inter_ssc(struct svc_rqst *rqstp,
 }
 
 static void
-nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
+nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct file *filp,
 			struct nfsd_file *dst)
 {
 }
@@ -1718,7 +1718,7 @@ static __be32 nfsd4_do_copy(struct nfsd4_copy *copy, bool sync)
 	}
 
 	if (nfsd4_ssc_is_inter(copy))
-		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src,
+		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
 					copy->nf_dst);
 	else
 		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
-- 
2.43.0



