Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A64230981;
	Wed, 30 Jul 2025 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869369; cv=none; b=PiCCLRtvXzZ4e1r12R/eYLghUvVqAjdB3VygznQGA2+h/CFUmqFnM975iBsmrIz6HovilL+9r11s8EDdD4TiCuOA9pLRRTdiL3U48NJ9Zh6BojNOaxyrnXpmIOsHPwIIMkPTG8Y/fvXssrGbYCE4qqALvGXGrlToEeR3loiz68U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869369; c=relaxed/simple;
	bh=4LhtGdoiqZ1EijuZGmVclIg+kNHH9IbcQqG4M/cUEjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XS4bP7nn/gtGUSudd5WWrmRYPuveBvp6f9LsNvtRWPTv3hrz3bXt6eAqLe9xs3tR3rK0/eZkm4ly2qAHP/Rvlc5IWQmrYNb1PeckrZChqvXiwU7e9bQ9PaxxLEKiyjOlEbmy/x9IPvV1T1xVIK5XG+LavlIu3k2tzyn7+MRYdkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJ8e4Yw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJ8e4Yw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC85CC4CEF6;
	Wed, 30 Jul 2025 09:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869369;
	bh=4LhtGdoiqZ1EijuZGmVclIg+kNHH9IbcQqG4M/cUEjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJ8e4Yw5FMefhle42uuI5EUBiBbF8rfktTqDgbzsUoL5X1HBh9ha3EI3hXuynaLJs
	 tp7lnFF29dAAu2HJmYFR+gM9jdAxm5f+lL7hAVNtaBe8Fe+GIqb/DfCs78An3L0j2l
	 bMlIPNdNRjKZ7/2aWXYYTuE6On4CFC9pCtWqO3tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 64/92] ASoC: mediatek: common: fix device and OF node leak
Date: Wed, 30 Jul 2025 11:36:12 +0200
Message-ID: <20250730093233.227075131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 696e123aa36bf0bc72bda98df96dd8f379a6e854 upstream.

Make sure to drop the references to the accdet OF node and platform
device taken by of_parse_phandle() and of_find_device_by_node() after
looking up the sound component during probe.

Fixes: cf536e2622e2 ("ASoC: mediatek: common: Handle mediatek,accdet property")
Cc: stable@vger.kernel.org	# 6.15
Cc: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20250722092542.32754-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/common/mtk-soundcard-driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/mediatek/common/mtk-soundcard-driver.c b/sound/soc/mediatek/common/mtk-soundcard-driver.c
index 713a368f79cf..95a083939f3e 100644
--- a/sound/soc/mediatek/common/mtk-soundcard-driver.c
+++ b/sound/soc/mediatek/common/mtk-soundcard-driver.c
@@ -262,9 +262,13 @@ int mtk_soundcard_common_probe(struct platform_device *pdev)
 				soc_card_data->accdet = accdet_comp;
 			else
 				dev_err(&pdev->dev, "No sound component found from mediatek,accdet property\n");
+
+			put_device(&accdet_pdev->dev);
 		} else {
 			dev_err(&pdev->dev, "No device found from mediatek,accdet property\n");
 		}
+
+		of_node_put(accdet_node);
 	}
 
 	platform_node = of_parse_phandle(pdev->dev.of_node, "mediatek,platform", 0);
-- 
2.50.1



