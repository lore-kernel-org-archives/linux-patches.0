Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063663;
	b=ppfAB2AB+4wVWS+vN4HSB2W77aYzPRQ+7ovmc90mG2UV4q0owcewx3Uy1fnqc8hoonST
	 5kMDdKJBGCZfw3725zhfMwg1O4TrCCiNskew2aAvCQq3+RIxwaQLaoFE4aLC9MACELeJx
	 qeFz8H5tiwM+GK2qySfQJqDqFTszyKoo+Fpj3nY6sOnJjgwiJ0ImD7ZlOvWvDnlseH1Na
	 gRbVWalpLGP83Ymn3dVModSILfEncx67FAuc5bArtp+ZkA6N3t5iuIT3lC1eXs4L8ChlP
	 zsXobloTyehCFXAZGAdi40YJg4rKNbTtqW1MG/hWY+GcBvBmvWjL/ySGc032CW3JwYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F+ohLeXYXC3A4jSLGEAm5S4iBUvs4CJ6IB6DqASR+sk=;
	b=zz5tLg5RNSMfPcmw0yt9D843Ja11sNRFO9aLTj/UFMfjtJF72u2UDg22Kt/KdkrxGtCC
	 1Y82wrIpircQOG7TWc/Ellave9CtxuttrxXRSXLbvkJKVP/b8Cb9C3S1yumVL6fhWp3Cv
	 w75ExSM0oGlzlt+L82/4PnhV0fqzHfxRmAOIkzzyf5VqY8BrDoFZL1iHfIY6fe1I7FDve
	 2JK3GpT18IedgQsaj/LJPtr1REa9JM2vC48CRAV/+EU+EvtS237zGH8CknLFxCiL+IQBL
	 13YSQiuNcDGZ6cEbqBb6ZHWfpbRo47AY/vltejMt/qbG7kuAMdmT8X88f43e/Z5OWLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHADfJdd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C8606A9DA;
	Sat,  7 Nov 2026 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHADfJdd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49771F0089F;
	Sat,  7 Nov 2026 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063662;
	bh=F+ohLeXYXC3A4jSLGEAm5S4iBUvs4CJ6IB6DqASR+sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHADfJdd28lkxS+D0S8fTAcFeqplToUT0t0ValezrD3J73CfG7/9aX5j3iLk4XRSY
	 B3OESheoR1Io8vv/sEQHODOzpWLfkylusdzCSRO/5McTenOXZPwT/+MDDSBHJzVTFy
	 bZnsqVz/xaONdduxUdiwplyyKMj11CnkMjzSi1Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 776/869] ceph: Fix xattr buffer leak in __send_cap()
Date: Sat,  7 Nov 2026 08:57:38 -0500
Message-ID: <20261107134919.009614564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e51cf76e7275d1bb5ad2d529bb00feade632dadc ]

__prep_cap() takes a reference on the xattr blob via ceph_buffer_get()
and also grabs a reference to the old xattr blob returned by
__ceph_build_xattrs_blob(). These references are normally dropped in
__send_cap() after the cap message has been sent, but when ceph_msg_new()
fails, __send_cap() requeues the cap and returns early without dropping
them, leaking both buffers on every allocation failure.

Release arg->old_xattr_buf and arg->xattr_buf on the ceph_msg_new()
failure path before returning.

Cc: stable@vger.kernel.org
Fixes: 16d68903f56a ("ceph: break up send_cap_msg")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7ce1af5b61c88..3dfd230412cc2 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1561,6 +1561,8 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		ceph_buffer_put(arg->old_xattr_buf);
+		ceph_buffer_put(arg->xattr_buf);
 		return;
 	}
 
-- 
2.53.0



