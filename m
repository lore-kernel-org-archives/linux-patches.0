Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3D236494B;
	Wed, 20 May 2026 17:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296641; cv=none; b=MN31FB4qWc6eZBv9grc+7/HoNimtqNkcWiOBMvMZPo4tgxrPHMT+gBN5wH5nWV4XTCNX75ldEwlvw7KBwoI2zTN3isLWeM5MFBzMvxvAOLknAI8DBZd+gQsX8tvLTsQevFCsfYNECHANU5e/0IOEul/fBwMgmlJF2wIy6HJRoHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296641; c=relaxed/simple;
	bh=PsJZxaeVT1+EE8ck8/usUhssIX0QoiPLFBYiNYRmM/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq/e2HzGp5ACCQklEAeWzbNXD3fK6OEWw0b7M2h7bBBJAId4M8ph2sbmDygv7EhzKzdcR3OC/ETZFFvWY1JDuJPuSJQyDNwg67MdIit6Md/mRdiCXnCIWVG615CAgXmymqCQJA0KxP0Ojypn0RYQFnWRYk5AeI1GP2+Jgw/v1ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNo7A5wl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNo7A5wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8B61F000E9;
	Wed, 20 May 2026 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296640;
	bh=xDfFgJ0lL0vAKbur6ZbYKMC9i7oBURtS/R8qqaMyQng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNo7A5wlGGLQrGg7HJ9BsL+t62KxjkOwklp+sNWKVOYCmFvwTHC2j2FDoJM4Cs64Y
	 vfj+wdCP+q4XLxQBh5j5K8yFr2nOiRDYU7BrUdnuPNniXxNckl0QYoGluEjqdDSC2t
	 0Z2zSKNrMdH6bjYf55GGaL1RyOZj1ovliahcCktE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0877/1146] mailbox: mtk-vcp-mailbox: Fix the return value in mtk_vcp_mbox_xlate()
Date: Wed, 20 May 2026 18:18:47 +0200
Message-ID: <20260520162208.084692294@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 1e0ec9719f58d53da61adf830e81f4af892e4582 ]

The return value of mtk_vcp_mbox_xlate() is checked by IS_ERR(), so
return NULL is incorrect and could lead to a NULL pointer dereference.

Fixes: b562abd95672 ("mailbox: mediatek: Add mtk-vcp-mailbox driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-vcp-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-vcp-mailbox.c b/drivers/mailbox/mtk-vcp-mailbox.c
index cedad575528fb..1b291b8ea15ac 100644
--- a/drivers/mailbox/mtk-vcp-mailbox.c
+++ b/drivers/mailbox/mtk-vcp-mailbox.c
@@ -50,7 +50,7 @@ static struct mbox_chan *mtk_vcp_mbox_xlate(struct mbox_controller *mbox,
 					    const struct of_phandle_args *sp)
 {
 	if (sp->args_count)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	return &mbox->chans[0];
 }
-- 
2.53.0



