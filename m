Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2951DF96E;
	Wed, 19 Feb 2025 09:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957261; cv=none; b=VMjVE0IhHt3riaOLXhGnT2OrRBlT0KA0iNIyM3gAqp+d6g6rzMsKwvi1xStMNNbYUSiX9pPguSTf/ImDvNoWuIq6lKIoYQ3wdWTtqBj3YZzQYDokKEs/J4khWcO0pGu78sw5U9LA0elUfyuvETTHav2Sxxz48FBd12yHm2aR7R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957261; c=relaxed/simple;
	bh=Hcfp9n4jcutUrA4REW6NPt7B8AJuxTdCYYdCkqtkucA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz1dXjoSP2V1/2NpJ9dhotR1ludrEEXARQFDUZVEEIym1FGQCntkg3IrRsjF7CTo/+IavYQvUaJ9rgZTX4fzMybwK+PbzAf+kIFpsSj5TXlmIpOEEwJAzQeK4DQbzlpxcs+OtGKxpVPIeDWjfneYyxObDBCneHRQwxf8Yw8XZoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg+AN9x+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg+AN9x+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8658C4CED1;
	Wed, 19 Feb 2025 09:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957261;
	bh=Hcfp9n4jcutUrA4REW6NPt7B8AJuxTdCYYdCkqtkucA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg+AN9x+gIN28syxcjDBtJ0ZdXYO5TWLSKPM7dQMTqm8n8nI270//JzsIqhxSMy9S
	 eHBks7EQiaMIprZ26UHxIBA29aqK1Xf8NQVwFv9R0KsznAEdVnztJ6K3r5tAhGmCOc
	 F2tcP+9x9iqEGrAGYa/U6yvj7YJk4eBoTVcKaylU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 465/578] HID: multitouch: Add NULL check in mt_input_configured
Date: Wed, 19 Feb 2025 09:27:49 +0100
Message-ID: <20250219082711.298659216@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 9b8e2220d3a052a690b1d1b23019673e612494c5 ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in mt_input_configured() is not checked.
Add NULL check in mt_input_configured(), to handle kernel NULL
pointer dereference error.

Fixes: 479439463529 ("HID: multitouch: Correct devm device reference for hidinput input_dev name")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5ad871a7d1a44..6386043aab0bb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1668,9 +1668,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		break;
 	}
 
-	if (suffix)
+	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
+		if (!hi->input->name)
+			return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.39.5



