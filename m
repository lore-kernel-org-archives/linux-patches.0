Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041466;
	b=rqjfT5Ll6J9R30/iORI33dQ5nle5duY1g1uzZa7f81BPUFNrrc4HuPGTCevchn9z1U6V
	 XBcoqU6/fUIuR7/IiPSQ8mrWn0IPAI2HaoGFwuU9DaUI8S0Xf70oUyQVZnCf+RNxRW7OM
	 7yev8EadNtaGLPVUJVic1zHL88B5BMhvrlhK5+B7CuFzoiee3W5U/tD3EC6w76P7MEhTj
	 TdIOhJbHaTXDtXTYWi/o0NFMXDoJTV3YBb6JZ8WOkX7uWYT/13B/CH6J8/24xRAyWw5jg
	 oPD2wLKlqpKoP3kRBqcnhWFfmgloNBqFt4FeZ1OdH9vgTVuJRo+H5jzAXv45FWwgIJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9KbA6fzj5Za9kmXYZ1EoZufpuHAmgOMGDMGwMi5jGg=;
	b=cGv0VO/hmRdVPeQiKcJrZY6mmbVeGhg4i8ablmqqS5nD83uzs/SaQm8oG9bxnkxqX8gP
	 eIzjo3I+A0PLj+ALAEH7NTA9/6/NhZX0RMLEFqQPSztoO5pUN3zSJ7fgBypJmJhT/KUgC
	 7SzltWiSicJtMoFOrafInQ3gQ1E/i2ZJucOwXexjRfNpJHgwSrYlAv5ylGrwnaAMXJmam
	 aJr/5VO01hJ/wyi+u1Oa9vpCWIWDZUNH2IxVLT9b15rG/dyvdWSD8ANyqOoLq26HIZepc
	 X4iULL9oAB5ypOqouwZWdiVijrl+wIoKO3kEH07zqZgpuooQJY0II03htpgkizGX7EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V/pG2ddx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A93960A3839;
	Wed, 18 Nov 2026 22:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V/pG2ddx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14F31F000CA;
	Wed, 18 Nov 2026 22:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041466;
	bh=s9KbA6fzj5Za9kmXYZ1EoZufpuHAmgOMGDMGwMi5jGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/pG2ddxlg0+eIn+is2OTF2urFQkS3xLu/aaUMwnzpjyJhBNzA+IPhxSyLwD6sCJg
	 RkZUgYapd6mNb/fHwyqJiNI/QaLxKNR4BkonEC+vhTkxXgvsUo+ERXprpqywMldoqI
	 HbZvCyZbDuFssAjqtYKtEVnEP8UI6dY/O3nOMx5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2824/3318] ASoC: amd: yc: Fix acp6x_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:26 +0100
Message-ID: <20261118150445.361383169@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 06654a3ef5137719be880a6cd12bd453050eafc5 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp6x_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: ceb4fcc13ae5 ("ASoC: amd: add acp6x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-pdm-dma.c b/sound/soc/amd/yc/acp6x-pdm-dma.c
index f332bea36595a..a6c9d6b4f00b1 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -209,7 +209,7 @@ static int acp6x_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp6x_base = adata->acp6x_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp6x_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



