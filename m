Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D593D75AB;
	Wed, 20 May 2026 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302636; cv=none; b=pgyC6k3fv2FnFyKliPdMIY8NuU2fPB0/DKLcY0J16ROk7AIBfrRCRnjdn4NzEF8hu0ACWM392o94F67CBZihRtvuwr0qxOHZOIXZNhgvwj2TT5nkmNuFGytX4EHiH6woAhyOABmH9ECWZoI7CgIRi7Mzsok/+fZiib/qgOAGVdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302636; c=relaxed/simple;
	bh=+fP5E1ofnzz/w9JrXcr/azGcG3jWOtVau1JdJZylCyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV1NyZqtSu7xuNoztTwis2aV25lxW2O1j6IhtHmvxb5mmLTJkaHV53Sx77u7aWDXdvumhqOkcFYOhOd72oJHBSqTp7wB5jgxWLWaTmyfuHkfJgB7mwyawi2Ml2haHxyf4y6T7gQoVzcuDbQ9Ym16T0VHvRX9RryhIF3M80KXiW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMa3ojYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMa3ojYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390711F000E9;
	Wed, 20 May 2026 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302635;
	bh=f3pDz9p0Vf43eXHVsiSR/E5BG7JCach/2zK9gm2vSbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMa3ojYfTrw0Ou0Pa8wPbU5EUUSe8jipSIbQKHkTTlJEhSPO4M9WCw4QzkktPnvL9
	 VtsC7U4tzG41KODvGNATnSfAhlA7VSE57fjPG3tB5pG23iQulkZzj2L7aOghBT0ax5
	 MqvyztqbaKxueM5ll+4gnETZ+2KqmX+XjULxyYao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 340/508] ksmbd: Use struct_size() to improve smb_direct_rdma_xmit()
Date: Wed, 20 May 2026 18:22:43 +0200
Message-ID: <20260520162105.998471203@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 9c383396362a4d1db99ed5240f4708d443361ef3 ]

Use struct_size() to calculate the number of bytes to allocate for a
new message.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: b32c8db48212 ("ksmbd: destroy async_ida in ksmbd_conn_free()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3528ec33919d5..10ceade590529 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1407,8 +1407,8 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	/* build rdma_rw_ctx for each descriptor */
 	desc_buf = buf;
 	for (i = 0; i < desc_num; i++) {
-		msg = kzalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
-			      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
+		msg = kzalloc(struct_size(msg, sg_list, SG_CHUNK_SIZE),
+			      GFP_KERNEL);
 		if (!msg) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.53.0



