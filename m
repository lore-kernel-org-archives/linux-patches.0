Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE48262FEC;
	Tue, 11 Nov 2025 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823080; cv=none; b=S0bO5Ny7uhCxQxGyk1tJQHLezHTZ3zYcJGAP0aCFGfidfucNg9Z+K7SZ0h+/A3TsCQcv9xmbuE0xMYsDLpNHsNaL4poRsKArxHI/Ykz+KZ/mrNnSQEFHVL38Bupjo8uIWnLhpt1uEKdPwqaIyTA8oXX/EOUOHf4X4Biog6FVh9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823080; c=relaxed/simple;
	bh=kKONOwfPg1seRgTrCaGvjGWxhvTkwU1ckVCPA2dJ5Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlOESKfTjXO1OlezaVVc+1h/ptCGWg46Xi0HoIja94Y5vA3tYIL10q4DQ78+EJgYlBaP8mxFwi0VJaQd+6pJhFldgkZZGd/tPoZ34ftd7qgdEX4iYpNcaElvwDv/A+kz9BLh1Yb7zpWEqbQPsj15g9UwHftgCaRaOyEJLXswy18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5GD/oX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5GD/oX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB332C4AF0B;
	Tue, 11 Nov 2025 01:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823080;
	bh=kKONOwfPg1seRgTrCaGvjGWxhvTkwU1ckVCPA2dJ5Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5GD/oX6ERnqT8rtaZF9FKXG4vyhaYd5yUwE6kJCc9kA12tbnkKQERj5bR2GOzVyL
	 tOVYmv1tWHcjHgCkDmpWWndLb58R2Rqn5sRPZ1jJ8RlSju2OIb6izva2HjLaamhpL0
	 3ShrdtXJbAZDk9Ml5aodtbcHelytVl6oY8TrvZSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 227/849] mfd: cs42l43: Move IRQ enable/disable to encompass force suspend
Date: Tue, 11 Nov 2025 09:36:37 +0900
Message-ID: <20251111004541.929795836@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 62aec8a0a5b61f149bbe518c636e38e484812499 ]

As pm_runtime_force_suspend() will force the device state to suspend,
the driver needs to ensure no IRQ handlers are currently running. If not
those handlers may find they are now running on suspended hardware
despite holding a PM runtime reference. disable_irq() will sync any
currently running handlers, so move the IRQ disabling to cover the whole
of the forced suspend state to avoid such race conditions.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250903094549.271068-6-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cs42l43.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/cs42l43.c b/drivers/mfd/cs42l43.c
index 07c8f1b8183ee..959298c8232f4 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -1151,6 +1151,8 @@ static int cs42l43_suspend(struct device *dev)
 		return ret;
 	}
 
+	disable_irq(cs42l43->irq);
+
 	ret = pm_runtime_force_suspend(dev);
 	if (ret) {
 		dev_err(cs42l43->dev, "Failed to force suspend: %d\n", ret);
@@ -1164,8 +1166,6 @@ static int cs42l43_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
-	disable_irq(cs42l43->irq);
-
 	return 0;
 }
 
@@ -1196,14 +1196,14 @@ static int cs42l43_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	enable_irq(cs42l43->irq);
-
 	ret = pm_runtime_force_resume(dev);
 	if (ret) {
 		dev_err(cs42l43->dev, "Failed to force resume: %d\n", ret);
 		return ret;
 	}
 
+	enable_irq(cs42l43->irq);
+
 	return 0;
 }
 
-- 
2.51.0



