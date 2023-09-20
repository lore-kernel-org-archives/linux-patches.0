Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C1C156F8
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA23C433C8;
	Wed, 20 Sep 2023 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210224;
	bh=6peOJxDrmByexQS8Mg2hEIzWQJmTZQft/12BXvB4au4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMtAg9kNwjw08Etq7T/isswiK00NN3AlGFcHmGhCwGZ3qeyyesFoJaOmKbBKJc0XZ
	 BcGVdP9PihlSzMurYqtaIDjZH3R9oGjL6F6/D6bL0iEESI0MisGRyxLH1tehKlmrAR
	 /+Wbc+Ny9IwTQgtwAvmminRlCS0LOx0tNGku+5EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Barnes <robbarnes@google.com>,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 011/211] platform/chrome: cros_ec_lpc: Remove EC panic shutdown timeout
Date: Wed, 20 Sep 2023 13:27:35 +0200
Message-ID: <20230920112846.182865715@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Barnes <robbarnes@google.com>

[ Upstream commit f2d4dced9a584612b25adb559c1350243d2bb544 ]

Remove the 1 second timeout applied to hw_protection_shutdown after an
EC panic. On some platforms this 1 second timeout is insufficient to
allow the filesystem to fully sync. Independently the EC will force a
full system reset after a short period. So this backup timeout is
unnecessary.

Signed-off-by: Rob Barnes <robbarnes@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20230802175847.1.Ie9fc53b6a1f4c6661c5376286a50e0cf51b3e961@changeid
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_lpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_lpc.c b/drivers/platform/chrome/cros_ec_lpc.c
index 500a61b093e47..356572452898d 100644
--- a/drivers/platform/chrome/cros_ec_lpc.c
+++ b/drivers/platform/chrome/cros_ec_lpc.c
@@ -327,8 +327,8 @@ static void cros_ec_lpc_acpi_notify(acpi_handle device, u32 value, void *data)
 		dev_emerg(ec_dev->dev, "CrOS EC Panic Reported. Shutdown is imminent!");
 		blocking_notifier_call_chain(&ec_dev->panic_notifier, 0, ec_dev);
 		kobject_uevent_env(&ec_dev->dev->kobj, KOBJ_CHANGE, (char **)env);
-		/* Begin orderly shutdown. Force shutdown after 1 second. */
-		hw_protection_shutdown("CrOS EC Panic", 1000);
+		/* Begin orderly shutdown. EC will force reset after a short period. */
+		hw_protection_shutdown("CrOS EC Panic", -1);
 		/* Do not query for other events after a panic is reported */
 		return;
 	}
-- 
2.40.1



