Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6642C1A6161;
	Tue, 30 Jul 2024 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356567; cv=none; b=MSQXAFCftfhDYWavUJCFl0XKAyMPdEybgNCbAbsWD84WQsBfHMgX9VYrwsfcut/6JGEW3MT4uuHHAV6BPhFcxQHgM0GccMFUrVKL67YkD0u3qcI8OHbV8N0K65eLYEWpgfyIQRMhbRzpHnYsD3+npW9eg1W/wsQVV8XSZqskJrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356567; c=relaxed/simple;
	bh=2cXVfblu19YbPAF7JYJ++s52SMhs7ZAY6z4OAMjjk0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kb3kN6G4mq1PG1mwAcahG3rbszbH+woc5YQrB4tBbRWaTRfmyQZTnSAfPVZXXfq57HBK1v5osp0RoNyhqWKPww6AcqZ8dB8fuuG1ahRaRTlND2zxGY8HSnrrVs+Qttt0O0gWqCQxgIk9/Z0lWupPl43wVEMipTov2Fd36f3Wko4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DWJxUXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DWJxUXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3FCC4AF0C;
	Tue, 30 Jul 2024 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356567;
	bh=2cXVfblu19YbPAF7JYJ++s52SMhs7ZAY6z4OAMjjk0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DWJxUXPVFg65cQTYZAiv8R7D7i2QPE1FGA5EDsoD5DE/IgyZHUyrvErjBVNLkeBI
	 FC0IOGekPpFpqci3WIdgtT1dH7u7jHUP44IvsUzsjLiOHt4ecz5iketIAZb1tsUG9E
	 Ho21dBe8s1VPmXe2brsNgJyAwIMGWjVa5ttw86N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/440] ASoC: amd: Adjust error handling in case of absent codec device
Date: Tue, 30 Jul 2024 17:47:21 +0200
Message-ID: <20240730151623.991887309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89499542c803f..f91a3c13ac235 100644
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



