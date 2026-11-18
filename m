Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016890;
	b=E6kAc35j1y0tTsc9kkplQqtSD/1Ks+KEkE1YUOpBSrVZxPKX/6oNUOlKn9zXGErgY0uN
	 Wn6/6g1rgi7hnWeWHLwvIHAx02UgWxO5mX2l99UDCslQ/pyfmRNVolLucnIK4jQ0+eE3U
	 pu2s9yiS5VFdzvU9JsmNGRYVDZ5XJEx/D3+zRaYosyU+sv7ScJRRpiaABSRjFuQEGLJGo
	 LJdmo0LFMuER3nXyYQdcCroFBBb6FZcxbBIYx5PKPDar6eD5kzu5zcZ8/pjdt5U8IqWLr
	 gEV2GPToTu0C81rJZvIvRpiwXR7RDRNggfiGvvn8+ReNqbX2F9iTLjtLOKMIFx5Yg9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8hvnh+OPxUi3G5DuiyZRvLe/3F2IKbOT8PLWNI/XDU=;
	b=4DpFgy+qykifNXchv0FFOFLDw+X7Q/Qj4jNWxC3Nl7oFeRkuZMhlutfPZi6yZuChL48s
	 FK3yQE5VGd00ip9OUPCJXmst71OIJW9IFgK8C6fSo6bFU0wf9RFYJiYVsr79l5l0/J39H
	 8H6w5Vmwk+ZLkUUsVdG4mtdlE2dSSfaeMeedIh16xsk1lfdBNlmwDFooW5FVL/TzdDhhY
	 RsGp9kMPXdy00r27sTmry8A/3AwrE+zrDQtltrfOEVZ3ry9aONI/N8uRh3v1RFmysVRwJ
	 pbfBBq2GgUTKmD5HufMkbXaKw7617IjnDyJsKWxMGXQQMuzBKNToFcFek12VVFHrqpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PzAAyrqq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F4B606A320;
	Wed, 18 Nov 2026 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PzAAyrqq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6692B1F000C4;
	Wed, 18 Nov 2026 15:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016890;
	bh=x8hvnh+OPxUi3G5DuiyZRvLe/3F2IKbOT8PLWNI/XDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PzAAyrqqe3iarYoWDLPIGE3nWN8xU8rAMI3hDxZOfe5n0Sw96+pbnA4J40KjD/hGo
	 kT061LzIyEw56yA09xCafPmvElOMU47tDvYRP2E+Z5YkfWjydAQgtqk/uHOM9E18XZ
	 oMtKG8o9/1nfC+ysmFl+oxFCN7L43gWpuVDIQBtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0687/2651] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 18 Nov 2026 15:32:07 +0100
Message-ID: <20261118150312.586295838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9735b75ac933a..c08796e4262ae 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -217,8 +217,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
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



