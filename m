Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829710;
	b=cXFBVVQoDpcebRZjk4EcSQP7dkVNpgMAFOHHmBVwmT6QqgteamUtDr6LtlG2x32/d5K/
	 biwIvaV87wV0rJJHJzF3WhVotJROO60qyEqzxjaxININ2vg4+8fLhTA1Xsu+6Lor4nOdw
	 j3JmCZlirtjGWa/YZ07avs3Qe9j1YEzooNz5YibTVc6crvHgOn6TzNLoTmIhbMaH4BBYH
	 GT2mnqnL+2qHoa70UHkzORb4BxDppELnp9wWTgG1xeR0f7rp2qQZu2vxb51VG2w1zmvtd
	 IahndGalotE8KsktKSEvCnk7+upzQRC0LeYYAfi07fv+2EZ5JiVMphO5r/3W8CNopRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qB+jhF99Ih1M5PmMvPNTOFI8NiDSbH1AMn09uSVYBTI=;
	b=2UYNxPfXbxBURcfzkHb967L0CkpeTQo4BCDJ6A6/6MzPxDJjaOVtco1uHCFKo8HZMgPY
	 IqJnnPCMWGAPkxnB2heAd0vzUi+dSfhemjm6BTKLSNHmQgdDD6pw+JPvAh50ktF5RKAKJ
	 pO9giAbXHRSzLUBGImfGw8Hm/EtjsG9si3kG2rSaiOgf0hVhUJlesEXnUAtNLdi2McHWN
	 U4xkbCcfoMHSO892oL+dmFLKzO5T2zWbkouIuJnY/cHodoH/EYUZp+e6k+KLUv5f1SMUM
	 RbM8MxMsVfA6PYyWn8NRi4FC8pGY51oDiz+c9QsVsU5qI3vy1xDKqjXOr2GJ7JEVyFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lloP5Al6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8957606BA3C;
	Wed,  4 Nov 2026 22:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lloP5Al6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DC21F000C1;
	Wed,  4 Nov 2026 22:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829709;
	bh=qB+jhF99Ih1M5PmMvPNTOFI8NiDSbH1AMn09uSVYBTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lloP5Al6DeEmnKZeu9jQb4frNeK0A01MaD/Xz/4A2As9kLXiDulSzPWYEmHpAshjq
	 LtfeNX0YvVM1ZJnbjjHKw4xLJpwK8ZglGMFc8cvfoV9zZpBqbAKXdJWzVe3kxUG2BV
	 WXUpTKaO4TwL5QZkcnNTv09Q4JZlYREo9yRA9m/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0293/1005] nvmem: brcm_nvram: fix out-of-bounds access on malformed flash data
Date: Wed,  4 Nov 2026 16:00:26 -0500
Message-ID: <20261104211052.119831708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a67e2c323a47a2254ed3472b5e4c53abac20f116 ]

The length check in brcm_nvram_parse() validated header->len against
priv->nvmem_size (the full partition size) instead of priv->data_len
(the actual allocated data buffer). A malformed flash partition with
header->len between the two would pass the check, causing
brcm_nvram_add_cells() to read and write priv->data[len - 1] beyond
the heap allocation.

Also add a minimum bound: len < sizeof(*header) could underflow the
data[len - 1] access.

Fix both bounds by rejecting len outside [sizeof(*header), priv->data_len].

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260729094647.111468-14-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/brcm_nvram.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 4b3781a70222a..5ec2ceefb77f6 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -192,9 +192,13 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
 	}
 
 	len = le32_to_cpu(header->len);
-	if (len > priv->nvmem_size) {
-		dev_err(dev, "NVRAM length (%zd) exceeds mapped size (%zd)\n", len,
-			priv->nvmem_size);
+	if (len < sizeof(*header)) {
+		dev_err(dev, "NVRAM length (%zd) too small\n", len);
+		return -EINVAL;
+	}
+	if (len > priv->data_len) {
+		dev_err(dev, "NVRAM length (%zd) exceeds data size (%zd)\n", len,
+			priv->data_len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



