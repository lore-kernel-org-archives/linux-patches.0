Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036943;
	b=ZFIGc4qkkqlBeBsa8aYuUJqoevDqmaThBn/ak6B7rBjdlXCLhu02jN3mDT3Lf+2INynf
	 QNKHCzoQMQGsk9Xe1XkfkK9+PbyggbBHOhqJanCpsKAHztR/kXAN77M0hgaBetSIgYo2v
	 funpsOQ68Cyprt0Hfa7UVccVawagtkUZUqsAvKJzjiaRKlP8XxXzF2iiiKCg99XD6RwVq
	 H25dD8O6H9fCdO67R9k3Y7PjFvWFEgA7/d8tXBgjLwn3B9BxR6iS4W8Pw9EMzvctft6eF
	 vY1ZtMGVtvLZyYJCmzxOhegfV08ztiWxDEIPvQokUGDlMr5tkvcDPF36ZZIwhiO8eyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tz5YU0PB4gB6QJSEgRwN3Ixxn8jnKLFal8dEx9C0bWw=;
	b=wv3dPwQ36PSDtlX4iVpX/VwkTakffPAqBRtQ0Mq0zITiUmugu6PvK0gTGi3dtOostOU8
	 chqS7CLbkgF7TV3dpo6Ki0Hdoh61/kzJhCKIXQGWhGQa5a/2PRyepG3J1ZCn8wjOiWjZk
	 Eos1lET1AQlkqJJIRlWpLFMbuVQ5ibByXKgAUnVHiOuuIz/bGCU6L4GSbhkR7wcS2UjxP
	 g6PYBkniHnq+eM91Ffys+oCG2Q3buycQvu6jtFSSJh3m8fKXum86FNsx33FY0nBBaqZlf
	 TB6JAgeeTeUbWHt8JKm/vtT1ltAMr+9yA1/ZGHdDeQx4O5pOrt7keLUCPLf1jmu/h1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0g3qllNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E25606A31C;
	Wed, 18 Nov 2026 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0g3qllNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C021F000C4;
	Wed, 18 Nov 2026 21:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036943;
	bh=tz5YU0PB4gB6QJSEgRwN3Ixxn8jnKLFal8dEx9C0bWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0g3qllNtIiGgriXR8/6ysTtKoTrAh0cbqe7IV22zPNC8rnHvDhO1tY35KwwqoncLf
	 3fqaBxK50BJhMeM57fN2zrl/neyXli0c3R3D/Rkx8IYpW87yjD+G0xFOYtBomWbvme
	 JUgLp/tW8Ul7sdaWwz4pjn7gsqa4alc7wzvlmVrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1201/3318] tpm: tpm_nsc: fix NULL pointer dereference on init failure
Date: Wed, 18 Nov 2026 15:30:23 +0100
Message-ID: <20261118150356.202288171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 038701d483513..bec0b1fcad27a 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -258,7 +258,12 @@ static struct platform_device *pdev = NULL;
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



