Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD68256C88;
	Thu, 17 Apr 2025 18:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914593; cv=none; b=SjSPbxb0p+bPXIpqlJFdcrh4j+A+Oqk6bBMQj47CRGairvDSaEnXDJmhV0hMPx79P2438HRswZOSaTx9MZ8MLqxgHLfjky0nw+wGUXfSNb1+dS3oLr9DHgmxkvnOrth0zeCNcq/gdhGGVX50+tL3SBDcu1jcS6JDP+hfeKOH6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914593; c=relaxed/simple;
	bh=v0MHcwCHlh+tV1cbLIhSH1Z6TkckD7/EOl5CWGqCZXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ1clTTkHPO0YmeMys+a3rPoC9/jmC1kNA8TurLobFEAvOKZj8Q8kzSMGy5Fd6J8SVOlCx4GO47sdr1CFnONhdsQMFV+UOVDd4XKw3GXOs7f1xhoGRMISOfYo1CQj/AJzyZ3pjEgssq22nQMlyfg5kCeuSTW+4socH3p2H/nKVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxffBZRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxffBZRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A0EC4CEE4;
	Thu, 17 Apr 2025 18:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914593;
	bh=v0MHcwCHlh+tV1cbLIhSH1Z6TkckD7/EOl5CWGqCZXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxffBZRBYYc00D5bgx64t1AiYJRxkSREfwRKulBKT2/4EFKJVMLuqRqkplMmayzX4
	 ArX1TnqfH+dYMbtH2Lrrbd8pVBmpExy14yvvA4GKRk4MJNDyxvlVcnT7mvKTDUeB24
	 K69kpt661FstvBvYNd8eB+L2LHBfMQRULkUj3OdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 266/414] ASoC: codecs: wcd937x: fix a potential memory leak in wcd937x_soc_codec_probe()
Date: Thu, 17 Apr 2025 19:50:24 +0200
Message-ID: <20250417175122.130027114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 3e330acf4efd63876d673c046cd073a1d4ed57a8 upstream.

When snd_soc_dapm_new_controls() or snd_soc_dapm_add_routes() fails,
wcd937x_soc_codec_probe() returns without releasing 'wcd937x->clsh_info',
which is allocated by wcd_clsh_ctrl_alloc. Add wcd_clsh_ctrl_free()
to prevent potential memory leak.

Fixes: 313e978df7fc ("ASoC: codecs: wcd937x: add audio routing and Kconfig")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20250226085050.3584898-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd937x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2563,6 +2563,7 @@ static int wcd937x_soc_codec_probe(struc
 						ARRAY_SIZE(wcd9375_dapm_widgets));
 		if (ret < 0) {
 			dev_err(component->dev, "Failed to add snd_ctls\n");
+			wcd_clsh_ctrl_free(wcd937x->clsh_info);
 			return ret;
 		}
 
@@ -2570,6 +2571,7 @@ static int wcd937x_soc_codec_probe(struc
 					      ARRAY_SIZE(wcd9375_audio_map));
 		if (ret < 0) {
 			dev_err(component->dev, "Failed to add routes\n");
+			wcd_clsh_ctrl_free(wcd937x->clsh_info);
 			return ret;
 		}
 	}


