Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038993;
	b=izLjFu7b36WZ1eUYbmfeilBxGOKDrbMKiwb6R3pvKLrt3LVWvsrQ82LN62z8wmQT+qtX
	 6OHhPVGm94JbmwzbKaprUCJegK5x1fZmx3dnKTn8zQEluAPzdX+wuxT5IMvsHQ0Z2mwHA
	 Ist47Aq0aCPh+Vdt76O5RzTm6LrRlOSQn+QRaqWC9cyBLT2+lsxkgItghB/BKHuzEhpHw
	 OHCxoBlK/TESWkCdOavPiRK0QxQNjV21lZ41i7qJGimZXhBEkro8pFYpJEJDSN6YEoQS1
	 BQXIuIguubRU3EccXRZakkvNxyF4oCxFLN7XSvLs+Z47n/c0QArqupRStpfA7XbA4nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kZN4mM5E/YMQ57m+WXxRx6kPoa9qfOAozTrQ811+xs0=;
	b=g+CRzbGq2HwT7vd72PqF+GBtHLeNZc96YtYLlEfS9V6A4CE15Lm7zyxqF3gwwo5wkpLx
	 1RVnLlzt8aqLxE9goIEveAsKoN0YWj0ZZpPIEIb+xbR5f+6QKrr9Wf5r2Vnn6V5cE/sX9
	 V/TaP9pP8VlQE8gESCpz/eEzubY3rSVpye0GsuJmYujJtqucmSz+S+5jZkK8iqHOuQqdy
	 Zr3z9bcra7XXMOcAXkd2T4BO2QcoueLOu+TFkODX8oMvcvi5KP7uy5rxe6GJHL8RmvrNC
	 Op/cvAaTVnzRDZ2deFmxIXmDeBUcOYvZoDUyUVPc2KxnLogLB9ycGfCoQ1QCnG7xMRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELHc+xXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A859606A31C;
	Wed, 18 Nov 2026 21:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELHc+xXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B2B1F000C4;
	Wed, 18 Nov 2026 21:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038993;
	bh=kZN4mM5E/YMQ57m+WXxRx6kPoa9qfOAozTrQ811+xs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELHc+xXMbCruXgbomZG/kwaSP/n9QP2tnn0aVyZJPEZAWkhtuYfhxI01q5h2LHIhB
	 FWom33TSQIKhvUWUHVtGL+IBHOy9qxq+dgW4Mc2Pmfnm6k3ixnPQ3qcF5txONMRozp
	 nKYxJ8drOheEwJiYY3MGeyZe/yxtpMeILKz0WU/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Antil <shubham@octane.security>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1941/3318] vhost-scsi: zero misaligned I/O bounce pages
Date: Wed, 18 Nov 2026 15:42:43 +0100
Message-ID: <20261118150420.277493782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the sg_count-based scatterlist loop ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f03170888a896..8aecbc32350de 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -760,7 +760,12 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	}
 
 	for (i = 0; i < sg_count; i++) {
-		page = alloc_page(GFP_KERNEL);
+		/*
+		 * Completion copies the full bounce buffer, including bytes the
+		 * target did not write. This is already the slow fallback for
+		 * misaligned I/O, so zeroing is acceptable here.
+		 */
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!page) {
 			i--;
 			ret = -ENOMEM;
-- 
2.53.0



