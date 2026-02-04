Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BBC285404;
	Wed,  4 Feb 2026 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217319; cv=none; b=GBnOHfYTj5X5NG8MsvOkdWvU818rPUf0tK7DhJSEbdLOX+hvmiR2QXPm0yqP/EXIoMQ8uEu47I4u7HtUfb/L7FmHUw6Czh1JTpqhPTuN9izp/C4Ap854UC8SQUJIifi+9NOUR0J6ibW3M1/AH++5MYXR+dhtYrM5QR0i82X5wLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217319; c=relaxed/simple;
	bh=OWNa/J66cYGQbc0DU1ZrQA2j9UNj95iTq/sT5axW2MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upveBTvixyK7S/JByoQz4FsXJqEPs2lguuD8HdJ+3bk60EIjbYgHDDt6Sz1e9l2TjMgMvGAkLImHyORzdc/2+/XkUlL1C60E0VEcz4UjntahxYE7OV3rOZHAvYj7J9VaUCCTH9JtV7g6lJdDQR9hkVx6ZltfvrMot4ZXlHy58f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR/2U4+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR/2U4+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD647C4CEF7;
	Wed,  4 Feb 2026 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217319;
	bh=OWNa/J66cYGQbc0DU1ZrQA2j9UNj95iTq/sT5axW2MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xR/2U4+joA0/qMBl4npNfA6DUxrsYQlaPCP/KUQ+y80Z0PUBCzvHn/pg+55kJ3B+u
	 NRlzW7QRIj+zfGCu6BEEqOFDIeQD2s0e/2gP76DZ5zCy8RH22a5z6s+afKRBftXAjG
	 dprRpe16L8V2WQdlobwjaVQqR/MR3NB80fMjiEtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3a0ebe8a52b89c63739d@syzkaller.appspotmail.com,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Rahul Rameshbabu <sergeantsagara@protonmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 5.15 188/206] HID: uclogic: Correct devm device reference for hidinput input_dev name
Date: Wed,  4 Feb 2026 15:40:19 +0100
Message-ID: <20260204143904.994369708@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <sergeantsagara@protonmail.com>

[ Upstream commit dd613a4e45f8d35f49a63a2064e5308fa5619e29 ]

Reference the HID device rather than the input device for the devm
allocation of the input_dev name. Referencing the input_dev would lead to a
use-after-free when the input_dev was unregistered and subsequently fires a
uevent that depends on the name. At the point of firing the uevent, the
name would be freed by devres management.

Use devm_kasprintf to simplify the logic for allocating memory and
formatting the input_dev name string.

Reported-by: syzbot+3a0ebe8a52b89c63739d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-input/ZOZIZCND+L0P1wJc@penguin/T/
Reported-by: Maxime Ripard <mripard@kernel.org>
Closes: https://lore.kernel.org/linux-input/ZOZIZCND+L0P1wJc@penguin/T/#m443f3dce92520f74b6cf6ffa8653f9c92643d4ae
Fixes: cce2dbdf258e ("HID: uclogic: name the input nodes based on their tool")
Suggested-by: Maxime Ripard <mripard@kernel.org>
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Rahul Rameshbabu <sergeantsagara@protonmail.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20230824061308.222021-2-sergeantsagara@protonmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
[ Adjust context ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-uclogic-core.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -104,10 +104,8 @@ static int uclogic_input_configured(stru
 {
 	struct uclogic_drvdata *drvdata = hid_get_drvdata(hdev);
 	struct uclogic_params *params = &drvdata->params;
-	char *name;
 	const char *suffix = NULL;
 	struct hid_field *field;
-	size_t len;
 
 	/* no report associated (HID_QUIRK_MULTI_INPUT not set) */
 	if (!hi->report)
@@ -145,14 +143,9 @@ static int uclogic_input_configured(stru
 		break;
 	}
 
-	if (suffix) {
-		len = strlen(hdev->name) + 2 + strlen(suffix);
-		name = devm_kzalloc(&hi->input->dev, len, GFP_KERNEL);
-		if (name) {
-			snprintf(name, len, "%s %s", hdev->name, suffix);
-			hi->input->name = name;
-		}
-	}
+	if (suffix)
+		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
+						 "%s %s", hdev->name, suffix);
 
 	return 0;
 }


