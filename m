Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C665359FA7;
	Wed,  3 Dec 2025 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778901; cv=none; b=YYCfKEzvRZq0RB6zWJ/GdUDQHf59ifLXajRTklwV/2J4tDtd2taexWR3fGp2AxPcHyxvGCYtky9dWUUzUvsE07XRNU42/4SzX2Y9BHoDwGVz5dYQBbta9GOqFo1fJ+QwAHqrqQu9tpctrUHrvO/n2yNA0yVq/xMCsJzXiFxFX+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778901; c=relaxed/simple;
	bh=0Cx4fmfFLBztLaOgXT9/hW49M1sx2+CVVZToq0BCxJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImvFM2Z4MHn1+pImkWFv/Nh411JNXUs3BO6U+XN2y+c2631rqTadBUu3D3X7pJikdOthX/+SrolTt4H7s0bSBD4+RUkhDJfBbmiq2GOuspvwc25jwBWXopfB4uEhQJix/mlLFbSk8OUAGWqKC31dh6diZ888Wts8ySPaiRh8OLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyiUYvOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyiUYvOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92765C4CEF5;
	Wed,  3 Dec 2025 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778901;
	bh=0Cx4fmfFLBztLaOgXT9/hW49M1sx2+CVVZToq0BCxJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyiUYvOeqTv9fcPwBKSgMvSdFKhyB5G3oHgCGqHCU8HtEJQrlMCcZMQBzVnRSbrj4
	 Fn2Zh6vSUQ+qbvXN16oNornYCmkomT5A471N9ORVwYEROlfKu0tOPW+4vdL6/2NlhG
	 ryXLCG9IIExwvem1MPXXqVNeTcTtZebg473sq96o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/568] memstick: Add timeout to prevent indefinite waiting
Date: Wed,  3 Dec 2025 16:21:36 +0100
Message-ID: <20251203152444.180822265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a2acf5c40143..fc9e6db3bb72b 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -367,7 +367,9 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
+	if (!wait_for_completion_timeout(&card->mrq_complete,
+			msecs_to_jiffies(500)))
+		card->current_mrq.error = -ETIMEDOUT;
 
 	return card->current_mrq.error;
 }
@@ -401,7 +403,9 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 
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



