Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045804;
	b=i4j6RJWty48Bq2kk2FPeAtBCYoZoWwa+bsPFDRgSdJbXQzQAhFCTTPmm7+FyNKYHoPEz
	 427Tnxn2q5TXSYNXyPV3YqkKZq/KfQWUROkzk+VI1EHd8T3fNTIOkdF5Od+NxHxDqMs17
	 gBVCpwKDlhTGXqca1zkQUjCbWRlBOKflWoRuq2aPU2NPTMS6sf0Ol//BnBSQ8ROJm0/Pv
	 q5Av/0U35lblD7ugK75HT8ZbsSOSE8eBBzwkSOJ1rAgITl+v/m9506ASHqu1z9rGfF/Pb
	 CC8SMfJfajIHTt/FXOS/zu/wNslZZuwIWjRjlsaMNUXh4t4E6RUbxC/9S0UmM82n1kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3yqVU0Y/9HRlWA9jbrDYZHr5pBCG/CSqr9tFnHifA8=;
	b=hmCMfjL8RYIqE0D9LQ6jDhyhB0ooIonaYjxCWJFB7ZbKW9KbMDU1d7qiw9ZIhDHfqfH1
	 0+qJhw5+cZANcF6ct/bcWDsFNv1/XC4Iad1GXLgZymmEu22iDD+ltkcrg+Y78BPutI8S/
	 bidstCdYbYGGqFzWFzqwL5vqEuYJps7Q94s+XJhUDYjTAW/qFH/7yBIXz9aABidOQO+/C
	 JCxrN+DRjDSjuQRVbxSxOHbnhnuOUf8BaOqVsLA+xUJP4zT5mA6+srOP//IrHNPePNuaU
	 1Dz8zLjV6Kvg3Wfeg2ZLLUentQ2o7G57yhkS9KxMMMz4tDwL1LTT0kAZgHqzfg2dT4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soGWtmll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF8B606A32A;
	Wed, 18 Nov 2026 23:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soGWtmll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E8B1F000C4;
	Wed, 18 Nov 2026 23:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045804;
	bh=O3yqVU0Y/9HRlWA9jbrDYZHr5pBCG/CSqr9tFnHifA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soGWtmllIPJANTwA6Qap/RBF4TZiUQdvTga8Lb28nXznl1QWqRxz4AqzQYDQbiTBZ
	 vQepxGzy2puKl2W3CsRLFtsuW521VKxI3ux0Lu3jIl8YxLnFrhxHulP4QsK6fbbFU2
	 kyxH9qypuBpNtPDutQsI8L7Fd2RuUO2LM7c4hmrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1054/2857] ceph: Fix xattr buffer leak in __send_cap()
Date: Wed, 18 Nov 2026 15:34:48 +0100
Message-ID: <20261118150239.541627593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 448ba5ec4e3b3..3b3704d425921 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1454,6 +1454,8 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		ceph_buffer_put(arg->old_xattr_buf);
+		ceph_buffer_put(arg->xattr_buf);
 		return;
 	}
 
-- 
2.53.0



