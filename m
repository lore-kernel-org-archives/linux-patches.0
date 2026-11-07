Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065305;
	b=ZhBhvtzYi9sPA1kWaVkBBP4hRw08o2qmMDK8A9bdt8GluhJOcknI96JeKLlHSxpIdA0z
	 ET+CDVuELakmWPKcjf0miK1VXtzHRO6y5uRYIHnd30sKXnCeygAR8f77QaMcKhRCub+fV
	 Sr2qJ1Svwp2+lYmczqJrnE/GCGhiM5FYHIyO4H4aNE2QfN+DmO0KoszXVR5FE+8AKBOBZ
	 hinz7Oq+1WunIUPjSUL8O2w4IRa2HEjtqoiIiCJi8qa21HmdmOhMDJwwW44vuy71wuhEe
	 ffM5UL1GQzyrpAcibBcj031lv9FiNNMznB6F51gsPOD0UA1x22xS3D+69Hx4JU+fi5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i1+uefz76+MzKsQScxV8ifZiuEQ0NXOvwdPhwolFx5Q=;
	b=vKsr1v/jyP1cHVrK6BcyqUoN0ABXZputFxNn1LZvTOA54XAQYa6Z8hFK34DiZZYyELvP
	 3msf8l3L8sW/qCUD1idXPeBomH1Ebh57rZRoJnvLqMmxqT10dk3+FtFNUoWMBlYbVTZQ1
	 yVnUQRohEOBnd4k0mZMrprIXrHUOEXNuINko5C5ld2STx0giesEvHTh1vjcFwookz8Q/1
	 ElV2GQs6ulNPpCVZcAVrQjJP7FGp1VPIjzpZPRg685Qd87QeJXuZ1KXUK6ebzovt4H7ul
	 AL9nb2SW8A3EaDbPetue/KnYh8gHOQkJHqf21xkac0mRqLcXEOgib2vmwnDofBVA/ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vh+lgoSQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F76606A334;
	Sat,  7 Nov 2026 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vh+lgoSQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A709F1F0089F;
	Sat,  7 Nov 2026 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065304;
	bh=i1+uefz76+MzKsQScxV8ifZiuEQ0NXOvwdPhwolFx5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vh+lgoSQkRsFH5+AuRB2Zglg94r1YZpqR643g0bit2SwuC912WrA5LC/0bLkVw7j4
	 c1IzR0jQynFiMMWNK88lC7xCiut0hnndvhP8/FlNt+tlw6472jcMbrl+SLhPN9m4Gt
	 quACoRwqvZsNXe79fTzEQwALee7GxytsTLtV7xxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1030/1257] tpm: tpm_nsc: fix NULL pointer dereference on init failure
Date: Sat,  7 Nov 2026 08:55:26 -0500
Message-ID: <20261107135007.770128493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 1900449684cf71427a51e0bb1d7914c0c8b39152 ]

tpm_nsc_remove() is used as the release callback of the hand-created
platform device and dereferences the chip drvdata unconditionally.
If init fails before tpmm_chip_alloc() (e.g. request_region() cannot
claim the ports), the error path drops the last device reference and
the release callback runs with chip == NULL, crashing module init.

Return early when the chip has not been created yet.

Cc: stable@vger.kernel.org
Fixes: afb5abc262e9 ("tpm: two-phase chip management functions")
Assisted-by: GLM-5.3
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/d5f0b38d6d6c17c01519c879d26448dbae388b0e.1791015549.git.xiaopei01@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_nsc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 879ac88f5783c..46a52dc99b148 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -259,7 +259,12 @@ static struct platform_device *pdev = NULL;
 static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_nsc_priv *priv;
+
+	if (!chip)
+		return;
+
+	priv = dev_get_drvdata(&chip->dev);
 
 	tpm_chip_unregister(chip);
 	release_region(priv->base, 2);
-- 
2.53.0



