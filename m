Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E22393DF3;
	Tue, 16 Dec 2025 12:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888227; cv=none; b=O7KpLjURI6CFUJwhcuKDc08gneW+WjmrdktPpN3ha4hWcmo2D6dy8yhzP7yi6vJEKi/TJCRDbK1O6BEHQtWHlEgKeh4u6xPNPAfJ91cVlBUnptaewNmGPaonEK3E1Ctv3P3Kv6LP+EsulgSoRGUsVWm2K81eq+qoJ2Nn6lUXBJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888227; c=relaxed/simple;
	bh=uPZGInyT0uZW64pRZxRTW1COsiV9BaF4QjXSEj54JY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZpqf7UMMRPGnm5+kQQhbj2A2rcCYmB462W8uoulxSfZKnJz8xTl+qMHYji6pUXtyLWOzWA0x3EZTqMxv4Hw3mHnkIslmmQKogaoUnNZw3ZFuc77afpPSXrO4P5ucGeJDmdhc+KngpcK3Ou4uWBYIkz0TO1sut+rV7jklhqT0Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pijJswye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pijJswye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674A8C4CEF1;
	Tue, 16 Dec 2025 12:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888226;
	bh=uPZGInyT0uZW64pRZxRTW1COsiV9BaF4QjXSEj54JY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pijJswyeZI1jsdVzhiJAySBtLeihbXt4LNd5uS0pV3fSTnZTnx/5wA0zvHpCzJUOf
	 xePRihej7YySRpv+sbMrSrkabGTYfQ5XISXThvjr4Z5L1wJQUfjrBSm71Zd7+lpngs
	 OWNK+hEN0hgy21SC0I72EL7fvkQpDQlPcju6jBxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 471/614] ASoC: Intel: catpt: Fix error path in hw_params()
Date: Tue, 16 Dec 2025 12:13:58 +0100
Message-ID: <20251216111418.435516278@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



