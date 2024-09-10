Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C44417BB0C;
	Tue, 10 Sep 2024 10:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965034; cv=none; b=PX2fOI95eIbj4/ic/ToNH+fNrazcX8I6AsOTUJlZrBNwfsV62/cO4a+Q020jtTscRNNAUR5DyYLiKf7b4w16KM7Lo88Tq16WZospZlmGRH1+RfFX6pRjP0RLo/tT/UolYJzVCtqunmFA9NNk1cpAB0JeWSJB+MQDD2Oq9UEG8OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965034; c=relaxed/simple;
	bh=UKhzNOPUaiDqDwls7Yr1BmQXWDTUSKizDz+op2KWjME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVoWW1CLTqHPw4zlBbxyjl3e3MXGLWZlYBW/PmS2bZ3Y2zt1pMOFd+reEI2HApsIXL+/tMlbsWEbb4y81FJC81w+O/aqCo+Rtvn88YquBNHwdHOc+q9zxIU7sISnWgrTOmxOZytjbr0Qq0CNpTSKdrhKDjvQHfbBKuJrH7LVqDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSMuGv+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSMuGv+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88BEC4CEC3;
	Tue, 10 Sep 2024 10:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965034;
	bh=UKhzNOPUaiDqDwls7Yr1BmQXWDTUSKizDz+op2KWjME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSMuGv+w+XZa/eCfBlEMZJ+EyeSrS9uYB17be8rb2Vx7XNrjzG6g7sFAOY/lQJ81x
	 ZwlPUi5RXx1ztjG45iWD+MrH+w5d1ZD0C+RX52YtQ3C/2N0B0sql/76U/CqvWp49zG
	 B12ZigJ9jH2WcnxmA3DJTKsxcWnZ5XxvV8/V1/Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/186] svcrdma: Catch another Reply chunk overflow case
Date: Tue, 10 Sep 2024 11:33:29 +0200
Message-ID: <20240910092559.227766007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e5decb2eb5f4d1f64ba9196b4bad0e26a441c81c ]

When space in the Reply chunk runs out in the middle of a segment,
we end up passing a zero-length SGL to rdma_rw_ctx_init(), and it
oopses.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: ffc17e1479e8 ("platform/x86: dell-smbios: Fix error path in dell_smbios_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 80a0c0e87590..7c50eddb8d3c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -460,6 +460,8 @@ svc_rdma_build_writes(struct svc_rdma_write_info *info,
 		offset += info->wi_seg_off;
 
 		write_len = min(remaining, length - info->wi_seg_off);
+		if (!write_len)
+			goto out_overflow;
 		ctxt = svc_rdma_get_rw_ctxt(rdma,
 					    (write_len >> PAGE_SHIFT) + 2);
 		if (!ctxt)
-- 
2.43.0



