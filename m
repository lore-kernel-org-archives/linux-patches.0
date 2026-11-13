Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590365;
	b=MQkuLlf2kokasCFA/kQEFNt/jaDwLiw5eJ9dM7oMRQ2dJ+nXROtXQdHyoprTUUOaS2Nq
	 c7k4EZITpimixOJ5XGiyW/GIHQEAwC7nGkXK7GggToEIdIkchrqEvE/zeGub13BjMJKAl
	 6OH5q3QLrF2KmFOmIO4iR19NRJMq+kvFKABxIw/5BMok8o2hKQohlxAp0v33BDzEKgtFH
	 1RQQoHhqP+SMCBZx2EuEfOayrDx2jF73uWIOB8+62IXv3PRwXdsz0xXiLyzu+U2nSjnGm
	 LvtipZjonltVmi1RdZiIFGSqFzyk11ifesX6Pts6NLavk6uVZbTyCUNRYbzOm/71UCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aFyZBItxGSFSbjy8kEsjzvDDmpPfbr5RIz3r4tsyAa8=;
	b=Th03vu8raf1F6EpP6BWEC4+NQvoQTS+LsLFYF4V5JXNl617g3P1t3cu28Md+e8u4XEuo
	 SvJGNdK0t/re6aAUtq6NCU75Dla4fgfJwj5pndc9Pxs3VthgyXoJl3dtyPCx1+LlO98UZ
	 wlx50/zLNTqLepulK2ZC0fDQ6MYUGr9ki2DdMxaMkupfZ8uvr8YWwq2DEVZcSolbezBll
	 svrXV6zdNN8w5M6BKrMdgF5/nYroEyoWFb/s1Jn2F7iQGyMCNYZCLgS91wmQB2R6xIe5s
	 otVYxksRknLLm2dPzSCUtddM9T+oyhK49snrd9/n1zDhgjxYv2SrDQnOqRR2UUsC15g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4l9ngNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137B4606B340;
	Fri, 13 Nov 2026 17:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4l9ngNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B89E1F000C4;
	Fri, 13 Nov 2026 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590364;
	bh=aFyZBItxGSFSbjy8kEsjzvDDmpPfbr5RIz3r4tsyAa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4l9ngNm41d1hIf/MjVpEOM/DKPmk9yu7okHhT3gy7EZXZWHUMcUc70telPdjae+0
	 Uz/oPoteiDTc3qY2vacqoaqpEQwXpz3TXBDZUDFwFii4p+5p7N8Hraw6jVx2yDCniC
	 XGStP9cxq6RXKog0VqxN19cRDGX1X6NfUNUTydnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Antil <shubham@octane.security>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 339/686] vhost-scsi: zero misaligned I/O bounce pages
Date: Fri, 13 Nov 2026 10:47:52 -0500
Message-ID: <20261113153832.424539972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Shubham Antil <shubham@octane.security>

[ Upstream commit 01c3a5fa6d641c93c7cef4fb25c5f12938316e18 ]

The misaligned I/O fallback copies the full bounce scatterlist to the
request buffer during completion.  If a data-in command transfers less
than requested, part of a newly allocated bounce page can remain unwritten.

Allocate bounce pages with __GFP_ZERO so all bytes copied during completion
have a defined value.  This path is already the slow fallback for
misaligned I/O, so the added initialization cost is acceptable.

Found during an LLM-assisted source audit and validated with a QEMU/KVM
vhost-scsi target using misaligned data-in commands.

Fixes: 5ced58bfa132 ("vhost-scsi: Fix alignment handling with windows")
Cc: stable@vger.kernel.org
Assisted-by: LLM (OpenAI Codex, gpt-5.6-sol)
Signed-off-by: Shubham Antil <shubham@octane.security>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261020105503.75904-1-shubham@octane.security>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index deb4c8bfd3d57..fac400b25dad7 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -906,7 +906,12 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	}
 
 	for_each_sgtable_sg(sg_table, sg, i) {
-		page = alloc_page(GFP_KERNEL);
+		/*
+		 * Completion copies the full bounce buffer, including bytes the
+		 * target did not write. This is already the slow fallback for
+		 * misaligned I/O, so zeroing is acceptable here.
+		 */
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!page) {
 			ret = -ENOMEM;
 			goto err;
-- 
2.53.0



