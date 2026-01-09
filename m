Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137CF32BF21;
	Fri,  9 Jan 2026 11:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959942; cv=none; b=sgc7IwXiVkeZFwJMjXGYQqKy0i0h8L+yLlZrTOPHsBdusD44bHksW8jobKL0v4nKs5JFVGgoplvfKVSK/jTd+XLHLzYhLjSo9OD3LUgxZ/twl6myIzFCGyrhtHKg4Wz/jhYI5Cr2FdmT//r0RfhLqrAIT3DjYaRui+yiZXuppb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959942; c=relaxed/simple;
	bh=fcfVpP/WQMnXxFsK1NdbFUJDA2lgjAQesQ9WxiLjD/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r169r2cLWApVpVTSK52ThqynNsM0op5V5Yqke9iOnIHy64qioMeFv3Z5g1V4pw1Ga6hdjx2XJhVIBxTg0Wuzxiq2O5ZExaSbinJpn9CtN6x2VxnU4HJY2TaQn8YlE0RTiksrIBtIADEZ5PBSEveCmKG/Sn+wT4RJyZDTN7xZHlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFFpxfmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFFpxfmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933B0C4CEF1;
	Fri,  9 Jan 2026 11:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959942;
	bh=fcfVpP/WQMnXxFsK1NdbFUJDA2lgjAQesQ9WxiLjD/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFFpxfmE2qWjemacmhKmDfEyVxNUdoaI+qLCl7vxRJ5AnCNqsrDq4unpFLUn2bpwy
	 7oQYdpKX3P1EVuma+e2EyRJYLNPD8bhtarIeLHlfVOFWZV0vSN3lTfvr0BMhDs+8Sr
	 Xugt5wMlKajxlrEh+7TLq99H0T73Or6FBIJE+cmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/737] ASoC: Intel: catpt: Fix error path in hw_params()
Date: Fri,  9 Jan 2026 12:36:09 +0100
Message-ID: <20260109112142.651587237@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f1a5cb825ff1f..10d1c15857bfa 100644
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



