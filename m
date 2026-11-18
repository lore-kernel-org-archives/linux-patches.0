Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041469;
	b=H/nSnqVCq9t6YX3ZSpPLDn+C2VqHpGnCo7pTQ2YqhRtkBld1VqQN1nEOUSsmfwM3t8Hb
	 KQoSkBiWulPwSceqPOAbORtiIMytbzsb6IfIlqTQtv5pnWdYI6V9hKCNvBMzstO+XN2bY
	 ZkGrKFJP5Rlu1AP+0lH4nqsXwNlJQn0usTF68SvIO9NBtaMveyK5aWjIyNxjGcxXjI004
	 SeRKf0ouut97xeVx6L7H1dzxK4xj0D6lKt+RwwRVPHEEzsirpGhCVXAXEb5zxNXn/zzIS
	 /KIG7jzAWxxiiqIRtwGIgxVMkk2nmZmg+oNUMdJcuQZXYrFD7XCgNqTDAEP9odIV5eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+pdqifxL39krLwT0hxZAp3WDxzpS9dx0x/sthNFWnE=;
	b=vlYAH2lMtvx+7RJy9bRop38fye1tFOfuJbrRX5o1bjNXmmzDazi00mhsMX7NpvwyjSdV
	 A8bjLEpgDlfQR4t64lahrsX0laT4+ByAGhRSztOVYh4XMxpQfVCAzeFBRQ68gyzJlrhz9
	 jYAHVnVttf+jqRl0Tb526wrfAlNLPMVMbx8GPZ3MIy1176EJhboJYSqn7Zxw3D7VuTRsB
	 8X6WZGxp0ZZUzszN+BZC4EAs/hc8RKTzdfQsYZUs2OX45TjYjygaZkNG9Se7wz4FZntsP
	 3mIUz0SPUoX2ew5jl0g3WELTWiKfoeRSVO5AL08gWMv17yo9RWch755B5HlcNWLp2gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1eJzaLE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5861960A2616;
	Wed, 18 Nov 2026 22:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1eJzaLE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A795C1F000C5;
	Wed, 18 Nov 2026 22:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041469;
	bh=g+pdqifxL39krLwT0hxZAp3WDxzpS9dx0x/sthNFWnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1eJzaLERXv715wzJ/oocnX8oDPHGUEgaPNUGm1hDq/pmmHxWKAhEbyqBCJygeBaL
	 VyAVNbJqOTNWSzxof0j9LYdtpD9e/SVXQXip4YA9QCfu21VmWZ9E6NS0USfyeNsBnn
	 mX0MRS4BFeObLi9nnr/kTcnrOuDd6lC6B0GHi2XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2825/3318] ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:27 +0100
Message-ID: <20261118150445.389179527@linuxfoundation.org>
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



