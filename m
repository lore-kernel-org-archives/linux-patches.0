Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060711;
	b=ygJ9nssrOZJGrEFvycRgkyu+4z+0pNkfLynRBKZMx/t7WCSTSLt9BUiQoUdm3NMsv9eW
	 tmwqztyqTrdPqm7UD7xMHO1HodaoVvCDdHLR9wO/p/kAJJ1UNilCc/Dqgu+GTOI2A8FCd
	 uE910dCCYJ12gKj1p3PaPfJ3cK9O84KmQV811BHxFIJXaVpdd5e9owBp3XxOXDcapWf+k
	 vOt6/KNWmeaTCQ1oGwIfMwKShwY9lfF6+Z/yHtqeRcZ+664n7VUCmysJnsSfpuTW14HXP
	 +ZfEYTijsN5OuFmlIdOdzyLzwiM450wvnjRmfujfxi+5haVY6vp9km7sTDhPyaq4mFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYleR9Qn/KRMlCMTvlf4ICGLEjGXNOOwrjU3DdEMfFo=;
	b=XH554fCN4E1bd+v6q0v4VCZgPUckYPDmNwZHRF423AeeQsKyiEihJG+59eeoJhprJVj9
	 1lAR8HHC/t/nSMFud3eX/mp4KDTp09nIjNXgNPXmJXW/UHAHPkWBkkIuD0kVH0/jje/cu
	 jbzijHVW9JI4tr1tZjPux3grVnAsn1lB6feFUa08Bxq8K9rceUDse09CJd0ns1oLmJlTq
	 vVk9nmMhEBjX+snqnJ/S5xOYnf7GWlmK6BxKZXh4FrtxMMq8MksPoUevU9mLNZGw/XaAB
	 eDJXeofsCdZRMpV//UjkCPlewfsUU9vH/0adz8syS0b8Nir1Gvw7pCe9wBGR4BG24pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEgUhA13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0174606A320;
	Thu, 19 Nov 2026 03:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEgUhA13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7C61F000C7;
	Thu, 19 Nov 2026 03:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060711;
	bh=tYleR9Qn/KRMlCMTvlf4ICGLEjGXNOOwrjU3DdEMfFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEgUhA13Xd9Uim0IZ1rc4DzsPe4G+CyIo3twt9PUjyKNNGqTnPNLu+8ps2B0x1wUK
	 iAZ45OFQLJ1avuj0AdQBp9HKjlCaQmmk/+aoijomFYVXwBX1/4FlqmJLItFW995PRJ
	 5ghiHyz5OqwyIknYnaC/hw6jhH3HqnVVt7UpdPJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1298/1848] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 18 Nov 2026 15:55:36 +0100
Message-ID: <20261118150013.856976515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ef15197f81ffedf29560edf2221199d92fd83dc2 ]

The reference taken by siw_qp_id2obj() is dropped before the address
of the embedded ib_qp is taken from the QP.  If that reference was
the last one the QP is freed and the pointer returned to the iwarp
core is dangling; the core only pins the QP with iw_add_ref() after
the call has returned.

Copy the pointer while the reference is still held.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916184400.2093106-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 5ba0893f1f017..0daa50239f9b1 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -244,8 +244,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
 		/*
 		 * siw_qp_id2obj() increments object reference count
 		 */
+		struct ib_qp *base_qp = &qp->base_qp;
+
 		siw_qp_put(qp);
-		return &qp->base_qp;
+
+		return base_qp;
 	}
 	return NULL;
 }
-- 
2.53.0



