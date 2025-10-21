Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB12797B5;
	Tue, 21 Oct 2025 20:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077529; cv=none; b=JtvMHD1bJK81mDOjcYI3IEMF6p8WCSGG8fGYQn6wSryqPXk4r1bSE1xA1hlK893KDYg1Jqy+ybD56BR1gLaIi6sXzLozuiS14pzmiDFjkl0WnT/+OfiLsZvAJNpNwAfbye3J2E6OgXvbI6hKuTy/2olTC1imF/x9vHWAb5Z8qmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077529; c=relaxed/simple;
	bh=SW2plMvQUerm5wL4tJFZ38P1Xuh4aF6Uut1g0C8XTT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHdzRoG4arqFo2oXzCYKEFBM6qq5qtHbG3abT4MEOkXoU+jJArljv1EKofCnAofvTFox+SIZPU+g9v+RbiOCpxa+3r1UaQN+RseaTycOvzYEZlzunISaUVZ/Ra/szYqbY6SVLTuIQ81M5QtHsMsepjo+aAnW4iJDzV1IqxKIVr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Rk8TWnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Rk8TWnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3534C4CEF1;
	Tue, 21 Oct 2025 20:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077529;
	bh=SW2plMvQUerm5wL4tJFZ38P1Xuh4aF6Uut1g0C8XTT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Rk8TWnr5fI+PW7IB1tJZL1XSTdcJE8LxECnDQckmVyW9Jdg+NefojujwKBKfKQvu
	 Vz3mi26umxAqi0ogvWDMhCsmBuV5aQUBROS27kP1Jk2dq5Efhcp3fTITmiFGwnShMc
	 rAPfJPBybaZMZbgeyYGlS1hQawnare8VlPa5bb8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/159] ASoC: amd/sdw_utils: avoid NULL deref when devm_kasprintf() fails
Date: Tue, 21 Oct 2025 21:51:49 +0200
Message-ID: <20251021195046.324082972@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 5726b68473f7153a7f6294185e5998b7e2a230a2 ]

devm_kasprintf() may return NULL on memory allocation failure,
but the debug message prints cpus->dai_name before checking it.
Move the dev_dbg() call after the NULL check to prevent potential
NULL pointer dereference.

Fixes: cb8ea62e64020 ("ASoC: amd/sdw_utils: add sof based soundwire generic machine driver")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Link: https://patch.msgid.link/20251015075530.146851-1-liqiang01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 91d72d4bb9a26..d055582a3bf1a 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -176,9 +176,9 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			cpus->dai_name = devm_kasprintf(dev, GFP_KERNEL,
 							"SDW%d Pin%d",
 							link_num, cpu_pin_id);
-			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 			if (!cpus->dai_name)
 				return -ENOMEM;
+			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 
 			codec_maps[j].cpu = 0;
 			codec_maps[j].codec = j;
-- 
2.51.0



