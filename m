Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DA13BFE3D;
	Thu, 15 Jan 2026 18:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500074; cv=none; b=Etx58UrbsEuD8zOp00BFQ1o/EUCdvB4+eUciq2jYqD/6ywUq8Rm5ABBdkVcN2caPNZ1jzo4q9PfHD35/n8gKcaEMGMrwnliUZq0TkGnPHjD6AXL8enxnULm9qs/rFex18PoXzlABF1lmUYyjKxsjKh5GrmY6cBJwY5u2yeRKiS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500074; c=relaxed/simple;
	bh=bsgWLyBr1oKOdjBr7+UIup+awMdcp30tAz1cyHDs3T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOAir/a3EjxfHvROnUOThnMd44RIH2nWqm7SzGgu6fU12F6UPysvheORM5dP1V8vRJuTW1/t5AEGOlMA/gbnDkL7MDCLhIntpg1D/W4AUnle4KRYN8CnwxLBpkgw5VTaRYWrt3k/bFFMis4EeWC7mfBMl8JGr9hsf5m61LE30DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqQOnqNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqQOnqNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAF4C16AAE;
	Thu, 15 Jan 2026 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500074;
	bh=bsgWLyBr1oKOdjBr7+UIup+awMdcp30tAz1cyHDs3T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqQOnqNU8+Zym3E8eWsQIiRbeWCp3nUI5NSv4MltUNwz2/noP+5TGiXMYdUNo1i0b
	 QsVOVwXrjuRwg9bPDL+/zVDG0gcNsEaTpWMF/P3ER9XhkpWx5ekwaoLXyQ0MGwJPeu
	 T7brmQcsx73bYHqBtwkldiiK674zpDaENCDoPig4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 416/451] libceph: replace overzealous BUG_ON in osdmap_apply_incremental()
Date: Thu, 15 Jan 2026 17:50:17 +0100
Message-ID: <20260115164245.987471376@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1940,11 +1940,13 @@ struct ceph_osdmap *osdmap_apply_increme
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


