Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D03C168C4;
	Mon, 27 May 2024 19:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837514; cv=none; b=LtTHE9mag0FhieMyDVHujq7P/Ath2oAvwROSnH+/h5wxVQ3zs/62+BiIZTlYknXNPyBTlpbhmh3jnmzSejfNGJSCp4DtUxc9QQXVgSwhvnoFQVRAKfprV89HubfU3FeWf8weqnnVZ4+e7Ba7wASwDxE1T+GE8d5tpodsxmY/GQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837514; c=relaxed/simple;
	bh=oiMzzDuALkkolELyxKtgD+YizMUg9bhje431PKM8U+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVmxIvcLkH0bUhFB51mraNqZZuw3+1xKAUtLsscpzoyKs/kw1zct0UKu5eNpwku5uJMboWwZGdbfcZuStM0PJQ8++NwRaGSbVEy8K0jKW1k20GJgjwY6m62tYswAczlD5SgEWDtpwQeqM32K3qwV2cYxaxURcs6w7lpj1svfgPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYjGOyl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYjGOyl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A09AC2BBFC;
	Mon, 27 May 2024 19:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837513;
	bh=oiMzzDuALkkolELyxKtgD+YizMUg9bhje431PKM8U+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYjGOyl+AdG8jDIFVGF+0TMITY4HPHV3DvVq6AZxoJnv1IrpzTiKXCBHbaDcQpCEn
	 2ClMnbZu/1t8OdXi3BN0u0zBoF9tgynUqKduC7EcdXnN0RGFJk7kSANSD2PbVo4jU+
	 h5Ujoqj7Dgqs06QVFWZ+sRCtnu1IPT7qvOvJCKa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Pereira <nf.pereira@outlook.pt>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 039/493] HID: nintendo: Fix N64 controller being identified as mouse
Date: Mon, 27 May 2024 20:50:41 +0200
Message-ID: <20240527185630.023022695@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Pereira <nf.pereira@outlook.pt>

[ Upstream commit 8db8c77059e75a0f418b10ede39dd82a9eb031fa ]

This patch is regarding the recent addition of support for the NSO
controllers to hid-nintendo. All controllers are working correctly with the
exception of the N64 controller, which is being identified as a mouse by
udev. This results in the joystick controlling the mouse cursor and the
controller not being detected by games.

The reason for this is because the N64's C buttons have been attributed to
BTN_FORWARD, BTN_BACK, BTN_LEFT, BTN_RIGHT, which are buttons typically
attributed to mice.

This patch changes those buttons to controller buttons, making the
controller be correctly identified as such.

Signed-off-by: Nuno Pereira <nf.pereira@outlook.pt>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index ccc4032fb2b03..4b2c81b49b80e 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -481,10 +481,10 @@ static const struct joycon_ctlr_button_mapping n64con_button_mappings[] = {
 	{ BTN_TR,		JC_BTN_R,	},
 	{ BTN_TR2,		JC_BTN_LSTICK,	}, /* ZR */
 	{ BTN_START,		JC_BTN_PLUS,	},
-	{ BTN_FORWARD,		JC_BTN_Y,	}, /* C UP */
-	{ BTN_BACK,		JC_BTN_ZR,	}, /* C DOWN */
-	{ BTN_LEFT,		JC_BTN_X,	}, /* C LEFT */
-	{ BTN_RIGHT,		JC_BTN_MINUS,	}, /* C RIGHT */
+	{ BTN_SELECT,		JC_BTN_Y,	}, /* C UP */
+	{ BTN_X,		JC_BTN_ZR,	}, /* C DOWN */
+	{ BTN_Y,		JC_BTN_X,	}, /* C LEFT */
+	{ BTN_C,		JC_BTN_MINUS,	}, /* C RIGHT */
 	{ BTN_MODE,		JC_BTN_HOME,	},
 	{ BTN_Z,		JC_BTN_CAP,	},
 	{ /* sentinel */ },
-- 
2.43.0



