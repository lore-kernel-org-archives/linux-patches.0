Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6146A455162;
	Sat, 12 Sep 2026 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213480; cv=none; b=pnYpCUq3/Fk4WqUlGde541LkjPt1UkLRGVfq0xXzKfGLOSFPn3UUnOMN1vr25+I/9YoLQkvFtwzWXnjdFKGvdvL1VhrFCOzaYAxpCwDfgKcawxzymAl63RrlwPPoA8xUOni3jrWylos8aWFRH2DLaGwhiqOsYPSzcZzWO7jCwdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213480; c=relaxed/simple;
	bh=YXwXtm5n6wGBxdLqixljDhNR96Qk8EYgolldXXIYr7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBO2aPeZrJp3Y+dxhIMFflWgUQz01MVGdXAbu3hdV4ZUNanYvHhlaseayzhGVG3vIVEGogV6wXkWqgoOpXqeJdfomwn+sQQdrHX56CpZDC05t/ELkpfd8hhHUzhVPIg/NjQDSmzi1YOoYbnwiqt53OCK4fPIQpsKWiz/D/I+T9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABjIPrDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABjIPrDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EF51F000FF;
	Sat, 12 Sep 2026 11:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213479;
	bh=89aZmz6wXyZ721X5Q2AuMnKp+vPThx/Hdb0/xT9PoL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABjIPrDBwVXG51S3Ap/DlBTexSkra8CYwrRloASAKFYtiCJiG4G5tJZyIRuhGfCoJ
	 NkezedMrrilHKnmuWTZKAiECd8JGUw5NaG3SLYIOXGvWvUPcd3NxzujK/B+F6G4hUS
	 OuS/dFy/5n/aRa1cTFXzwmZon5aopbeIyOxjEUzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0129/1376] ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure
Date: Sat, 12 Sep 2026 08:42:35 +0200
Message-ID: <20260912065610.432286793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 3a89ddcf0c3d9a068631e8c24d5c9e81d1e6512a upstream.

mpc5200_audio_dma_create() creates the DMA resources before registering
the component. If snd_soc_register_component() fails, the function
returns directly and leaves the DMA resources allocated.

Call mpc5200_audio_dma_destroy() before returning from this error path.

Fixes: f515b67381de ("ASoC: fsl: mpc5200 combine psc_dma platform data")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622094822.926166-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/mpc5200_psc_i2s.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/fsl/mpc5200_psc_i2s.c
+++ b/sound/soc/fsl/mpc5200_psc_i2s.c
@@ -170,6 +170,7 @@ static int psc_i2s_of_probe(struct platf
 					psc_i2s_dai, ARRAY_SIZE(psc_i2s_dai));
 	if (rc != 0) {
 		pr_err("Failed to register DAI\n");
+		mpc5200_audio_dma_destroy(op);
 		return rc;
 	}
 


