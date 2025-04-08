Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E0C19AD5C;
	Tue,  8 Apr 2025 11:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112458; cv=none; b=m8ObI4Sr9BKpLJEjP7FprMxbNzWwWtoVjwkEQzo1Iz0VAyWp7y9EaxxhRCoOq2Hr2RQVtDOG5Z1dxCi85ajND2ziE2rtXmh8mFPFCROKnuqljoxSzjZChmFb5JsFFkuNzV1sLac2eGMI/Cmtn1Od5565BnN0jbuAuUYETQYCA7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112458; c=relaxed/simple;
	bh=qPi/Abjvayyo+TiVDhqEKALMs7RhtDcPn4za0/XGHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWRNqcBh0v2LdZJZEIQHi27oakPBiN8o04TfoaQZBGDPc4x1wSxzHSNOZ2WdXKhYjnZ7oGpfeTevZZkn0GJVfJknm3PA5SdW2atiwkhw2oNkN0rRvIgKKrGwe+aQsa5/WV+TnmmbFr2UOQCBkk25p2BMayCW1GkvTA5aZFjpmpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvoyN7Ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvoyN7Ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BDEC4CEE5;
	Tue,  8 Apr 2025 11:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112458;
	bh=qPi/Abjvayyo+TiVDhqEKALMs7RhtDcPn4za0/XGHAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvoyN7UguX+0yy1UGAWYRsvQOBoroGXiBiWNchT+ImtHaH8hGPz9MgmIVZ2YyD+Ft
	 of7ds0BC+MutyTWRH9mlnD9W4fAvrbpLH+4AvniU8KKyJpjYZvoC20jhGV+x1uMS5l
	 kh+Q8d0hWATpialJHtQDleJZJACBl2RUuRSDhUmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/279] ASoC: arizona/madera: use fsleep() in up/down DAPM event delays.
Date: Tue,  8 Apr 2025 12:47:02 +0200
Message-ID: <20250408104827.436872398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

[ Upstream commit 679074942c2502a95842a80471d8fb718165ac77 ]

Using `fsleep` instead of `msleep` resolves some customer complaints
regarding the precision of up/down DAPM event timing. `fsleep()`
automatically selects the appropriate sleep function, making the delay
time more predictable.

Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Link: https://patch.msgid.link/20250205160849.500306-1-vitalyr@opensource.cirrus.com
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/arizona.c | 14 +++++++-------
 sound/soc/codecs/madera.c  | 10 +++++-----
 sound/soc/codecs/wm5110.c  |  8 ++++----
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index e32871b3f68ac..be207350b7124 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -967,7 +967,7 @@ int arizona_out_ev(struct snd_soc_dapm_widget *w,
 		case ARIZONA_OUT3L_ENA_SHIFT:
 		case ARIZONA_OUT3R_ENA_SHIFT:
 			priv->out_up_pending++;
-			priv->out_up_delay += 17;
+			priv->out_up_delay += 17000;
 			break;
 		case ARIZONA_OUT4L_ENA_SHIFT:
 		case ARIZONA_OUT4R_ENA_SHIFT:
@@ -977,7 +977,7 @@ int arizona_out_ev(struct snd_soc_dapm_widget *w,
 			case WM8997:
 				break;
 			default:
-				priv->out_up_delay += 10;
+				priv->out_up_delay += 10000;
 				break;
 			}
 			break;
@@ -999,7 +999,7 @@ int arizona_out_ev(struct snd_soc_dapm_widget *w,
 			if (!priv->out_up_pending && priv->out_up_delay) {
 				dev_dbg(component->dev, "Power up delay: %d\n",
 					priv->out_up_delay);
-				msleep(priv->out_up_delay);
+				fsleep(priv->out_up_delay);
 				priv->out_up_delay = 0;
 			}
 			break;
@@ -1017,7 +1017,7 @@ int arizona_out_ev(struct snd_soc_dapm_widget *w,
 		case ARIZONA_OUT3L_ENA_SHIFT:
 		case ARIZONA_OUT3R_ENA_SHIFT:
 			priv->out_down_pending++;
-			priv->out_down_delay++;
+			priv->out_down_delay += 1000;
 			break;
 		case ARIZONA_OUT4L_ENA_SHIFT:
 		case ARIZONA_OUT4R_ENA_SHIFT:
@@ -1028,10 +1028,10 @@ int arizona_out_ev(struct snd_soc_dapm_widget *w,
 				break;
 			case WM8998:
 			case WM1814:
-				priv->out_down_delay += 5;
+				priv->out_down_delay += 5000;
 				break;
 			default:
-				priv->out_down_delay++;
+				priv->out_down_delay += 1000;
 				break;
 			}
 			break;
@@ -1053,7 +1053,7 @@ int arizona_out_ev(struct snd_soc_dapm_widget *w,
 			if (!priv->out_down_pending && priv->out_down_delay) {
 				dev_dbg(component->dev, "Power down delay: %d\n",
 					priv->out_down_delay);
-				msleep(priv->out_down_delay);
+				fsleep(priv->out_down_delay);
 				priv->out_down_delay = 0;
 			}
 			break;
diff --git a/sound/soc/codecs/madera.c b/sound/soc/codecs/madera.c
index fd4fa1d5d2d12..5775898fc6f9e 100644
--- a/sound/soc/codecs/madera.c
+++ b/sound/soc/codecs/madera.c
@@ -2322,10 +2322,10 @@ int madera_out_ev(struct snd_soc_dapm_widget *w,
 	case CS42L92:
 	case CS47L92:
 	case CS47L93:
-		out_up_delay = 6;
+		out_up_delay = 6000;
 		break;
 	default:
-		out_up_delay = 17;
+		out_up_delay = 17000;
 		break;
 	}
 
@@ -2356,7 +2356,7 @@ int madera_out_ev(struct snd_soc_dapm_widget *w,
 		case MADERA_OUT3R_ENA_SHIFT:
 			priv->out_up_pending--;
 			if (!priv->out_up_pending) {
-				msleep(priv->out_up_delay);
+				fsleep(priv->out_up_delay);
 				priv->out_up_delay = 0;
 			}
 			break;
@@ -2375,7 +2375,7 @@ int madera_out_ev(struct snd_soc_dapm_widget *w,
 		case MADERA_OUT3L_ENA_SHIFT:
 		case MADERA_OUT3R_ENA_SHIFT:
 			priv->out_down_pending++;
-			priv->out_down_delay++;
+			priv->out_down_delay += 1000;
 			break;
 		default:
 			break;
@@ -2392,7 +2392,7 @@ int madera_out_ev(struct snd_soc_dapm_widget *w,
 		case MADERA_OUT3R_ENA_SHIFT:
 			priv->out_down_pending--;
 			if (!priv->out_down_pending) {
-				msleep(priv->out_down_delay);
+				fsleep(priv->out_down_delay);
 				priv->out_down_delay = 0;
 			}
 			break;
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 7c6e01720d651..bc3dfb53ba953 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -302,7 +302,7 @@ static int wm5110_hp_pre_enable(struct snd_soc_dapm_widget *w)
 		} else {
 			wseq = wm5110_no_dre_left_enable;
 			nregs = ARRAY_SIZE(wm5110_no_dre_left_enable);
-			priv->out_up_delay += 10;
+			priv->out_up_delay += 10000;
 		}
 		break;
 	case ARIZONA_OUT1R_ENA_SHIFT:
@@ -312,7 +312,7 @@ static int wm5110_hp_pre_enable(struct snd_soc_dapm_widget *w)
 		} else {
 			wseq = wm5110_no_dre_right_enable;
 			nregs = ARRAY_SIZE(wm5110_no_dre_right_enable);
-			priv->out_up_delay += 10;
+			priv->out_up_delay += 10000;
 		}
 		break;
 	default:
@@ -338,7 +338,7 @@ static int wm5110_hp_pre_disable(struct snd_soc_dapm_widget *w)
 			snd_soc_component_update_bits(component,
 						      ARIZONA_SPARE_TRIGGERS,
 						      ARIZONA_WS_TRG1, 0);
-			priv->out_down_delay += 27;
+			priv->out_down_delay += 27000;
 		}
 		break;
 	case ARIZONA_OUT1R_ENA_SHIFT:
@@ -350,7 +350,7 @@ static int wm5110_hp_pre_disable(struct snd_soc_dapm_widget *w)
 			snd_soc_component_update_bits(component,
 						      ARIZONA_SPARE_TRIGGERS,
 						      ARIZONA_WS_TRG2, 0);
-			priv->out_down_delay += 27;
+			priv->out_down_delay += 27000;
 		}
 		break;
 	default:
-- 
2.39.5



