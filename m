Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EE62E11A6;
	Tue, 31 Mar 2026 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976685; cv=none; b=ooy6F/+hF6Ww8yDiYr/hBu1Fu5Fuy6TDwJk1ESQWRt62I1396ExcACmoT1ISLuKQny0qUKtkNYHXXxtFCIu51latRbngFCzERFUNq02d+jtuuRBe3p6mofTx9f3ORPrQfsDTmFDDYEQWreqwbju5aawZAi4p5rdMefUI3S0AwfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976685; c=relaxed/simple;
	bh=WmjfxA7ZkkdXm5G8F5yF7aKpKSkytuZMu68K0q92hpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkhLTry1GMxjXlmoQrElKaIHx5ZpiRJKqmBCVeDL2WMJKPLIGcoVXl5Bs7yk6mrsZuGHkFrjglRE1+p3BV8gZFgc33bROj+Ov+kd/Gn0yeSey8NI4IhXE0YPS7HcGdNjP08L9e9EU5C+2ZL3+7z9WeA9wQT8fqwk4W5TubA2LHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8QkE98x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8QkE98x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E489C19423;
	Tue, 31 Mar 2026 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976685;
	bh=WmjfxA7ZkkdXm5G8F5yF7aKpKSkytuZMu68K0q92hpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8QkE98xQbxsj1SSE8FIZqyg7V43tOnEcKNPL2prKYOV9JYm6xT0YT6eIXKzgPlTp
	 QFMmho+aY+t66oXdF8I57pJoultD50QlWkSRyf5QYKCcoM/SyneT4Gyn4kP3W+WiEO
	 X1cG2txABEl08GmdBhbgdKSJ7NVL/cpY+MPMN0xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 188/309] ASoC: sma1307: fix double free of devm_kzalloc() memory
Date: Tue, 31 Mar 2026 18:21:31 +0200
Message-ID: <20260331161800.377987939@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit fe757092d2329c397ecb32f2bf68a5b1c4bd9193 upstream.

A previous change added NULL checks and cleanup for allocation
failures in sma1307_setting_loaded().

However, the cleanup for mode_set entries is wrong. Those entries are
allocated with devm_kzalloc(), so they are device-managed resources and
must not be freed with kfree(). Manually freeing them in the error path
can lead to a double free when devres later releases the same memory.

Drop the manual kfree() loop and let devres handle the cleanup.

Fixes: 0ec6bd16705fe ("ASoC: sma1307: Add NULL check in sma1307_setting_loaded()")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260313040611.391479-1-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/sma1307.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1779,8 +1779,10 @@ static void sma1307_setting_loaded(struc
 				   sma1307->set.mode_size * 2 * sizeof(int),
 				   GFP_KERNEL);
 		if (!sma1307->set.mode_set[i]) {
-			for (int j = 0; j < i; j++)
-				kfree(sma1307->set.mode_set[j]);
+			for (int j = 0; j < i; j++) {
+				devm_kfree(sma1307->dev, sma1307->set.mode_set[j]);
+				sma1307->set.mode_set[j] = NULL;
+			}
 			sma1307->set.status = false;
 			return;
 		}


