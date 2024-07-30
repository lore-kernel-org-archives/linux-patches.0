Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86539183CD5;
	Tue, 30 Jul 2024 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357715; cv=none; b=J/2Haj4xQ/45JuUVpglU5T/01s5eQzip9doCwKJJJxUnJ3yEtkkLEp5d7PmFm4+rviv5TJdVpJHQtRDyACOX5pX+AMjRCh1YLeqIEJc3TyH/PlQLIv1FJx88XYLo/d/5ZxlDWcDQ8RViCrES0MHVc3JxnLlF9ii2bS2N9cnHKkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357715; c=relaxed/simple;
	bh=VDnLcQzDmEU7cPA5HsUqkfJKgQW6wDS2y2A5FL61U+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVV5Bn8dmBeG0Cthl22x48Jc8VHgWG3K12hzTV0KmZ+KRq6Ti7Fe1sccxWDrnDc01wpJVwydfobuMLO2E3jMZORw6nIjrP+kr6OFa70NkPnY5mGo1WxvL09lkVw3D09Rq1KqH7ulPT7HfHfdtPhV7PZ6/Julf3V9udEJ2bP2e6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spVxkVyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spVxkVyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A43C32782;
	Tue, 30 Jul 2024 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357715;
	bh=VDnLcQzDmEU7cPA5HsUqkfJKgQW6wDS2y2A5FL61U+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spVxkVywuG20LeZdhnvH6F2YGzViSXR3g+T+zNhO72Np3TC8v0uHU6uIL0jLxo4sE
	 l6WPnjDsMOiOrLGkXuMlkaI/6H+nFRy+sbhyA3vD3TCOi4Bjs0SgUAtZ2VqCOkZDCB
	 cqHe2lUORgO8mum10r4uazg5wRO7JNkjJjE9FWjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/568] ASoC: amd: Adjust error handling in case of absent codec device
Date: Tue, 30 Jul 2024 17:46:31 +0200
Message-ID: <20240730151650.974501123@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 5080808c3339de2220c602ab7c7fa23dc6c1a5a3 ]

acpi_get_first_physical_node() can return NULL in several cases (no such
device, ACPI table error, reference count drop to 0, etc).
Existing check just emit error message, but doesn't perform return.
Then this NULL pointer is passed to devm_acpi_dev_add_driver_gpios()
where it is dereferenced.

Adjust this error handling by adding error code return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 02527c3f2300 ("ASoC: amd: add Machine driver for Jadeite platform")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://patch.msgid.link/20240703191007.8524-1-amishin@t-argos.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-es8336.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index 5e56d3a53be78..49bffc567e68d 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -203,8 +203,10 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 
 	codec_dev = acpi_get_first_physical_node(adev);
 	acpi_dev_put(adev);
-	if (!codec_dev)
+	if (!codec_dev) {
 		dev_err(card->dev, "can not find codec dev\n");
+		return -ENODEV;
+	}
 
 	ret = devm_acpi_dev_add_driver_gpios(codec_dev, acpi_es8336_gpios);
 	if (ret)
-- 
2.43.0



