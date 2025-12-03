Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260B308F2C;
	Wed,  3 Dec 2025 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775975; cv=none; b=bPCVKjXhHBFfDpsSswyc9Uwjyf4+dqcocCICt3Scck7IaOLgY7amk3C9nIoOsU2J7w8fT0uroDuQQtyLwl+0s/3IoC2wAz+nr4UVc69LCXh4EsBfkYfsovYbhdwsSxB5sdH9GWmyv33c/IcgJ8HkzvY32sL0QMn/VZbHVWHv9OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775975; c=relaxed/simple;
	bh=3Q40rsJ5NWDEsFAJNneUisY+h85Nr47zt/K4vxKNaMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8LB7FxU7yGsAYypYjTe+wmyW4woxAMwZqzFnhVez2KGTHYuYVh5X2jSKuyNLji6XUcg1X9UDHgWNzq9AudW7CdI1Mr4dqmN0z3W8V+k5wbuQSlLQwN2PL7KEZjo/SHgFDbcVFkwwDbPE1fgByFaRChV4rk5oydvyyvXGBMhK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Khv85igs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Khv85igs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5196AC4CEF5;
	Wed,  3 Dec 2025 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775975;
	bh=3Q40rsJ5NWDEsFAJNneUisY+h85Nr47zt/K4vxKNaMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Khv85igsRiORPgGqeu7yFI8k9SJuny7/n6EHpELqk2Rc48BDtXCjghXLkHORtQQux
	 a1gTpjq5NhqcypmYuq5Qd5LmtwaCCu5Owl3vPQ/6RhuUq2KI6aHkcLoWwhTevWsVi8
	 ssna7kH49k4W3UzHPA7JKmdGQYHQp5bXHgGZeWPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/300] memstick: Add timeout to prevent indefinite waiting
Date: Wed,  3 Dec 2025 16:24:08 +0100
Message-ID: <20251203152402.246628462@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e24ab362e51a9..7b8483f8d6f4f 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -369,7 +369,9 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
+	if (!wait_for_completion_timeout(&card->mrq_complete,
+			msecs_to_jiffies(500)))
+		card->current_mrq.error = -ETIMEDOUT;
 
 	return card->current_mrq.error;
 }
@@ -403,7 +405,9 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 
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



