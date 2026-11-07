Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062036;
	b=3Uc/Z2Cenh+dRBTZIHgGDXCMdNWe3do4s7GnAc61Rc4VlLjCNRj4cXvOq/RbL/7e+NFh
	 xEi2WQ3AkOKZ00WScIzEycPHJbWss2VWDq44oQqNyM55OL0r8zCPliuXqSIxcwvCzZa5k
	 LV0na2PI13z+5HqudJQMrziDzRoYm7sgJcPJq5+VQWAJ7FC0RsLu9ZGnw7x3C3+vG0bHk
	 I+rGapuyG2Hr2UMQC1Iro+zE7MsG1+/eswGjDYzJBmk/9OpRGy1UQU+3PkIybeoe99DQ3
	 oNxHUp3piDgguf+8+mYAouvA34lrATkV3aABmpRi0JQtVTpEYByOUhUgxgIy6VtUCCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bxWe7zI3tCN0DVDx0fK3fERZEApoi3U2FOAqdCVwJBw=;
	b=2K5Cyg/owl/L2a0ifpnku1wUNH6QeirW/pbqhk4b2TRZF4pPenIo4QEteAlNAgKrGh9Z
	 f+OIBfcAZzyCCIszOkfa+yjDmz50b2fzOteyngt4qQCteIEjA12bGSbd5qoj+nlxY8hyY
	 QycPZwb3X7Ebl/ngCBhyMXQJstZ+TCr2QmZBF9YVRv3Q44pmkub0cqBRJ5NulIBRkCGu0
	 L6ae03EFDjMql6C0PsOA4+5KN8yQgqmSwfm6wo9Xtd/gCy+TNneGSq8Javl/O5dpSqM/q
	 062U21K79pddmIqKcdZjiXIJFsDF82dQBOQHg3sw012YFxfEjnGUONJcJVXEETUDFVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kn509FSj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C9A606A332;
	Sat,  7 Nov 2026 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kn509FSj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D407A1F0089F;
	Sat,  7 Nov 2026 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062036;
	bh=bxWe7zI3tCN0DVDx0fK3fERZEApoi3U2FOAqdCVwJBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn509FSj/0HYj4S4WEd+FKPtNfheeBuh8nnw0e/EAkHQ0ggygIY/EkTPDGh58PgfS
	 0nutsfMpCB0aeQVInEVfQZlcHuvsyV45JVfegu2B98oQHEwAE3ypfqa7xO99TUjnfN
	 aJyffsIaNRpSO4mOFnhti6ElSuJg1MsmHOElzOPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1019/1536] ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()
Date: Sat,  7 Nov 2026 08:50:35 -0500
Message-ID: <20261107135026.299764507@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ba593d662183de74d2b733b4c6e8cd26f04f0a65 ]

In __davinci_mcasp_set_clkdiv(), pm_runtime_get_sync() is called at the
entry of the function. If an invalid div_id is provided, the function
hits the default switch case and directly returns -EINVAL without calling
pm_runtime_put(), resulting in a runtime PM reference leak.

Add pm_runtime_put() in the default case before returning -EINVAL.

Fixes: 4ed8c9b737b6 ("ASoC: McASP: add support for clock dividers")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Tested-by: Sen Wang <sen@ti.com>
Link: https://patch.msgid.link/20260916073136.1971673-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index a0b8cca31cba0..6ecf88d07e1d9 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -647,6 +647,7 @@ static int __davinci_mcasp_set_clkdiv(struct davinci_mcasp *mcasp, int div_id,
 		break;
 
 	default:
+		pm_runtime_put(mcasp->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



