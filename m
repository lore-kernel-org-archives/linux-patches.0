Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F139228850E;
	Tue,  6 Jan 2026 17:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721888; cv=none; b=fA1srwoyM5HFHWjxYyvBDCGgFzrZfgxoBsnCffiLb/2K3BcdnMfZqISnqX6yB6Kwol0TUPFA+/qo8ZH6oWS52WIzSK7/erBXk9L2QZ/Lz9rWnKt2FJNhyt0MsrUjASxfeFAFCXxQDN+fl5KG+n7UtKzCZ+95+gwzRBlzrt8BxgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721888; c=relaxed/simple;
	bh=5KdO4aN8sn6Sc6TzRKJuyCcgR9fE04FNQp/MEOPaR4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTJ+HqtJ5haCx8TRhONPS2O89Iuv9jAq9jbh6b0T7NtFRKUMWDsEov5s2sgdJjQ4z8QWSeHaWFA7tMcHH3Ed0qbiVOzuihJR83wrY127kfBIcxy+gyK9xkvYs1Od5gj7SrrEcJ81g8itvb3t8D2m+Z7a63IvAOmuJPy+Z5z3vsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAmsgTqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAmsgTqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC0DC116C6;
	Tue,  6 Jan 2026 17:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721887;
	bh=5KdO4aN8sn6Sc6TzRKJuyCcgR9fE04FNQp/MEOPaR4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAmsgTqNvtNqXh0Un4Zl6eg2L74XqR5VtIwGJzTzpC8UIKs6WuJS8f3HlA0GPxmFe
	 Imi6yp7l66Obun+dVhuWSXpGjtF56STyZuVBGjm/PA/eQHaaW4WXn3p0TxyZKvl+a2
	 whUk/fH8GrlU+3ipBSUlvb7lpBgK7HaG5Mb/BLi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Naim <dnaim@cachyos.org>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 102/312] ASoC: cs35l41: Always return 0 when a subsystem ID is found
Date: Tue,  6 Jan 2026 18:02:56 +0100
Message-ID: <20260106170551.527765446@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Eric Naim <dnaim@cachyos.org>

commit b0ff70e9d4fe46cece25eb97b9b9b0166624af95 upstream.

When trying to get the system name in the _HID path, after successfully
retrieving the subsystem ID the return value isn't set to 0 but instead
still kept at -ENODATA, leading to a false negative:

[   12.382507] cs35l41 spi-VLV1776:00: Subsystem ID: VLV1776
[   12.382521] cs35l41 spi-VLV1776:00: probe with driver cs35l41 failed with error -61

Always return 0 when a subsystem ID is found to mitigate these false
negatives.

Link: https://github.com/CachyOS/CachyOS-Handheld/issues/83
Fixes: 46c8b4d2a693 ("ASoC: cs35l41: Fallback to reading Subsystem ID property if not ACPI")
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Eric Naim <dnaim@cachyos.org>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20251206193813.56955-1-dnaim@cachyos.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l41.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs35l41.c b/sound/soc/codecs/cs35l41.c
index 3a8a8dd065b7..ee56dfceedeb 100644
--- a/sound/soc/codecs/cs35l41.c
+++ b/sound/soc/codecs/cs35l41.c
@@ -1188,13 +1188,14 @@ static int cs35l41_get_system_name(struct cs35l41_private *cs35l41)
 		}
 	}
 
-err:
 	if (sub) {
 		cs35l41->dsp.system_name = sub;
 		dev_info(cs35l41->dev, "Subsystem ID: %s\n", cs35l41->dsp.system_name);
-	} else
-		dev_warn(cs35l41->dev, "Subsystem ID not found\n");
+		return 0;
+	}
 
+err:
+	dev_warn(cs35l41->dev, "Subsystem ID not found\n");
 	return ret;
 }
 
-- 
2.52.0



