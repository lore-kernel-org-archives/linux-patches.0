Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD833466B01;
	Fri,  7 Aug 2026 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114723; cv=none; b=NIaFtLGV3QG6CnSklvRA0FAXmJK4+o7x6YjPYcN78of5VqtJWUjk7raCVIz65XxIl/AfEBGG0QMqzyBXBMQ8OvCNINsQhMMNLt/mZvg0JHB0YQTHAPRkWECBM9bz7IjKxI11ejj5rb+/m5DRG63i6tf287stDv/ukx8YJRXQcV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114723; c=relaxed/simple;
	bh=rax1u8o7R4M/sNqPBmyFtABbXpqrDMVnmNBe3zGEN8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnDfLU5C8Wnsp/tAqkE3tcfFtcZsfiHuSlLyNn/npD+D8bUwCuXVc8MJCtApG1cvRklqCuOSLN56C43CsX5bTQsbSV4G3TLy5pK2pSgDGjeJxJV7nAcQbua5uS9v3TG/DMih/vpJpQimUkruy+CASkI+uTHs2rjcpI+39zT5PsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eI8/TXk0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eI8/TXk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2506E1F000E9;
	Fri,  7 Aug 2026 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114721;
	bh=SrBdhYYs885wr4L/V2OPe75DT94fjI+OvsB09k4r5RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eI8/TXk0XqU7GLduYocjIGKfJ4Y8dtQTCEros83A+TtOfRXDSoWIHRsVfZEngftGn
	 mOB6mCO52fLQCWQklfhYZtwNAm3hiaVAat3hEkvSuuVZo0C47TeSzfjFK35QpA7MOG
	 49HKREjQ+hUw5/BSi+l0BLJmJNnBvATasEJzi1Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/396] ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup
Date: Fri,  7 Aug 2026 16:33:05 +0200
Message-ID: <20260807143424.817850069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 317e21532e6ffa1de026bdbce5ba98e1b70ca5c6 ]

In max98095_probe(), the -EPROBE_DEFER check after devm_clk_get() is
broken due to a missing IS_ERR() guard.

The code intends to return -EPROBE_DEFER only when the clock lookup
fails with that specific error.  However, without IS_ERR() the check:

    if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)

is called unconditionally, including when devm_clk_get() succeeds and
returns a valid pointer.  Calling PTR_ERR() on a valid pointer
reinterprets its address as a signed long; the result is arbitrary
and is almost never equal to -EPROBE_DEFER, so the check silently
does nothing in the success case.  When devm_clk_get() fails with
any error other than -EPROBE_DEFER the check is also skipped, leaving
max98095->mclk holding an error pointer with no indication to the caller.

This means a deferred probe will never actually be triggered for this
device, and any non-EPROBE_DEFER clock error is silently swallowed with
the error pointer left in the mclk field.

Fix this by adding the missing IS_ERR() guard around the PTR_ERR() call,
matching the pattern already used in the sibling max98088 and wm8960
drivers.

Fixes: e3048c3d2be5 ("ASoC: max98095: Add master clock handling")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260720103950.14474-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98095.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index cfb63fe69267b..ad2587d2df819 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1984,8 +1984,9 @@ static int max98095_probe(struct snd_soc_component *component)
 	int ret = 0;
 
 	max98095->mclk = devm_clk_get(component->dev, "mclk");
-	if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (IS_ERR(max98095->mclk))
+		if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 
 	/* reset the codec, the DSP core, and disable all interrupts */
 	max98095_reset(component);
-- 
2.53.0



