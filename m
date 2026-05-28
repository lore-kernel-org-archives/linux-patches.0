Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D1A3016E1;
	Thu, 28 May 2026 20:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000776; cv=none; b=eqYZiXLZWRxRsfsuOrRZrU5vRuTFgNd00wPlfbHAI5ve+Pr6cuSxdxZ6/0fpCophxU7SXK0wuYg0O+mxpYm++1KJuiAlrCb+1S86fBY8kgZ5smda/uZ0P2Kf0TFjl1N4JKLevrh0mIXNPNL+Yp09z+9FiBEcOgMco8sqXr2A8UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000776; c=relaxed/simple;
	bh=WCjIvquju9wo8L5+3qVWP0udx7JGXmyX+K1DRxZrvQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3K+9xgV3xg/IBazPYiBdMdnD8v55XyLp13y6YxWN3m6E2gGavXjz7Ro0NN2zn2cuB5VS74sIVN1kiXZzf7byyQwAJWJKfrHYBk+iVaDFcUGigDspCDCKmxZAJQ9wjX8Az13vyZ/7sdB96OQY+Yc0mtMS5O/88tLEpme4nC6b7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b74/IT5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b74/IT5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FDD1F000E9;
	Thu, 28 May 2026 20:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000775;
	bh=eMLa8Z0ymouJh0Jez1SUY+E/adzIChN7MsNZejsZ88c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b74/IT5iabnwPDI2C7d36weXO+kMrAehzQfe6A7k8V27Ml4C1NJD15/QoIPjNcNU1
	 8k+GJa+Jp1C8tXI7ZaUP4ARGv0wq8UC17zWhkEeVUu2no5+z8a5NBtS/kSEjZtjufn
	 Kcafy3/XMtMG4y73tJHdppth3g3sf7PcDihH3yu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/272] ALSA: hda: cs35l56: Put ACPI device after setting companion
Date: Thu, 28 May 2026 21:48:57 +0200
Message-ID: <20260528194633.899009236@linuxfoundation.org>
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
 sound/pci/hda/cs35l56_hda.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index ee5387140ae48..5c0c4b79f5197 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -953,6 +953,7 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 			return -ENODEV;
 		}
 		ACPI_COMPANION_SET(cs35l56->base.dev, adev);
+		acpi_dev_put(adev);
 	}
 
 	/* Initialize things that could be overwritten by a fixup */
-- 
2.53.0



