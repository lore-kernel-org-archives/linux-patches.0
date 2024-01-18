Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C974B1B96D;
	Thu, 18 Jan 2024 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575240; cv=none; b=Y25mA3dHjGoD5DiKPivRWyKjv2rT83rPf9GRJkiIEK+HWbtWNud/O3ctiIQ7CAeueiqQskSy7Fg3uPAIX6zXBzOPdXqujaFpATRS1sFF9c7K3Ci3neE+gDhP9mNtrp9GQZ2Dt8vzPa/Jd0A0GJbBWHeftNx8rz/CsokyWwAHogU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575240; c=relaxed/simple;
	bh=HUSwMvP0xRc+sC9AmitzzX+J011MAbfS2v2SeIJvuX8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=OwmPDZWpDwyo7fRv1MNiUAwWpqrT9pr5JMJw6S7S3+aEJP1cNNMbnknaJ0TI+3NY7oFu8CmR02IoChdyvmZhJvjMWCTf2oxc4xPdWC4c3wWqgoJmGJeyJ+iZR/xZ25r26PaTGvj4xYRrQbxB4bs+5Jew7qRuhTLMvAXeaHj00Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbDlncGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbDlncGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB08C433C7;
	Thu, 18 Jan 2024 10:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575240;
	bh=HUSwMvP0xRc+sC9AmitzzX+J011MAbfS2v2SeIJvuX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbDlncGS8+kfljInIP96lpK0tdLAzMnVmQquzSqNOBF41wHkEiEHJqBfuvK7CRr3j
	 /yGSK54b8RvdwuC6HR7Jsyczvab0J5oeS8xxxh/FZDHRbqFBaNmB7qOIZRXDu+brwF
	 1/froKlWK1O8jLG2gwX+kdCU4qlXDlcATLYCwItI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamil Duljas <kamil.duljas@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/150] ASoC: SOF: topology: Fix mem leak in sof_dai_load()
Date: Thu, 18 Jan 2024 11:47:35 +0100
Message-ID: <20240118104321.629544570@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamil Duljas <kamil.duljas@gmail.com>

[ Upstream commit 31e721fbd194d5723722eaa21df1d14cee7e12b5 ]

The function has multiple return points at which it is not released
previously allocated memory.

Signed-off-by: Kamil Duljas <kamil.duljas@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20231116213926.2034-2-kamil.duljas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index a3a3af252259..37ec671a2d76 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1736,8 +1736,10 @@ static int sof_dai_load(struct snd_soc_component *scomp, int index,
 	/* perform pcm set op */
 	if (ipc_pcm_ops && ipc_pcm_ops->pcm_setup) {
 		ret = ipc_pcm_ops->pcm_setup(sdev, spcm);
-		if (ret < 0)
+		if (ret < 0) {
+			kfree(spcm);
 			return ret;
+		}
 	}
 
 	dai_drv->dobj.private = spcm;
-- 
2.43.0



