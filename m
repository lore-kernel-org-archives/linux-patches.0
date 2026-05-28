Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8382E7379;
	Thu, 28 May 2026 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999751; cv=none; b=eZGelHM35+E92UtMquFYn6tRQ/iQw4CmTYUAeq5yLHxa1MkUfOEaOPo6hgPOGGMSB5yMQkvAC3epTlI4kC8PZqv7FFzcZe/ALnI7DbKTsbhKYtOVc6tobLAU3rvu7qABtFURS1CU7Ys4uscXdW73u4xIGxxMVOj6IEfYaFOLAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999751; c=relaxed/simple;
	bh=BX41s6CSyNGvX31jFsnzWZd4K/mzYqZLPc3rukG+DH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhXkaLWODKbh0P9wwfO9ZhFjyrhRK5S86fg5DtMSTdcMH9qotRlVaNA+TIx6MlnpNEHRcvQ9Sihcqg1arZHBYsRWWzpirvMNmbKF7MasZOyJHoVuNr48MPKy7Ry/5ta+M4b1lFwNFkyUNL8tMNXWBLlzKg3XNmd3kiiW7ZRJTLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKcQ8rI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKcQ8rI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AC21F000E9;
	Thu, 28 May 2026 20:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999750;
	bh=zCVIHuN/qnYVxiFo9TlnvX9XeRUQCUUB9f4SYEhgPqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKcQ8rI0swB2S+wwT/rOWZjXPRntlEn5X3XqEAKzeA5YYBwwhe3qlR5RNtX2zxFIQ
	 j3qsLFxl7dJ61UpMf46OYVGsvhPWmiUb+lXcAbDgEZm+V9PAvDohdffqO3hRkt2Fd5
	 bUHk4AvmzWKxV/ePxh5kMIBMqWgbXcOOfP0dgkr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/377] HID: uclogic: Fix regression of input name assignment
Date: Thu, 28 May 2026 21:46:56 +0200
Message-ID: <20260528194643.574226396@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 487359284509a6745e14b8c0518768bc277809b0 ]

The previous fix for adding the devm_kasprintf() return check in the
commit bd07f751208b ("HID: uclogic: Add NULL check in
uclogic_input_configured()") changed the condition of hi->input->name
assignment, and it resulted in missing the proper input device name
when no custom suffix is defined.

Restore the conditional to the original content to address the
regression.

Fixes: bd07f751208b ("HID: uclogic: Add NULL check in uclogic_input_configured()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 34fb03ae8ee2f..c6db3e7c5fd30 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -184,7 +184,9 @@ static int uclogic_input_configured(struct hid_device *hdev,
 			suffix = "System Control";
 			break;
 		}
-	} else {
+	}
+
+	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
 		if (!hi->input->name)
-- 
2.53.0



