Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F33E2B9C7;
	Sun,  1 Sep 2024 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208445; cv=none; b=b5GtzzhaDrojdqK3ay2/49xVVEVZnKzL1F6wI5R4C/cgtEbYYwKNFZLvIlRL3SH3snJF3H/COdkjzellsseBTf9db/+pZQ9AVo0BFfupiOnBc22RjSNMt52WyQDG4SuuEg6WyytQfCltCFIHoaYD4sGmfZMB33oIGvZECVepdxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208445; c=relaxed/simple;
	bh=ndi12aesAPSaAL6apTpgRaH2nxN+Uc8HKW2fE+YSecE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDoOBVjSYucf9GCfs2fVnggsoMDoxOF+7LVyM6RLQcP6xwwwZR/1MNPh1CgcGgJHBtJbOdBv4jejXMiAXKB6mzedjW2loqKDkINLRaHVBYvCRjSLP5vUv61UjblV3F/9+VjVEBillJ60GWBfsfaeJ/RgLPvtE6jE77nUNXEBV6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvrH4My+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvrH4My+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5FDC4CEC3;
	Sun,  1 Sep 2024 16:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208445;
	bh=ndi12aesAPSaAL6apTpgRaH2nxN+Uc8HKW2fE+YSecE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvrH4My+lx0tYJwfjcTAKQI2PeROzQer0ofto62sQWYqPczFC+XBTimZJHIHN39Pj
	 VIJQFs36m9wJSgpZX/OEVp8PG0QXQxy88MkuCo67wR9yu7OOjKbFvVGHGKqDo4nosY
	 CkDDiuqk+Bf5yBpIfCEi1u6bLtGo/NKIVFVR1afE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 057/149] ASoC: cs-amp-lib-test: Force test calibration blob entries to be valid
Date: Sun,  1 Sep 2024 18:16:08 +0200
Message-ID: <20240901160819.613972675@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit bff980d8d9ca537fd5f3c0e9a99876c1e3713e81 ]

For a normal calibration blob the calTarget values must be non-zero and
unique, and the calTime values must be non-zero. Don't rely on
get_random_bytes() to be random enough to guarantee this. Force the
calTarget and calTime values to be valid while retaining randomness
in the values.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 177862317a98 ("ASoC: cs-amp-lib: Add KUnit test for calibration helpers")
Link: https://patch.msgid.link/20240822115725.259568-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs-amp-lib-test.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/codecs/cs-amp-lib-test.c b/sound/soc/codecs/cs-amp-lib-test.c
index 15f991b2e16e2..8169ec88a8ba8 100644
--- a/sound/soc/codecs/cs-amp-lib-test.c
+++ b/sound/soc/codecs/cs-amp-lib-test.c
@@ -38,6 +38,7 @@ static void cs_amp_lib_test_init_dummy_cal_blob(struct kunit *test, int num_amps
 {
 	struct cs_amp_lib_test_priv *priv = test->priv;
 	unsigned int blob_size;
+	int i;
 
 	blob_size = offsetof(struct cirrus_amp_efi_data, data) +
 		    sizeof(struct cirrus_amp_cal_data) * num_amps;
@@ -49,6 +50,14 @@ static void cs_amp_lib_test_init_dummy_cal_blob(struct kunit *test, int num_amps
 	priv->cal_blob->count = num_amps;
 
 	get_random_bytes(priv->cal_blob->data, sizeof(struct cirrus_amp_cal_data) * num_amps);
+
+	/* Ensure all timestamps are non-zero to mark the entry valid. */
+	for (i = 0; i < num_amps; i++)
+		priv->cal_blob->data[i].calTime[0] |= 1;
+
+	/* Ensure that all UIDs are non-zero and unique. */
+	for (i = 0; i < num_amps; i++)
+		*(u8 *)&priv->cal_blob->data[i].calTarget[0] = i + 1;
 }
 
 static u64 cs_amp_lib_test_get_target_uid(struct kunit *test)
-- 
2.43.0



