Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179C41E490B;
	Tue, 15 Oct 2024 11:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992105; cv=none; b=Fwa74Rg+aOGQrwMo/coJml/hl6wA0FVK8BjD45k4yKvGNX2pl/0T2jgHE3DT2Eo9ODtwfZ+0nwSeZezOqBAPJ5IPC+bQqd5Dh/16ftrpKthjjLUqHRpqA538ULrTGxKabTNBUPs6I9MKM4Di96Hq09MOHeRtjPi6vVE8uPr1EpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992105; c=relaxed/simple;
	bh=0GpX+7luSCXzn8IOuNy37hmGXYr5HUgqsZXk17KZOxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daPsBkzFAW2D11sEecGXiSALrohc9SCbs+6mQBYrxVlIUuFDtrix/d1tgq1kpJqVXtasca7DYxFG8v+tuMZAR8Zz3qXUK4pssW0C6oEth0sk1UHvaM7gsU1W5sPbF94jOkNysJdWefpIAiFkAJkmREiFKsuryGLPIHgtjMPQXJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4fDdC+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4fDdC+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B8C4CECE;
	Tue, 15 Oct 2024 11:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992105;
	bh=0GpX+7luSCXzn8IOuNy37hmGXYr5HUgqsZXk17KZOxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4fDdC+msnN0Hrc38oQsvomK6nalwK8nu2ZCxVKWqdjNmpoJ9tKtzcIdo4scW8Vg1
	 B1yOymEfmjyDJzYIlKxVoZmu3BXfUGLNPBuRR3Ao1FKUcso5R7MbJPMq8JBr2Gkdyk
	 iyAIuRmi0SRujGSSfCvHWOmnI/Q+83LICkQEwY48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/691] Input: ads7846 - ratelimit the spi_sync error message
Date: Tue, 15 Oct 2024 13:19:28 +0200
Message-ID: <20241015112441.136838981@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1db61185f7be..524e16647b96 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -818,7 +818,7 @@ static void ads7846_read_state(struct ads7846 *ts)
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



