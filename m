Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED4232AAD6;
	Thu, 28 May 2026 20:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000721; cv=none; b=hqkXAtIEz20t3Lswo9ZaEvHXqfZolxN9TQ3yQegfC2xmAKC3zQU+pifXrnfUo7MaXC09+Kb9IqyHZDkI/C5hjjXrgA1CLjcdjn2cxHmCx+dcOYM9R6RKtkd+Tx5r5+QGKdYDivdXbrOCcAijwMFfSnYUxaNKG4zdH8dE++HPRyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000721; c=relaxed/simple;
	bh=yp8g1YDWe/CNO5IZ9yisroQ+RJOFRlinIWuGxELuV5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgbeLtqwZdzJgEJtM9zr0ACXP7Ci0h/V53sDIaRuj+RFQWcmSuUX6A7e/3QjUle+8lOoNvEzXExJ+lo8Ek/Qot/VbGO1CmSio7qw43rG97mBQkDLNppqca3V+b0JliurUrI6Wi8yrxZ0kU1b0PhjH0FRLGRapGW0e5FhhFBcAgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzygvHSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzygvHSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1DC1F000E9;
	Thu, 28 May 2026 20:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000720;
	bh=KhUS+ko4dE56BPJFD+2+szfGtA6BLhGsuH5hsg8lBIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzygvHSdF+TWpzRxf3KeZRTNovOguPP+Si74LzxaW6ro7v76HgLsPKZ+LjHa2/6Zo
	 OClCa+eF7c0pS/uEEXccFzk5Rj5QWSTeRbtfZyx+udsbRhVeM3z/9T+Q6CcHkLMqE7
	 Nl8uJIs8BOZ33eV6ruI3vne/0TehejhwdOgXIl8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/272] HID: uclogic: Fix regression of input name assignment
Date: Thu, 28 May 2026 21:48:39 +0200
Message-ID: <20260528194633.432266628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 321c43fb06ae0..f8708a1ec7cc8 100644
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



