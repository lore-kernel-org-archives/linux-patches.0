Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC6A26A08F;
	Tue, 16 Dec 2025 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884638; cv=none; b=gHvERvhDjJSoUPIt+NUWHH1XjikX6SFaOE/q0sExGvbQFmpDUH2unXkXmnZ+nW67wcFspv6tkJ1we7BlmPfk2LzUmdHzKTUNqqP7HdEKPdHIXel1LVN3AINEUDMcnieQp5LCAMJfVbZaM+ojx6iLBwGzV8DhFiB4qGJD2+xrTRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884638; c=relaxed/simple;
	bh=5tcisCgf2Jcx76WdJXvWxCnI2+2u2JdAWOCybtVcPaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hU56Du1FKbo0sT9cTiB0sNsPQz9UEKPsXUOr9TcxKwhNAvAZqOIl99zxVYRgfWiGQf8mzG/OA7ZZTXMwnfXoFWMhy82+s91XQM9L3/bpNoSOhxr2narg2dVkgPVPqFfJYNJ+aoeLkDYKvC6z8tFFHUICJGvSO2IuLGOax89yWro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JF1qLVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JF1qLVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CA8C4CEF1;
	Tue, 16 Dec 2025 11:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884638;
	bh=5tcisCgf2Jcx76WdJXvWxCnI2+2u2JdAWOCybtVcPaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JF1qLVG3LcfWOJVJu7WCUQ06f4D/EL/oZ8+Lk0+0ztUQR3lvq0NJNzHajx1Ksz7a
	 AnuGGPQPwBjfmKMcVlJ7oxqaI3YT0O8qnWzV9t3KGLW2eWnDsOmSXnjaFjWIocHzbC
	 YMb4C32fVJjL5JoKTacntICUA3bzFielZDcM6VdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/354] ASoC: Intel: catpt: Fix error path in hw_params()
Date: Tue, 16 Dec 2025 12:13:42 +0100
Message-ID: <20251216111330.155573620@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index ff1fa01acb85b..bc49843065c5c 100644
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



