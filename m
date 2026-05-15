Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163CD3E5EEA;
	Fri, 15 May 2026 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861473; cv=none; b=Xs6mKHwh0SXEee0QI+fG0uGhSN8TzC+f8MlCuW1VyPEUGseYw3GXt1uUrQyYv1bSCyBbEfT+obRx7syA5/JRKCcUh0/9KvjcI6u7YLdPsZvNbwZtpMbuNibtfRRhF41y5zcM4XdHpBWpTQv7qLMVDm+PiDQuUFBLa2TM2pO4Km8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861473; c=relaxed/simple;
	bh=o3i18aSTjtTDaKIeee7OyBnk6ArKDdT/5u7rS8oqTHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Llw99qDucU81MNg1OmLoTAZO1J1PU6FgWgwe2Z2jvp+L6m8FDdp6aXLCRyvQ3N3y2vkxzF1cXPbrHkJE8h1NQaoZtXGUOdCMlD9rKy85jppvoCR1BmgyMPPvUFR2ZDUzLvBKwOchI4l6VAMQVL6m1n3ZgEtr9DMQIT/AbYzpjxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPvRZXDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPvRZXDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E54C2BCB0;
	Fri, 15 May 2026 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861472;
	bh=o3i18aSTjtTDaKIeee7OyBnk6ArKDdT/5u7rS8oqTHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPvRZXDuTZ5T/MFjDp1ckBldFzRDB2mDl7EW76tNFAnfhjmwqjJWJBfDcFY/jy0JX
	 BE+QXTTVY5wAsJHvlOLECCoPzWB7teN0eqR9YG0pmr4hkCYSx+aeiy8QXigU5wLn85
	 dcTUjnAhE/Fin0XzSNNVJNn3RJ+vv+6OBn9rpCxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 335/474] spi: orion: fix runtime pm leak on unbind
Date: Fri, 15 May 2026 17:47:24 +0200
Message-ID: <20260515154722.264525826@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 97b17dd8266d2e26d9ee3c75a0fa34ecde6944f0 upstream.

Make sure to balance the runtime PM usage count on driver unbind so that
the controller can be suspended when a driver is rebound.

Also restore the autosuspend setting.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 5c6786945b4e ("spi: spi-orion: add runtime PM support")
Cc: stable@vger.kernel.org	# 3.17
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=6
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421130211.1537628-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -814,6 +814,9 @@ static void orion_spi_remove(struct plat
 
 	spi_unregister_controller(host);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 }
 
 MODULE_ALIAS("platform:" DRIVER_NAME);


