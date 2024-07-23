Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A6613D896;
	Tue, 23 Jul 2024 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760062; cv=none; b=inEDdh2fMJr5DmVHTE1xAZaYyOF4a+DqjQ0TU6j9zL0+RReA33bNjpT40T512gSVGwJCbSsIAMA7M78iFqBdCkgR/pPEDw4RTYjCs0+WEjKx0uiylSUaIBjZS89AnZDvQE/7g4c11zIODBz2a8VKxiyBudhZ066pQPXVbOlHQUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760062; c=relaxed/simple;
	bh=0mhUeVWUVg8XHqKEPEJEhQjPrsIN978z7KI2Nm7X/QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx8VfOsMk6uvZFGW8lu9eejGQLciqJYs47lEQm4cHWXlN/qMHShue5GLt6NENEgNfcPXK8FMhFj2oSPOZqYW5lzWurc131H8R1K9ES45LqZFRUE0sEgjfnD43IiVYIour7KNqQYxBuQaSkYIpv/dZCl+g9UvBxopGsupWsf8k3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ujg1gZOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ujg1gZOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59586C4AF09;
	Tue, 23 Jul 2024 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760062;
	bh=0mhUeVWUVg8XHqKEPEJEhQjPrsIN978z7KI2Nm7X/QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ujg1gZOioLVO+m6Sg3A0z/Hr6Kill0QEgTktA9LcK/Xgtc4JG9qaxcQBoDPog35Ck
	 9bYbbHWpAGaRhbafNJBQ++gLa0RigH48Z4DT383vIjgPyS6CssFIX/q9JZdqPMVhuZ
	 6F3WSG7asm/s7p5+6wE1X7WKJSBo8PnmXNdo5ESc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 090/163] ASoC: codecs: ES8326: Solve headphone detection issue
Date: Tue, 23 Jul 2024 20:23:39 +0200
Message-ID: <20240723180146.954207367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit b7c40988808f8d7426dee1e4d96a4e204de4a8bc ]

When switching between OMTP and CTIA headset, we can hear pop noise.
To solve this issue, We modified the configuration for headphone detection

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://msgid.link/r/20240604021946.2911-1-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 17bd6b5160772..8b2328d5d0c74 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -865,12 +865,16 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			 * set auto-check mode, then restart jack_detect_work after 400ms.
 			 * Don't report jack status.
 			 */
-			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
-					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
+			regmap_write(es8326->regmap, ES8326_INT_SOURCE, 0x00);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
+			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x00);
 			es8326_enable_micbias(es8326->component);
 			usleep_range(50000, 70000);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
+			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x10);
+			usleep_range(50000, 70000);
+			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
+					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
 			regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x1f);
 			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x08);
 			queue_delayed_work(system_wq, &es8326->jack_detect_work,
-- 
2.43.0



