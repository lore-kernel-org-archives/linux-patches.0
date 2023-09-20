Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DCD154BF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D03AC433C7;
	Wed, 20 Sep 2023 12:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212171;
	bh=bef2PN6BHHOgAbccQa/KXuvVFU1C/nYm57oN9WFjhCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTOgtaRh12bZA69vTxTZa3azDEoWwRY5b+Pc6OxWA7O5p4vHE01D/mopTzMaL5nZc
	 ghPgo+cLCt0Nq2+5CEZrxS24bScWnk3c9mN9ZM2v0xNd+511P685GF2SHU6dWRmfV9
	 icUO05IGzr8jTZlmBJDGetuiKqZ92kf+9l3cPASc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Rahul Rameshbabu <sergeantsagara@protonmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/273] HID: multitouch: Correct devm device reference for hidinput input_dev name
Date: Wed, 20 Sep 2023 13:30:00 +0200
Message-ID: <20230920112851.471804980@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <sergeantsagara@protonmail.com>

[ Upstream commit 4794394635293a3e74591351fff469cea7ad15a2 ]

Reference the HID device rather than the input device for the devm
allocation of the input_dev name. Referencing the input_dev would lead to a
use-after-free when the input_dev was unregistered and subsequently fires a
uevent that depends on the name. At the point of firing the uevent, the
name would be freed by devres management.

Use devm_kasprintf to simplify the logic for allocating memory and
formatting the input_dev name string.

Reported-by: Maxime Ripard <mripard@kernel.org>
Closes: https://lore.kernel.org/linux-input/ZOZIZCND+L0P1wJc@penguin/T/#m443f3dce92520f74b6cf6ffa8653f9c92643d4ae
Fixes: c08d46aa805b ("HID: multitouch: devm conversion")
Suggested-by: Maxime Ripard <mripard@kernel.org>
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Rahul Rameshbabu <sergeantsagara@protonmail.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20230824061308.222021-3-sergeantsagara@protonmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 4b1c223be9933..6411ee12c7a30 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1540,7 +1540,6 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app)
 static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
-	char *name;
 	const char *suffix = NULL;
 	struct mt_report_data *rdata;
 	struct mt_application *mt_application = NULL;
@@ -1594,15 +1593,9 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		break;
 	}
 
-	if (suffix) {
-		name = devm_kzalloc(&hi->input->dev,
-				    strlen(hdev->name) + strlen(suffix) + 2,
-				    GFP_KERNEL);
-		if (name) {
-			sprintf(name, "%s %s", hdev->name, suffix);
-			hi->input->name = name;
-		}
-	}
+	if (suffix)
+		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
+						 "%s %s", hdev->name, suffix);
 
 	return 0;
 }
-- 
2.40.1



