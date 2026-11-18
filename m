Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031716;
	b=oVg1tnz0+DoejVSfCQcgyCxxYnkZaxO274O4YJuDzxpuTFQ0nolS587CpXgcT1uk5y0Z
	 L1yztpkGF7fn8ykbvcI1r0BdaY7Di1zlywtjvAdZQZ08s2CrfJosOBaupPYPqEAg4uS/a
	 N2igt4pbutJKss/UqL/S2Qgbvhqphvml4T2uEi5x0yD+a7NVoMh9grgOz4XXUvVjUSBdZ
	 +Sh2tsXqrgPMYAqN4/reLtfMU8ZMDZLJwcNDHzHVVnTVyLQuxPOBE0zvNoKv62Th2wwj0
	 w6r9icFxxGyGFBrP+Br2s2zGm3niMIz4KBPbyJsQQtGAK2W21527oY75ITsOlnoVKlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OEJzHxlOquqs4hII4FM1o5/c7ckDxEsHTTAvxv6MA84=;
	b=zoqNYOoFzSm5RYkQGv0/+yHYKZB/MciDzMSpWgKBk4w4YNuhGrE2OJ1lwVsVdwClKGb6
	 WPmt5haqMO9ysWsIcEio0+mB6T1sQVnEjfzc6Wq1NrG40OJaYny3pDhTZlAL23mopEsrG
	 g+6G2w+rncutuiqsdtDqNvxjeAIwvxJZNAxrbWKoKTYMkX8urcylyVVs0FO6qHbt2ycE3
	 Ma9sWPJOayjp7JC5+RWVXPms2dlPTnLVgxLFop2JNf7cEb+B9dXUfucITX0gjy6Mi2wRO
	 vp52oJyOwCuTBpO3KwTrVAKKtp7AIlTBhNqYfRdFGhVoHbKcc+2tKlkAerikkn8Ex9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TafeJRuE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF114606A31C;
	Wed, 18 Nov 2026 19:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TafeJRuE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E431F000C4;
	Wed, 18 Nov 2026 19:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031716;
	bh=OEJzHxlOquqs4hII4FM1o5/c7ckDxEsHTTAvxv6MA84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TafeJRuEu4nLU/iXky0B2rzp4OtjPFQ6JyXSRg5Gs1nAudBYv/RtA2dYbxp4yRaz4
	 /KVf2MbKA26WnBZjET7ansowdlJfxMgb/WWN9OU8njpZ7loWqbMi2MtX8y1UD2EwGE
	 a9R/SR3u+srvBqKshl8n2PCGlI5jX9HIvy4kdZ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1157/1756] ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:44 +0100
Message-ID: <20261118150056.077790228@linuxfoundation.org>
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

[ Upstream commit 50aaca643038774b6779c911c4f96bc7e0d607e9 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from atmel_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 92dfa6198623 ("ASoC: atmel-pcm: split into two file")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-pcm-pdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/atmel/atmel-pcm-pdc.c b/sound/soc/atmel/atmel-pcm-pdc.c
index 7db8df85c54f3..ea834d3fd8c3a 100644
--- a/sound/soc/atmel/atmel-pcm-pdc.c
+++ b/sound/soc/atmel/atmel-pcm-pdc.c
@@ -295,6 +295,8 @@ static int atmel_pcm_open(struct snd_soc_component *component,
 	}
 	runtime->private_data = prtd;
 
+	return 0;
+
  out:
 	return ret;
 }
-- 
2.53.0



