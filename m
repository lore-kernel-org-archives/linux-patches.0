Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E100934CFB9;
	Tue, 16 Dec 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886408; cv=none; b=lj9omd2lNXbHb0K5fA8e2ZECAp06DS0g6sDGRjUyiXaFKlK5Y0XVQEXf5XVu2cmlEM5qW2/nFM7McxRKakyVqtmiyVvQVku2LgtJYQJ8JzlCOFc1h/P3PHT42MGflNb7vSNPl9J8VGovgjuyM2anBhAkxCXd/9vcB74JVsWWOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886408; c=relaxed/simple;
	bh=R4rkeoRRit9PnLFk4VJk3JPrZEJ2af/nC9daRPTcth8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2AkBR5OHgBJu3aySzwXJrPDpCjxn5mbCT5cffieLIqa+HhXPXtok5eTewCLV9Kb4SVJ9a51YAaggnCwAgkt4Dnq1nKN9oJJpRV1kf+XJVF9pzx6ONRdZzNmf1aVapRuKPnHilR1rqlkufr6xfaaEbKlPUDZVr8WZtxaonfGuCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSsHrq/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSsHrq/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DA0C16AAE;
	Tue, 16 Dec 2025 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886407;
	bh=R4rkeoRRit9PnLFk4VJk3JPrZEJ2af/nC9daRPTcth8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSsHrq/+1Z33qI5Yf1cbLGWRYRmvI4G9KNBtIBGtKGlPIb0Hfjrtbr9ZhKipc5BrL
	 6B3dwyInAfr4p1ivTe6gQCEKCopMvp/S/6GKefBl0zrAXFCg7vbLFT6gRncfhUgHrR
	 2BJn+1qVVXXDMl3IlZZVgGCTKlsxiIgZ9ry3Njbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 384/507] ASoC: Intel: catpt: Fix error path in hw_params()
Date: Tue, 16 Dec 2025 12:13:45 +0100
Message-ID: <20251216111359.370811626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 86a5b621be658fc8fe594ca6db317d64de30cce1 ]

Do not leave any resources hanging on the DSP side if
applying user settings fails.

Fixes: 768a3a3b327d ("ASoC: Intel: catpt: Optimize applying user settings")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251126095523.3925364-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/catpt/pcm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/catpt/pcm.c b/sound/soc/intel/catpt/pcm.c
index bf734c69c4e09..eb03cecdee281 100644
--- a/sound/soc/intel/catpt/pcm.c
+++ b/sound/soc/intel/catpt/pcm.c
@@ -417,8 +417,10 @@ static int catpt_dai_hw_params(struct snd_pcm_substream *substream,
 		return CATPT_IPC_ERROR(ret);
 
 	ret = catpt_dai_apply_usettings(dai, stream);
-	if (ret)
+	if (ret) {
+		catpt_ipc_free_stream(cdev, stream->info.stream_hw_id);
 		return ret;
+	}
 
 	stream->allocated = true;
 	return 0;
-- 
2.51.0



