Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319D34DCEA;
	Fri, 21 Nov 2025 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732371; cv=none; b=aAl2vQilPf2Mls/Zza+IkIDk3PSji7tbFwRw6pOh5N7RxCsSwkVzX0xVHeAARTxwjnUrj6wyMnIKYn3CLJbwOqshJXB0EGEAHbiNeeVwYrOiTKno51/G2jbHDXvg3ZAH0hgYE4RvWu9RVQwz5I2e6PXzzbSzQu/g5nNW5uHvKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732371; c=relaxed/simple;
	bh=p5IaFjaxHaihUosYB4MV66PRmM952DJ110BMyg0P7OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeFZp5mWJ8iMYs2SvjE9eOYySVXDlvTd8w0FeJcvELSKSfBkO+rVnim131yBAefIui5S3/znVtdhBGyLFEuSL4oE6745dE1R94AwTyeiDaFtIbgWF/W0Qk5HIFFRWQXYSnQXQEd3QOAGqwbiAnkvL7CY6VZjB6yFtSeRrEuMBYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7pvPhdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7pvPhdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07A3C4CEF1;
	Fri, 21 Nov 2025 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732370;
	bh=p5IaFjaxHaihUosYB4MV66PRmM952DJ110BMyg0P7OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7pvPhdV+xc8QSwl1Ie2FyLHHSdLrxxnnJ6fPcrTPfM+Lhm0h1vU3OVd2I7TqaMC7
	 6w9y17GT3hz7qiWQ7fuWfR0fnGe5e/344en4sQxZQnlbNpzDIUi3HBN/AzK2wIt8oJ
	 /f36oSDKHuDyj/7kqPLTVL9swPcWd4FgeKNBcjvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/529] memstick: Add timeout to prevent indefinite waiting
Date: Fri, 21 Nov 2025 14:06:03 +0100
Message-ID: <20251121130233.303819810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index e0895e979e35b..65af43201b693 100644
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



