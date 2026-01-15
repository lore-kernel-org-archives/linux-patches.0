Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405713BBA12;
	Thu, 15 Jan 2026 17:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496469; cv=none; b=ODE4UIsusWUR5/+HucSq3ED+/4uaGj10yRSg18Qs7SPNwu84hKKTbtIlKvMYLUKwDPS8/Lqi9Es++Y0Zf5+Izj9vIl8h6KzoMfbkG4G66Wwt6pWtMaQE/zVFmPosWuvXFhpqT5i5TIb3Mp4FsO6HFz8LpFmSH6JfI30BQts5Qx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496469; c=relaxed/simple;
	bh=2K8ReMRAxRhkX98YenyvX3b2rytspL644da2vplD63U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSZb1lTguKZiDdGIoruIdExa5ToX7OYucmZQdMgZkgqFm7DizSMb2WcWhynoQ4YSeYIf1v0FUVE1LY206MSjBtbTUOtcYVSAORO+AZ7G4m66VHmIvQGx6XYWnvgYiUGDDcFNWiLbPKT6Mpjk3WEiGm2hrDQAMEHaaKRyVVd95hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MolPb/VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MolPb/VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A0EC116D0;
	Thu, 15 Jan 2026 17:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496468;
	bh=2K8ReMRAxRhkX98YenyvX3b2rytspL644da2vplD63U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MolPb/VRmYOEs5Go9vmsU2UN4C6//Stwio5YvX9R4OakJb2cR5YdvFmt0YORk0lr4
	 2LfO1ldF0ONQ0JLWAG0qK2J/nyiiHrBewIxVi1tvSfZb7E1eGCCQtAB6ftWTXAVsx1
	 nIWoASDdz55rJ4B7XvIW9gQvqvgbVmso/Mj4sbt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 023/119] libceph: replace overzealous BUG_ON in osdmap_apply_incremental()
Date: Thu, 15 Jan 2026 17:47:18 +0100
Message-ID: <20260115164152.798945919@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit e00c3f71b5cf75681dbd74ee3f982a99cb690c2b upstream.

If the osdmap is (maliciously) corrupted such that the incremental
osdmap epoch is different from what is expected, there is no need to
BUG.  Instead, just declare the incremental osdmap to be invalid.

Cc: stable@vger.kernel.org
Reported-by: ziming zhang <ezrakiez@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1979,11 +1979,13 @@ struct ceph_osdmap *osdmap_apply_increme
 			 sizeof(u64) + sizeof(u32), e_inval);
 	ceph_decode_copy(p, &fsid, sizeof(fsid));
 	epoch = ceph_decode_32(p);
-	BUG_ON(epoch != map->epoch+1);
 	ceph_decode_copy(p, &modified, sizeof(modified));
 	new_pool_max = ceph_decode_64(p);
 	new_flags = ceph_decode_32(p);
 
+	if (epoch != map->epoch + 1)
+		goto e_inval;
+
 	/* full map? */
 	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {


