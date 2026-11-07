Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062524;
	b=qKgjunYNkI6Ua5iqIc9Lg6+23qgCf9H5zHjHlkYM7eVmjFzvgnR4q7LDOxYNEmS7Zn+H
	 SWLgE/42ABKK2hBCN2bhf64yvBhODfAncbxSGAC69felBb6ZxG3V8A6pWpbF6CaBC9vCN
	 QK+N4NuJd7fUEsGD+91CZf630ESF0adZMBe8SUlYgOKw3gVql4FCXXAs9MLBVzcv3yZbz
	 85lN3JKkEIapJNlWN9FGg+G1Lu05zAGCsb28BVD16YbOB1CM+RtKqO+1Ku5Idd4vAuIdV
	 fb+1O4pvOnEzTF+/StzvaVUanVuyz0V1GCQwJHwtU3Oq/742G3aVxv9wElNGg8RCxQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iykjAiI5+EipGxM4jwhl/WOLIZ0BU5QxqdTQlvvmx8k=;
	b=WRnHSRDtPQlMadDbZDyz/1g6ZS9/r3igXWmj4EoQ4LC/et836wFqUyI876XZS6n2m+fg
	 4kRGuQ8BzZMqjn9PgY5jm90zCNUp3gBmoQguPT7PLPi/LjdCyXSEoiLhrZcwFbo4ds6Zr
	 W35DPAr0TutLLRh9k4dl7qIdnvypmAA2h4DBLO6YsWRnbrDja/OtCnOH0kOuQ/DXW+PlQ
	 lk1FRDhBbvtclaWFRwEX4bBSOo5efechNN8iPRWZ8TcGgCVKlOrsZEitIpz6YhA39OPuO
	 6Wsyksgn8kPvA9YNMfuUpwPUnQuKmqP7Y1W/JwoDOEVBuAepoXkrUmNMdUCqCeY3FJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KcXVaEG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BE36083615;
	Sat,  7 Nov 2026 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KcXVaEG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3991F008A3;
	Sat,  7 Nov 2026 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062524;
	bh=iykjAiI5+EipGxM4jwhl/WOLIZ0BU5QxqdTQlvvmx8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KcXVaEG9NLHuyuXeEFf7AMNFNqWtT8974/REF60ckqJfkKf4epL+hHLEJsn+A9pt
	 OWo6EwjmNkvuLU1q5K6+VWZ3lBSS01TPjypiUu3ZToiRzOxBsVMQXndc/kiWWDQXid
	 OXDBrsKeoGidzdCB7Hz+wTR7NBMdx5dQ8j5jgIxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1418/1536] tpm: tpm_nsc: fix NULL pointer dereference on init failure
Date: Sat,  7 Nov 2026 08:57:14 -0500
Message-ID: <20261107135037.656218310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0f62bbc940daa..b165b274680d6 100644
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



