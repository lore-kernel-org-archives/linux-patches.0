Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4983EB7E5;
	Tue, 17 Mar 2026 16:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765939; cv=none; b=Gvti6rnPysWCVpVU4QSDS1WhqZiNBaWBHvkNh8BELO6LybJuZnPNytIu9xuz9Z8KK+ZKyVpTF6OUb53ZIDQOIBo6U3cYZqcfO0UkMK000G69f5ZRhIscSGqvi0F3bjsGURtp7/VSiF5InGUpHZq+cufYYdPzsqrSyFdbnJsZzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765939; c=relaxed/simple;
	bh=p+y0mWupIW1yrkYPSFWgz4x62T85uugqjHcqlQDllEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxSIyWfyGw3qiTMBzUpIT/4bXRfZI9lw27pX+zt2pHPJAsOwYUkRGrnY/G+a7j2ZMXYDSKz5H4tMsD5p8/QoyusmOESTQvZxEEcc0zRqamlMPN3NNDqybYSDJVLaL4WnTo6T8fyUZEsJ2FAPHBHU/i2TXt226Ng1hsW4caoMsU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpSMrWDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpSMrWDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8F0C2BC86;
	Tue, 17 Mar 2026 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765939;
	bh=p+y0mWupIW1yrkYPSFWgz4x62T85uugqjHcqlQDllEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpSMrWDdXXARbi4YNTXpvzZzoQbnjKL+L7GAQPWau412/0Vqag8cvVBh33ufk/1r7
	 tdsy1C7KF3s1FFxweScadnVSrno6nOyN7ObDhltGMZeJK/9MaBctawBX+M+Wt0TTBf
	 b3gm4maB+4zykhKelAtiVrZHQdQPPwK9VMRU4gFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 099/378] ASoC: detect empty DMI strings
Date: Tue, 17 Mar 2026 17:30:56 +0100
Message-ID: <20260317163010.659666821@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit a9683730e8b1d632674f81844ed03ddfbe4821c0 ]

Some bootloaders like recent versions of U-Boot may install some DMI
properties with empty values rather than not populate them. This manages
to make its way through the validator and cleanup resulting in a rogue
hyphen being appended to the card longname.

Fixes: 4e01e5dbba96 ("ASoC: improve the DMI long card code in asoc-core")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Link: https://patch.msgid.link/20260306174707.283071-2-casey.connolly@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e6045d30ee8e1..23ba821cd759d 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1863,12 +1863,15 @@ static void cleanup_dmi_name(char *name)
 
 /*
  * Check if a DMI field is valid, i.e. not containing any string
- * in the black list.
+ * in the black list and not the empty string.
  */
 static int is_dmi_valid(const char *field)
 {
 	int i = 0;
 
+	if (!field[0])
+		return 0;
+
 	while (dmi_blacklist[i]) {
 		if (strstr(field, dmi_blacklist[i]))
 			return 0;
-- 
2.51.0



