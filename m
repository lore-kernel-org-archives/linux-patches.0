Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8423B3C01;
	Sat, 30 May 2026 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162544; cv=none; b=hAAbiDwH93n9ykBJ3FttbxGxei3nCYA63D/4B+8IeJuskBa8Qqo99S2h1jEJid8CXbbK8YbQJHT/iCOx4UuZok21VZWiN2I0iD3cPPi5v+DuacOrC6ZgULUZ1GYDZEka4VEEAYQ303RH9mrzG7C7u22P8gFns8/g3yTQ3V9rvys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162544; c=relaxed/simple;
	bh=wtIlacO+6rttHMdTk2u1u7ll0yq8Nm0nddppI1FfSaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4fClzcuUCzvmtIoYFYewkeYRgGfwyir6omKK2Q4z+UpTm4PhtYrLG3/6evq9MGLwPijxSQsv0bbt4Sj2PlNNbFOYOZhJRmycmbU9Eub7e0FMVeWuty/M4Dj+JCyL1VUnOKDDY/4TBdFFAgfWx5wxt0tRiIztADoG8UjhAonjgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFU0TOQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFU0TOQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F921F00893;
	Sat, 30 May 2026 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162543;
	bh=sVnaP23HrBuDPimDmMPXGp9Sw8az7D5/j0zxJHklAbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFU0TOQNb6EWgQojMTIIlt8P2gmNWnjNRObkH8ffYkxEH4isMA3bHAYkPgiq1Dp4Q
	 NBToX+XwucjQWNk45du0VvAhBluxbYfa+yMloHTUQkGGxWJ1eto4CvPfVLrKYhUnkp
	 vV7DMHsp5/Rzg6sSaaTeNmcBCm6BFjn2iiqsMn0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 899/969] HID: uclogic: Fix regression of input name assignment
Date: Sat, 30 May 2026 18:07:03 +0200
Message-ID: <20260530160325.532438298@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b35f9f321d41..7658bd678e7e3 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -142,7 +142,9 @@ static int uclogic_input_configured(struct hid_device *hdev,
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



