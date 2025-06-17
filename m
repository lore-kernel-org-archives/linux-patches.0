Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51111E98E3;
	Tue, 17 Jun 2025 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177835; cv=none; b=CNWZQy1TdqTPNlyScrDq8WtnPUQoNXtGRqBIgigRs6NzXArN89CMsXlRUN0havEKff87qMazwnxSHMWg6Tqz/RK+5Y7mIT2MMBI/GGT1sTpuaTlPa4yaEJO+tiz47a+flOs9LpzNt+jiNg4pr/gGbRU9cA9lUdmEp7EJP+48uXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177835; c=relaxed/simple;
	bh=GMOw/QOm6tg6VFrmGzNpgoF6Da9UiwzZCMliGbmNiRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQzl44ch73Zzhv86RPgd9GqmEaDWm8lrX6zenrSdmyOqmm021o+vDKUUzMdTCph9xZeYog41QBkrPe3TkfHB8JPs9x5RdBDtjulwxa0qo5vDBeUqbmXrBfLKn/iMuIbQZfSc/bT+wPIY6v2J996ENpZyEg5j09qWdPkDiK7ZRW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLCAIauw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLCAIauw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14415C4CEE3;
	Tue, 17 Jun 2025 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177835;
	bh=GMOw/QOm6tg6VFrmGzNpgoF6Da9UiwzZCMliGbmNiRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLCAIauwIzLrnPtzhCXgnBFfd+xTTlP/ICmr8ryczmdnTKh3Zt86XsCDZmcSKzJfE
	 ytO/AvLiFZHBHaYuZOCii74mg9GgcnmXkuoKH9vhJdxe8ggmJrl2RksqryoB1h/fSj
	 GKLjWnuD50qg6QUFaCubGFHjR2JbzxN5LhJuV5+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 390/512] ASoC: Intel: avs: Verify content returned by parse_int_array()
Date: Tue, 17 Jun 2025 17:25:56 +0200
Message-ID: <20250617152435.384707431@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 93e246b6769bdacb09cfff4ea0f00fe5ab4f0d7a ]

The first element of the returned array stores its length. If it is 0,
any manipulation beyond the element at index 0 ends with null-ptr-deref.

Fixes: 5a565ba23abe ("ASoC: Intel: avs: Probing and firmware tracing over debugfs")
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-8-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/debugfs.c b/sound/soc/intel/avs/debugfs.c
index 1767ded4d9830..c9978fb9c74e2 100644
--- a/sound/soc/intel/avs/debugfs.c
+++ b/sound/soc/intel/avs/debugfs.c
@@ -372,7 +372,10 @@ static ssize_t trace_control_write(struct file *file, const char __user *from, s
 		return ret;
 
 	num_elems = *array;
-	resource_mask = array[1];
+	if (!num_elems) {
+		ret = -EINVAL;
+		goto free_array;
+	}
 
 	/*
 	 * Disable if just resource mask is provided - no log priority flags.
@@ -380,6 +383,7 @@ static ssize_t trace_control_write(struct file *file, const char __user *from, s
 	 * Enable input format:   mask, prio1, .., prioN
 	 * Where 'N' equals number of bits set in the 'mask'.
 	 */
+	resource_mask = array[1];
 	if (num_elems == 1) {
 		ret = disable_logs(adev, resource_mask);
 	} else {
-- 
2.39.5



