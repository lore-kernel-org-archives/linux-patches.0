Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FA61EA65;
	Thu, 28 May 2026 20:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999901; cv=none; b=godkYe7ef/PYJPnKQtOD207uOK9bHqtCcliDDzXpEROxiSE1ny4qyeYqrdXhCtlDID2tgZklNqHct72t3xkfqdqppWNchmIf6p92bx9AzU+Q2H2u7ItPoXDkR7sF3vYrcT3D2WgzWpWIBjmuzoKgKpSjmQ/CVJ7t/Pje6Sdau4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999901; c=relaxed/simple;
	bh=1v7gNnnibdPWWFkc5jag4dDk6qjbcDu1/NsCSCX9ukc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo9eJCDaqqELpVMfFP+IiMT1R6eCWx16DLtweoAbOVvYHQORgF1p8fI/QSjIK1iMK1pPjsIPLeHEciznfGcomTVQyxoCU6pcyZ4lcnTygvDgIC35AY5oVToq79vklAU4dRYYav3kul5HaRoPW7On2BLQJtsjgSNlSBdKTFEouqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvMrRpeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvMrRpeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D201F000E9;
	Thu, 28 May 2026 20:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999900;
	bh=RPwSSTvnO5l1/zOkNLw+K7w/5++2RUGHICRau4u+d6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvMrRpeKjxCLW5ZgpEr5t5yfrcaZlqI14ymvzLlE418oIobBjIBIKHXSGj+k0FwzG
	 KvpatDs01V9P7s7raJRY0GyB8b1BjMueL4dqNxHiUigB48NGdYt5dckDsXql5rVkp+
	 PdnQalCm8qE+J/OHU3eYlTHxQOPQZv1ibsfbeBGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/377] ALSA: hda: cs35l56: Put ACPI device after setting companion
Date: Thu, 28 May 2026 21:47:13 +0200
Message-ID: <20260528194644.054855686@linuxfoundation.org>
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

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit aa2fbece1b07954ef26488c800d126a36a8ab93e ]

acpi_dev_get_first_match_dev() returns a refcounted ACPI device and
callers are expected to balance it with acpi_dev_put().

When no companion is already attached, cs35l56_hda_read_acpi() looks
up an ACPI device and sets it with ACPI_COMPANION_SET(), but leaves
the lookup reference held.

ACPI_COMPANION_SET() does not take ownership of that reference, so
drop it with acpi_dev_put() after attaching the companion.

Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Tested-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260428080139.GA1649104@chcpu16
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index 79c15e21d4bcb..1d25fe01066ee 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -949,6 +949,7 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 			return -ENODEV;
 		}
 		ACPI_COMPANION_SET(cs35l56->base.dev, adev);
+		acpi_dev_put(adev);
 	}
 
 	/* Initialize things that could be overwritten by a fixup */
-- 
2.53.0



