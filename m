Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0822DAFB9;
	Tue, 15 Jul 2025 13:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587578; cv=none; b=Hi+1bGsQBCmgx+V6++HBxwjd8Te4EAKjKlIeX6b0PSFk9LSk1LmlNxvR3YoYrL7rX9gY/56Sxpb8kCLhwpKNVAMd2tFQWRmJuBMfdCdvOByoSU7Zqn/j4hM5lwGssuVmVUXRTyQnfaBOjFcTE1T8Bw2epJF0eSOdbf9HpbvRZ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587578; c=relaxed/simple;
	bh=mijITuDA+rsojxYR0jBPPARFoaJxjI667aYWYcXIJlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1eJ8bIPicKKNpHJNmH0PnqfHWK55S1guaJ2dfef8vX/c4OhFnxTKhIzMtvsvt6ZlIQ/JxvJQjMfGeHZzvy/K2GvsO2G9H296+u1Bv7temoGW6GcNEh3M9k8DxlpaXKEJZuw8sEzBjBsWSvxB5xOQ4D0+/wu6uaEUSS+QWOF2PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOfZbE6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOfZbE6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F13C4CEE3;
	Tue, 15 Jul 2025 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587577;
	bh=mijITuDA+rsojxYR0jBPPARFoaJxjI667aYWYcXIJlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOfZbE6ogYTaVw5D6M4IYxfQ3qJAUAW/14npgyMekVu2pkB324YxqxuQqQXyR8xuX
	 aclK9yDCdKFIznzbklVoTRvZRMU9IDjZmJwcO1/L/1DqtBOqjAOI0PFllmiZb1U0gr
	 4ifQGvM8IBVVLhaDrskT/5NRILkMbrJk5qhni8uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Werling <brett.werling@garmin.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/208] can: tcan4x5x: fix power regulator retrieval during probe
Date: Tue, 15 Jul 2025 15:12:22 +0200
Message-ID: <20250715130812.157482121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Werling <brett.werling@garmin.com>

[ Upstream commit db22720545207f734aaa9d9f71637bfc8b0155e0 ]

Fixes the power regulator retrieval in tcan4x5x_can_probe() by ensuring
the regulator pointer is not set to NULL in the successful return from
devm_regulator_get_optional().

Fixes: 3814ca3a10be ("can: tcan4x5x: tcan4x5x_can_probe(): turn on the power before parsing the config")
Signed-off-by: Brett Werling <brett.werling@garmin.com>
Link: https://patch.msgid.link/20250612191825.3646364-1-brett.werling@garmin.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index f903f78af087a..4bdea945c4862 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -417,10 +417,11 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	}
 
 	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
-	if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
-		goto out_m_can_class_free_dev;
-	} else {
+	if (IS_ERR(priv->power)) {
+		if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto out_m_can_class_free_dev;
+		}
 		priv->power = NULL;
 	}
 
-- 
2.39.5



