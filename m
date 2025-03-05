Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF6C17B505;
	Wed,  5 Mar 2025 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197948; cv=none; b=NYFVhLwvty6qLx5GzNXb5Jszecd8U1wAqkiditShERR1js1KsX+kQd4CnWD+uJHBC2sTZz/nImSieMPgG5Uni746/ixNo+dKeMW9R5oWF3OxMwe1RkI/jzXJSY1Wltery3SOv6AW1H3rAlmiYuE3cy89BC1ASiSZa/Lds031T5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197948; c=relaxed/simple;
	bh=BLsa62CL//ILVE3iApaVhamTl32qAv/SUTkRAyrGuY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucpL9BE+DoZvO4xX3Minw3uZMshqkehR9ttwJw7B8ii1iHeJnRYp/sJC5EihpVOHPtxERuHnWnZ7vHvYrrcg5R/AG+12qCVZzOBxQjZe+LOOdcZjQDijUc8ltHK9SD/hIjkkjUKm6kU7NLkHh6RyrxQFWoLrHy612iC04Murspo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBVwqeDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBVwqeDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42364C4CED1;
	Wed,  5 Mar 2025 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197948;
	bh=BLsa62CL//ILVE3iApaVhamTl32qAv/SUTkRAyrGuY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBVwqeDz29Ng5RNW8HhNuzR5jf0wQcnBFxZv7BGvbGAyB+qVTIvVevUj4aq1D2ANV
	 cYd4kWCkniRFWp63PWVDjBLSEtSkv7ax3iOfEAcSt8Kdo+3tqZHJPSh2JahFristLT
	 344BvQPDdCCA7pvHRs5PwXWELQAC/LlnKSk6uwgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/150] RDMA/mana_ib: Allocate PAGE aligned doorbell index
Date: Wed,  5 Mar 2025 18:47:14 +0100
Message-ID: <20250305174504.022010684@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 29b7bb98234cc287cebef9bccf638c2e3f39be71 ]

Allocate a PAGE aligned doorbell index to ensure each process gets a
separate PAGE sized doorbell area space remapped to it in mana_ib_mmap

Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1738751405-15041-1-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 67c2d43135a8a..457cea6d99095 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -174,7 +174,7 @@ static int mana_gd_allocate_doorbell_page(struct gdma_context *gc,
 
 	req.resource_type = GDMA_RESOURCE_DOORBELL_PAGE;
 	req.num_resources = 1;
-	req.alignment = 1;
+	req.alignment = PAGE_SIZE / MANA_PAGE_SIZE;
 
 	/* Have GDMA start searching from 0 */
 	req.allocated_resources = 0;
-- 
2.39.5



