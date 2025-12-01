Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA3724DFF9;
	Mon,  1 Dec 2025 11:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588384; cv=none; b=EBWt28BhJdJVahqeFonOyCT94+J41RfvGPXCdtW4i3RskaY+8MNhEA3B5WA9m2xPyM1CyYKtgT1NDZDl8YzeCeYdwZKaIweZUUf3TVmSOgJlNGom2awk5kQS/9zN9YL6ReaUOpVEIKsUZccTfmyTsntzTmVeM/noOORiWvtiyjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588384; c=relaxed/simple;
	bh=TBLbTyKF/Phdl99+JIcKRT+OEehn0Is1m60ygev3Wk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=en9/N69ybryHBrVYUQ95EYyNvNQhfEFbYj/unTJaHoKuPVmsSG76Adt75vp2A9PhRP15WorLaQDraMcZHNrlS+NES1difIAq7I2Kbckvy0BJuw1EegWY/XrT5+Dq5hN1l5nKMryXbiy+HelDtzfa597LOJCRVL/uSNuegCbj8CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1AvzmCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1AvzmCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A429C4CEF1;
	Mon,  1 Dec 2025 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588384;
	bh=TBLbTyKF/Phdl99+JIcKRT+OEehn0Is1m60ygev3Wk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1AvzmCy+yh99Tqu3U7rwZ4BrcSxea0h/vAd3vpTRuvkQDze6EVdHiVctb/3B42Y9
	 pxa9Wqtsq4bNH31R/x/VnIOzZpFpltWq6FJ0cAEoO66IsMl8UWQ3pltrBOlCbFlxU0
	 o77T2tvXugYyu5GUljPfx/qPmL8sR4x2MkyDQX3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/187] memstick: Add timeout to prevent indefinite waiting
Date: Mon,  1 Dec 2025 12:22:17 +0100
Message-ID: <20251201112242.307070848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayi Li <lijiayi@kylinos.cn>

[ Upstream commit b65e630a55a490a0269ab1e4a282af975848064c ]

Add timeout handling to wait_for_completion calls in memstick_set_rw_addr()
and memstick_alloc_card() to prevent indefinite blocking in case of
hardware or communication failures.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Link: https://lore.kernel.org/r/20250804024825.1565078-1-lijiayi@kylinos.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/memstick.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index e24ab362e51a9..7b8483f8d6f4f 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -369,7 +369,9 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
+	if (!wait_for_completion_timeout(&card->mrq_complete,
+			msecs_to_jiffies(500)))
+		card->current_mrq.error = -ETIMEDOUT;
 
 	return card->current_mrq.error;
 }
@@ -403,7 +405,9 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 
 		card->next_request = h_memstick_read_dev_id;
 		memstick_new_req(host);
-		wait_for_completion(&card->mrq_complete);
+		if (!wait_for_completion_timeout(&card->mrq_complete,
+				msecs_to_jiffies(500)))
+			card->current_mrq.error = -ETIMEDOUT;
 
 		if (card->current_mrq.error)
 			goto err_out;
-- 
2.51.0



