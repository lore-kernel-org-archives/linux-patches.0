Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0958837;
	Mon, 28 Oct 2024 06:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098341; cv=none; b=hLy8Upphv3Xc0UagbNdeggh5IKQGHiQQiP11B29XmxtGH83Zsn+ljis71upFPzAbIa1lja/9FcdgA+pZt26cVEmrE+KBTUm8YjB5cWNJZXVnMciEJQoYY1rcwJkBxl0OiAlsFG2sJl3buRKN1kpfNGGi4HWbLnFweGHsCDLkjyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098341; c=relaxed/simple;
	bh=NHfcv2ay/H9ka8NPxXb10NIbq+NNjNsjMSxM+5ZfX8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQotQJ2YZa3EGSkNABaCiIUVqZrWYpm5SiPKB+IytaMLtUxGXeaigzIvZ3MhyaZ9UuaVCxyxU2Hh1OjBz2dfPRaS1obe0zAVv7N6/CUJ9d7QDzIqxKEXDVEmox/mahybI+82poeGyOGXgMQ9EcoRhdIn6qHaxiSNFvXXgId3ASk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezN3/Lha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezN3/Lha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33EAC4CEC3;
	Mon, 28 Oct 2024 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098341;
	bh=NHfcv2ay/H9ka8NPxXb10NIbq+NNjNsjMSxM+5ZfX8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezN3/LhaQov5xPxC3F8ufiagxSd1htZA0k/zhKJKy/emI/9TO5nrzM5HOH485wyKx
	 H0ICMxKL3H4hcqnMSSHKWX8BLAGn05a+lHFTpV+sSISAn5yZdcxiDrXiMwYlGuioVq
	 X+ezAIjRxllvJM3oFqVa2sEuytXeMtIupN69h73A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 185/261] ASoC: max98388: Fix missing increment of variable slot_found
Date: Mon, 28 Oct 2024 07:25:27 +0100
Message-ID: <20241028062316.648390737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit ca2803fadfd239abf155ef4a563b22a9507ee4b2 ]

The variable slot_found is being initialized to zero and inside
a for-loop is being checked if it's reached MAX_NUM_CH, however,
this is currently impossible since slot_found is never changed.
In a previous loop a similar coding pattern is used and slot_found
is being incremented. It appears the increment of slot_found is
missing from the loop, so fix the code by adding in the increment.

Fixes: 6a8e1d46f062 ("ASoC: max98388: add amplifier driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20241010182032.776280-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98388.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/max98388.c b/sound/soc/codecs/max98388.c
index b847d7c59ec01..99986090b4a63 100644
--- a/sound/soc/codecs/max98388.c
+++ b/sound/soc/codecs/max98388.c
@@ -763,6 +763,7 @@ static int max98388_dai_tdm_slot(struct snd_soc_dai *dai,
 			addr = MAX98388_R2044_PCM_TX_CTRL1 + (cnt / 8);
 			bits = cnt % 8;
 			regmap_update_bits(max98388->regmap, addr, bits, bits);
+			slot_found++;
 			if (slot_found >= MAX_NUM_CH)
 				break;
 		}
-- 
2.43.0



