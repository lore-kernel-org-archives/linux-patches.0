Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052871;
	b=BacDaMxJgbLDWJhSD2wUlflxAnUHBDg8C4PT+Om36CBO2UlVONEHIJz1gu/BWlKYnEtO
	 FO8lT+goGwPV3gVT60hOHswcoFXSC+WJxek1ZpPDVivkxJBl3ROgPsLT5abgNQNzP0Qxq
	 4WRAzcEyptXKHW6pf6+jegKhhoGW8MW4IWQ9bjV9WkUFVSe2Se4DrDrLnfHChSb1GNlvO
	 5tC0DuxQFBmGJau/vSxsWjQMtok+JmuPPwnJG2OoeeW8T7UQdNF7R0CHEtY87eq2AZu79
	 nZl7tOM/4MyvIKK8OPWJT01BqcGUvbjDHk6ZQOSNZLJQP5aBtRpbzlQi6nxTOzZfZMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FIaX9rLT/zS730Qy24TmYXIcvqFKI8N4GshoyxXyxxY=;
	b=E6Y9bk/JTEv5R8Cvwm15dEuCOkoSwjSRNCnWV2DBwBmCDsKTLgEdr/f+s//jX8Sx1tCG
	 UewZqc+liRzRgGZYxFlstvyivkhbQrpS0YWpJllY4YtExOGRSHFls2Ag5ZJLHt9392ejU
	 +x/OFVkyhY9cTnm66Tu+R9FlkXhm8XoR7n/alMrY7cnyG9kU/DSPUIAG/EimUaQIkYYxN
	 BomiqqCs9VcSP991CR3I030np/masz9mWFDzB/9vwWrN8NdVKNtwEUrfbBQUfElfS1D+c
	 yWfzFVvPVIrFg7c3kqjutZpi4oMxfT9+i7MvxgoISCFwObfuceFsPXZ5HBYIpMg7Vdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdBdJOq5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09164606A31C;
	Thu, 19 Nov 2026 01:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdBdJOq5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABEC1F000C4;
	Thu, 19 Nov 2026 01:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052870;
	bh=FIaX9rLT/zS730Qy24TmYXIcvqFKI8N4GshoyxXyxxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdBdJOq5RTReV1fJ62gL0fdzZzEj48V1G0ToMErHjKRXV1xuthOw+VnFICEyCHrtf
	 5gRMBt0NHwMPC6PXprnnQMDHsyiBkNDA0Vw0eBikp6HrE82oqK7PPAJZU1mIZmcTsK
	 XGS5K0ALjo0ukfh5DVLSS0m3HHBHObFai8ACtiQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0716/2214] ceph: Fix xattr buffer leak in __send_cap()
Date: Wed, 18 Nov 2026 15:39:52 +0100
Message-ID: <20261118150040.444970055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 42af046aef510..9f949bc290c5e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1450,6 +1450,8 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		ceph_buffer_put(arg->old_xattr_buf);
+		ceph_buffer_put(arg->xattr_buf);
 		return;
 	}
 
-- 
2.53.0



