Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C20F4C97;
	Tue, 11 Nov 2025 00:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822512; cv=none; b=q+54lS0gm8vmuP6I1vqHqcmo4a9jNaPwCTRHbZumDI2ypvJwpdLxCI9O3bQe8Fpb95DmdNGtNfAGuj4CaiQz3uwshj1UV6eBJO8X8nUQ5SbUavuaRSS24+stGc0dnSSZXCQjs/ILGYpHk/Zrp0fI6EFiB2GztRc/LP9wCJzX2tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822512; c=relaxed/simple;
	bh=GuFXKks4lRBShWjs6jVOjzn3vVDBWEATjCdyrrQyXJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0bSwKt7MtSTDN2DCYF3f8KlQ77Bz6uT7I1uQW4wqROu70vBOEbqPHkH0uC7b3yJlPcn2kskMjXXjjPz3qd3hzWfePO+ZMUQGh8LvmPle2Y9lJaAyBsD8qHmlu30z4cRWpZnfOG4x0YLxhzeP9+rL9xek+0kwuAHNyQ4kVtXFKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwRyfMrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwRyfMrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C23C113D0;
	Tue, 11 Nov 2025 00:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822512;
	bh=GuFXKks4lRBShWjs6jVOjzn3vVDBWEATjCdyrrQyXJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwRyfMrGplmBqtRr+J8m8a4ng7MnDL86ytdBe/jnaNUi6VSRtWxjIa60eQH2cWjZ9
	 R1zA83ugvrc7MTfx2PXRLp/qIn/AouAeDlCuBs28ePst1uQuHfst1d+JrPDWcEVNAW
	 t/e2jQZ4lbpGoga4mVuuzWegQACNLP8QHxOdYgF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 128/849] memstick: Add timeout to prevent indefinite waiting
Date: Tue, 11 Nov 2025 09:34:58 +0900
Message-ID: <20251111004539.489390894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayi Li <lijiayi@kylinos.cn>

[ Upstream commit b65e630a55a490a0269ab1e4a282af975848064c ]

Add timeout handling to wait_for_completion calls in memstick_set_rw_addr()
and memstick_alloc_card() to prevent indefinite blocking in case of
hardware or communication failures.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Link: https://lore.kernel.org/r/20250804024825.1565078-1-lijiayi@kylinos.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/memstick.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index e4275f8ee5db8..acafc910bbacc 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -370,7 +370,9 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
+	if (!wait_for_completion_timeout(&card->mrq_complete,
+			msecs_to_jiffies(500)))
+		card->current_mrq.error = -ETIMEDOUT;
 
 	return card->current_mrq.error;
 }
@@ -404,7 +406,9 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 
 		card->next_request = h_memstick_read_dev_id;
 		memstick_new_req(host);
-		wait_for_completion(&card->mrq_complete);
+		if (!wait_for_completion_timeout(&card->mrq_complete,
+				msecs_to_jiffies(500)))
+			card->current_mrq.error = -ETIMEDOUT;
 
 		if (card->current_mrq.error)
 			goto err_out;
-- 
2.51.0



