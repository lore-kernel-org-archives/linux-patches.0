Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031817;
	b=kMbrZ5POip/phYi+DiUJvTOnb9YRcnPrPj1LFhSxTlUUZI9+AfK+DXlsNV0wHa505Wia
	 tMuMkpFlOT2X9Ax4EqnY14l7OBYU7rJtAVhUdZWvJfati6/v7IZbMoyTOidW/Fl4marGY
	 M3DQ88Mnhsy/F2RKuWXZ/oUuqQIqvJCo+FL8y2aoKw20eFJBn8RA7sXA+hYLpXrQyoyhv
	 HspP2pAmyPliwf+Op1UsMKT0L7nF0q18LdRn1UstF/m8JQdEOd05ikNAQWKmu7RIUMOen
	 GlOesSmo9FRjZnM4tWK3LcDyicMINirmoJZD2ET6ouptn/EdZ/zMuPidu67TfAkYeWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ah+tn3Dj+uAkCCkRtrZ7FuMa2Z0dGrSKPK2R1ktD9E=;
	b=3lsonlbUJr3vFhijgVHEtzgnAfivl8zwQqIlk93B7diLan6OD4k0WKEfbDLROIM2SK7P
	 0/61pPsMGSKJCIS8T9MXQB6hFJ0+Vojt9dBglVxXzkHl9RmAnFL7C4jDE2yhGaWSrvjTE
	 vshwMbTUB2i5voBA0A1WgQVFsu3DHu+9+N0iawiEWafuuerlZ20bVhY29hHf4WYheK8xP
	 GuIlJTYiYlLv9OE2dhxOSpRQvQXrDCtqtIlpLcSKMmHTW/rpPANmddq5GXWYWJJ3n7gU+
	 esrF5JlU5Kr3SUDawTE1SN9vw8XnTo+g5cePbdTMe+MuNBvvKjGeSW7ije4S6qTEZOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ejtodakc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A29606A32A;
	Wed, 18 Nov 2026 19:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ejtodakc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C2A1F000C4;
	Wed, 18 Nov 2026 19:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031817;
	bh=0ah+tn3Dj+uAkCCkRtrZ7FuMa2Z0dGrSKPK2R1ktD9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EjtodakczULeJxVQwg4qbBuwNvjoS1tzSuhJQ5wpb4zbqIYRxkwiFYjxpi51/DIJt
	 mcou5fRf6SgFLdwScVxNSNoa78cA/7ytU0OFbqHmhY9NRRfVjRG5ZoRP2BJ5oHrCXD
	 SzM7Lu/h6WvQwZhpeoMtz95Eal+yDWzCDlTgxEks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1150/1756] ASoC: amd: acp: Fix .close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:37 +0100
Message-ID: <20261118150055.822610393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 2c3400aa9f397da48a6760f5e84438973e01a00c ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_dma_open(). ASoC only marks the component as opened when
.open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 623621a9f9e1 ("ASoC: amd: Add common framework to support I2S on ACP SOC")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-platform.c b/sound/soc/amd/acp/acp-platform.c
index 3a7a467b70633..d86323639d164 100644
--- a/sound/soc/amd/acp/acp-platform.c
+++ b/sound/soc/amd/acp/acp-platform.c
@@ -314,7 +314,7 @@ static int acp_dma_open(struct snd_soc_component *component, struct snd_pcm_subs
 	list_add_tail(&stream->list, &adata->stream_list);
 	spin_unlock_irq(&adata->acp_lock);
 
-	return ret;
+	return 0;
 }
 
 static int acp_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



