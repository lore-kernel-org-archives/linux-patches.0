Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4C014AD19;
	Mon, 16 Sep 2024 12:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488040; cv=none; b=DXk6/p3FtdS8UaDSDDKG/BXbMWzYjLZXyxuI6dTzG6ba7r+Koq5717XT55wNJkNLaNkI9LDEe1+C8BApragqLK8mNf03JeNuJ7FkO7WlCSXyirsLjwjcmz5405fgR60O4xQVrf1JLLrScABDW/dtYhO+o2Om6lvxFtHW5xEKD4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488040; c=relaxed/simple;
	bh=adQJ5SHNS8rMz2O5xvhJm70l4/qzTZBZM1ZoJjM5Ezc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptpKrGgLrKEfCaynekuXyRsvTqkyOGiJknaKC6DKq/0JcXTVRCHZ9Y3PD1A9lazFwiUmj9gEf8dHPvPJdKezW1C9TuI5KBVOQGvBL9LwY/Idsoxq62YgQq1lGkHhpu3g0p+7yGOe+mH6nayHh6GL6sbDwj2GSErUd8iHTqK6OPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pocc/bT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pocc/bT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC111C4CEC4;
	Mon, 16 Sep 2024 12:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488040;
	bh=adQJ5SHNS8rMz2O5xvhJm70l4/qzTZBZM1ZoJjM5Ezc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pocc/bT2O+T4Zz7oWrLaTpHclTi4Dea3M9cG11N1gOnXlL2yCPriq90KMy8BNSRtM
	 cHOyiFKmDtiG7IortUP1lp++ylgjrnuTbsjFRSt2Xxoil7eWHJDaUz84ul7vNtwsh7
	 6sqrcXmDhvBCNqpLNk5KMWDutMY4HmnTDptkVb0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/63] Input: ads7846 - ratelimit the spi_sync error message
Date: Mon, 16 Sep 2024 13:43:49 +0200
Message-ID: <20240916114221.407361399@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit ccbfea78adf75d3d9e87aa739dab83254f5333fa ]

In case the touch controller is not connected, this message keeps scrolling
on the console indefinitelly. Ratelimit it to avoid filling kernel logs.

"
ads7846 spi2.1: spi_sync --> -22
"

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240708211913.171243-1-marex@denx.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index bed68a68f330..1f206c75c6cf 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -810,7 +810,7 @@ static void ads7846_read_state(struct ads7846 *ts)
 		m = &ts->msg[msg_idx];
 		error = spi_sync(ts->spi, m);
 		if (error) {
-			dev_err(&ts->spi->dev, "spi_sync --> %d\n", error);
+			dev_err_ratelimited(&ts->spi->dev, "spi_sync --> %d\n", error);
 			packet->ignore = true;
 			return;
 		}
-- 
2.43.0



