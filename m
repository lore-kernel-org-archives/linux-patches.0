Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7252C1A76A4;
	Tue, 30 Jul 2024 17:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359954; cv=none; b=jP+Ol4nBktSqwPlS9vpupKtPeG06z7hV11csmIFf+1VDDnPDYT7wOa9xsghcrDaooBxHWNVGV5jfRwKaeyiuvE0HrBu1KacS6IfUFTHnUjj6jl19bxk1rj71LyZyoQMn4lGnEBYbsnIuxIvJsZEbwmO0rLoMmkUIpvdmN6acBdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359954; c=relaxed/simple;
	bh=MPOZpT/b3ZiDjJVK5ONHJ8dVk7YyZxNYjfZZ/8Fa35k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmISEL+n+xGZRDMEQm5ogdtHWH/z/tWVcJhQugjw8eONyTrJVBHXFM0FftGBptr8UdKXjoTnTXizgO+ezItOCiYtnAVVtRRSy+WANnv4SOwDbabduxe1RdRgA04lOO2aZbuyQk6ucLNmGl/vLDsjFT/FMHW3kXkjuGt6Tuz0VjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv4JYzpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv4JYzpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFE8C32782;
	Tue, 30 Jul 2024 17:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359954;
	bh=MPOZpT/b3ZiDjJVK5ONHJ8dVk7YyZxNYjfZZ/8Fa35k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv4JYzpEaamdDWklhFx7yKO7BOvobQE4K1QjCEikYwdeVt7KyGI/4PIqDwQNmVids
	 PQw9k9Glx8Dv+CDmtNMQXJEbxcBP4CvLTKMaBbOnx/vFkFhGB+F42+WLCdMzmYErMk
	 5DKqACBhu4iYg/0UTNLQ5J52PoZksgnEVvRB7vKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 560/568] ASoC: TAS2781: Fix tasdev_load_calibrated_data()
Date: Tue, 30 Jul 2024 17:51:07 +0200
Message-ID: <20240730151702.045452333@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 92c78222168e9035a9bfb8841c2e56ce23e51f73 ]

This function has a reversed if statement so it's either a no-op or it
leads to a NULL dereference.

Fixes: b195acf5266d ("ASoC: tas2781: Fix wrong loading calibrated data sequence")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/18a29b68-cc85-4139-b7c7-2514e8409a42@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 32ff4fb14998e..41ad82a429163 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -2193,7 +2193,7 @@ static void tasdev_load_calibrated_data(struct tasdevice_priv *priv, int i)
 		return;
 
 	cal = cal_fmw->calibrations;
-	if (cal)
+	if (!cal)
 		return;
 
 	load_calib_data(priv, &cal->dev_data);
-- 
2.43.0



