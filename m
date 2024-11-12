Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B72141AB;
	Tue, 12 Nov 2024 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408042; cv=none; b=Pv4PTg7Pf5OXiccltnEpTvkuxDgKj5bNpKs1Q9uc00KjlwZzvZ40/6m8MIQINYme0toOuZVzsoBH6oqIScWhqOQXV7Ke9mXKrO7/VlbCpE9vL4CKMRjU0Tzez5200aNQMrgfNXmeFOtU+hfnVSckEdfFfOkNSlXOt46yHfM0wS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408042; c=relaxed/simple;
	bh=F7INGCg7fF+0ZLSjvx2eN6u7w9OFH+RlY1omxnKWsI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pu/BoXvotnlWkGUM2CHs5pU63WVm0r2nuvbOz0I/9g1tpnu96UcQeuDjEomwy+2KZNblhi0VdazX8f4x4FrR1XqmuIot8JEXoYnzdA7BfNvi0NiTkVHCLN8N54vujZ4YJgjuJBL+3O02Ah/AAvCKuBarlGkcgpparxSu0jBo+gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nho/Wf+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nho/Wf+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9816C4CED4;
	Tue, 12 Nov 2024 10:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408042;
	bh=F7INGCg7fF+0ZLSjvx2eN6u7w9OFH+RlY1omxnKWsI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nho/Wf+Pmw1LQoWKcvynMhsMfNL3qrmwoZ31lkp6Hx0RofKk0wGCwrilerKGDR31q
	 t4EI1sE+azK9kAKXRwaaS8142jEcmshNE+sQh5cl3rTIeMy3Ev/QR0Gpf29/Jt4/6S
	 g97Z1ooaG9hS8ZgHbeAYCo+AeRC08u+1uztj3rTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Madalin Bucur <madalin.bucur@oss.nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 042/184] net: dpaa_eth: print FD status in CPU endianness in dpaa_eth_fd tracepoint
Date: Tue, 12 Nov 2024 11:20:00 +0100
Message-ID: <20241112101902.480875219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0144c06c5890d1ad0eea65df074cffaf4eea5a3c ]

Sparse warns:

note: in included file (through ../include/trace/trace_events.h,
../include/trace/define_trace.h,
../drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h):
warning: incorrect type in assignment (different base types)
   expected unsigned int [usertype] fd_status
   got restricted __be32 const [usertype] status

We take struct qm_fd :: status, store it and print it as an u32,
though it is a big endian field. We should print the FD status in
CPU endianness for ease of debug and consistency between PowerPC and
Arm systems.

Though it is a not often used debug feature, it is best to treat it as
a bug and backport the format change to all supported stable kernels,
for consistency.

Fixes: eb11ddf36eb8 ("dpaa_eth: add trace points")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Link: https://patch.msgid.link/20241029163105.44135-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
index 6f0e58a2a58ad..9e1d44ae92cce 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
@@ -56,7 +56,7 @@ DECLARE_EVENT_CLASS(dpaa_eth_fd,
 		__entry->fd_format = qm_fd_get_format(fd);
 		__entry->fd_offset = qm_fd_get_offset(fd);
 		__entry->fd_length = qm_fd_get_length(fd);
-		__entry->fd_status = fd->status;
+		__entry->fd_status = __be32_to_cpu(fd->status);
 		__assign_str(name);
 	),
 
-- 
2.43.0



