Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2138B214210;
	Tue, 11 Nov 2025 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822741; cv=none; b=LomNcUXisNHw5+9hkb9wPTPj0QC5Sh4Y3MUpEQm72VxCt15nCVuGJ8TbFEO6zKKrqrAacNUVxa0oFz19u55qodTjXm15map12vK+1QZSQGdSHa3CporswmCk+mdexwhLD7Epi//Xcgpcn5JK0QaIxiOyu3kYkymV1kwc/yCohJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822741; c=relaxed/simple;
	bh=0eDW1RrRpb+3MAYImuSUYWDPQKVUvDbiX4BIHlzj2zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHTOjwutTK6W0JD6trVgxaGlJ2TqkOJatAu+kmarVuxFeuCeqSxcJRcp8Avx/f4JerpOwctNKjdBtZstJ7Nlv3Ud3KiBX6hJafEPWaLHGUkDVb6NMNaiWG101HbFWMyg5BFxeJ+DTpJgEmNFe9ijJVqY8EFZ+SHUdsKRxj6psio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlmjVTOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlmjVTOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6B6C4CEFB;
	Tue, 11 Nov 2025 00:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822741;
	bh=0eDW1RrRpb+3MAYImuSUYWDPQKVUvDbiX4BIHlzj2zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlmjVTOZT0LiwO3bzxbSYLJJaJSx9WtAwbjunP0CxYq/MKQLdO0cfSMqWpaLT2loR
	 V5Me1MlGYgEx84ARi2Isea6ps+k1Q5cdxibamQUnepOGUb1/wkeCcDEB4thFIKqhOr
	 ey7/rAviH6zsDii7Z/d+/PsnDUjRVATcJDz15qbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/565] memstick: Add timeout to prevent indefinite waiting
Date: Tue, 11 Nov 2025 09:39:12 +0900
Message-ID: <20251111004529.120835848@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 2fcc40aa96340..b9459c53c3ed3 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -366,7 +366,9 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
+	if (!wait_for_completion_timeout(&card->mrq_complete,
+			msecs_to_jiffies(500)))
+		card->current_mrq.error = -ETIMEDOUT;
 
 	return card->current_mrq.error;
 }
@@ -400,7 +402,9 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 
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



