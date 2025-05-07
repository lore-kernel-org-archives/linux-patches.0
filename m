Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC322153C6;
	Wed,  7 May 2025 18:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644141; cv=none; b=M5DJPRFye5c/yddhRNsJC9OFk/6DHWB2Gls6235rULf0jqjYssje9Mzfue3s7SyOq8scMAFHOuLZxn5yeZE2EeHyJxc5TdLFqApRIiqx6kxrM8gYuEzhJ3uaesGHuqbG/rl0mqbNgSd52aytnixF1ZqjMd9ESTJmTmDkmgszVgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644141; c=relaxed/simple;
	bh=d9vbSsftGXX3Jr4xyw94EFO+6G3a5oJHc9L4f6ziuJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KON9P7/kzYYNfljmn7Jj4bi76MJiZGMBlAjINJ1zrQHO17JcO1AH6UB6BxfiunF3EGsAHYj/7B6jsuPoMd9s9+10NomjXQvkBNq0rDdcc97T+/2EbGUDKbbg6EyrfyJTnu+o7pFWHZAlSsbJkHWEVB3QaV/xroiSukp70wDEmug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcBUqJMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcBUqJMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358A5C4CEE2;
	Wed,  7 May 2025 18:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644140;
	bh=d9vbSsftGXX3Jr4xyw94EFO+6G3a5oJHc9L4f6ziuJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcBUqJMeCYuLUTLrTmbXwn7dOMpw/mWzxBGoWLvEyjE0+R41iKP+ORXkDSh/NDnxS
	 hCLM3oeLOBvsAN/eBgFu25eMB0gtVL/ew8iBYbioh3cXW6hi/KhrxC4FJ+UEfSOR8x
	 6NO7iIlXeVyQQPbO6k86rdwwnvaYdkRdW06kmzd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 132/183] ASoC: stm32: sai: add a check on minimal kernel frequency
Date: Wed,  7 May 2025 20:39:37 +0200
Message-ID: <20250507183830.171069332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit cce34d113e2a592806abcdc02c7f8513775d8b20 ]

On MP2 SoCs SAI kernel clock rate is managed through
stm32_sai_set_parent_rate() function.
If the kernel clock rate was set previously to a low frequency, this
frequency may be too low to support the newly requested audio stream rate.
However the stm32_sai_rate_accurate() will only check accuracy against
the maximum kernel clock rate. The function will return leaving the kernel
clock rate unchanged.
Add a check on minimal frequency requirement, to avoid this.

Fixes: 2cfe1ff22555 ("ASoC: stm32: sai: add stm32mp25 support")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20250430165210.321273-3-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 5a5acc67569fe..d9c4266c8150d 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -447,7 +447,10 @@ static int stm32_sai_set_parent_rate(struct stm32_sai_sub_data *sai,
 	 * return immediately.
 	 */
 	sai_curr_rate = clk_get_rate(sai->sai_ck);
-	if (stm32_sai_rate_accurate(sai_ck_max_rate, sai_curr_rate))
+	dev_dbg(&pdev->dev, "kernel clock rate: min [%u], max [%u], current [%u]",
+		sai_ck_min_rate, sai_ck_max_rate, sai_curr_rate);
+	if (stm32_sai_rate_accurate(sai_ck_max_rate, sai_curr_rate) &&
+	    sai_curr_rate >= sai_ck_min_rate)
 		return 0;
 
 	/*
-- 
2.39.5



