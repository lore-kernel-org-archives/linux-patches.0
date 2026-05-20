Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB683D75C7;
	Wed, 20 May 2026 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300019; cv=none; b=uMqPNrZItdMU6mPvH+EJPM7bX78Fc6Qo7CyiOfKI3YF4ukL/a4anu23vNVMK7/fpRLez+UOmlYi/dX05O8YxREmA7bEBGhAAS0l0qopxyQleguh4EmWQCivYqfyyN7WIA8d5/ptaQpF6DZQ1FHpdsE5VkrcZ6x4ncOJejnSNbnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300019; c=relaxed/simple;
	bh=ckLS4rOHKpev1R/BBtGdSM130C05qrPV9Ocvc1BkqzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCKikzqKiraVV3vUdZ3TBp15/SQJIUaKcV6sRN9HV+ZLrbnUzKcxgDfgVIVX1KBZ7QzbpEKojgC7y+GIqgLJkoerEE13YYGVZjA0aBkibUKn4c+Y1d6fvZpCB68XSXDuAYp4m9mZ3y5nieAiU5JECqDVMSIJVdIPkvuXg4dJrZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKJ04rrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKJ04rrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048A61F000E9;
	Wed, 20 May 2026 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300018;
	bh=PttXz+sKHesoljgobQRlMY2uTwaNCgWUWwaH8Iz0eQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKJ04rrSBnHo89sn2DX0S38duFst1+QuLdecAMjugowOLjKDs0NoyE2w2Xhp9mwWd
	 XOWu5CHq70/2REW9lw9wVCe7AI9R8mgn0FJQh9XJ2P7mrbIf55xC4lKcfmvcONURj0
	 LI3Xod1LKsW8PtOe0Yr4qnUIs+DbgtP9qo72nsUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/666] devres: fix missing node debug info in devm_krealloc()
Date: Wed, 20 May 2026 18:13:48 +0200
Message-ID: <20260520162111.603599042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f813ec9e84b4d0ca81ec1da94ab07bfb4a29266c ]

Fix missing call to set_node_dbginfo() for new devres nodes created by
devm_krealloc().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260202235210.55176-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 68224f2f83fff..f229c5b3e7850 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -913,6 +913,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!new_dr)
 		return NULL;
 
+	set_node_dbginfo(&new_dr->node, "devm_krealloc_release", new_size);
+
 	/*
 	 * The spinlock protects the linked list against concurrent
 	 * modifications but not the resource itself.
-- 
2.53.0



