Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019973;
	b=gkbMGWmXXeZjgc3HSMJF/T6y1EerOvUSY4tJNWBZcdhVgmGCqYC2xnVqBqdntGlyvnCs
	 QeJ53BZThCPPtsbnrfArDconpKT/4MlTwtNtKNPwpKTIP300vGcfjolo5xRChtrL344Og
	 qi1dVHX26Bvo/fpv+Qa2UcsQk3PlYCFdOZFSX01iIAqsjjfOzwqgp9pVTHD+vbR0Dw9Eo
	 KovflgU42y2SKSK4e+KeXSAr4t/j/iLtgJ5znCd6P5fFyNDPfKG3rMjizQgiMM8KutQvg
	 lYpgZHYla/NqZ4dxUDM9g83j8T/8pblrQHoLxCMIrdGWkRwCBmJwrnr5SChBSdXkkhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eeGeeMZiv25+k7cVa0pCIRFyx5Zc9TzjAnbyXittSwo=;
	b=dBtBr61rXBjMRFwru4fWcGgHSRsWJ7I0l2r/HecxyvxtkkE8mg1l67jdY9EK+LgGh0zc
	 Ucf7qQ9slWjuz5NdKn7ZlrsOsqRvpepYwQVWfDL0l6qw6xvqXAB5JSwgGa+3zk54fwjFV
	 iwXq/EfeVDyKAaZA7/BsoLuiSvVIGjypU3FTuHSEh26tdTJ9QBQB/t1q4c9jEYTvZgUKV
	 7N9hCMNgCcjvuM+2tKj6ndUXUYPhavbIwzuVjnNdNMvwwlYXTQn/LTYXo879q27XGjqm8
	 OCXm/LyzDvWAC4a9MPsI+pGYcWXpfKnAcyXN6mE/0QKo1P3Mbojy8oyC4HfwiSYxDuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVzsnvWb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B46606A31C;
	Wed, 18 Nov 2026 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVzsnvWb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62041F000C4;
	Wed, 18 Nov 2026 16:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019973;
	bh=eeGeeMZiv25+k7cVa0pCIRFyx5Zc9TzjAnbyXittSwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVzsnvWb+CdUvElhpI2do5DyFBt3kTP8GOXB8fMg/Hlz06ooZGOkOHpvV1mclQsHa
	 7eZ+2sQHIwzbCAmlb9Nd62bNEuVu66SJaj4DdblVxVQbaCTDcQV8DsLoX/hzmzpPyL
	 Kmfv8MdfF7p/0ztVrlCWx3T1hwNEnxjZdpkiIY84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1784/2651] ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:24 +0100
Message-ID: <20261118150351.574283161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 374f93fa6e0b0..552bfa30d4ba4 100644
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



