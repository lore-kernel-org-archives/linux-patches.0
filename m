Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBC92566DE;
	Thu, 17 Apr 2025 18:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915819; cv=none; b=Ns59ayLtPScQq2JpRfOtgYhB/qB3ebzoaRt2BlSHZNsMMvnc1dqxXb2R3fvAxnHXYU/IgUZrM69889HkTlV4gfqMDcQ4YIYLjs3t4Od0QZd4blPYXTxXww+Q0W0NLZFADUVX9c9dLrBn3tgTZYpkjwuEXWcUPuPXYDMbZU5b1dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915819; c=relaxed/simple;
	bh=EaOFcMxJsmUI+M9OGxZW1osap84Vg8BACBQ32xBhaaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S39S53lZ9uZLX/IOooGhkWSDh7eeabtvdvU7s5aH0ZG7ucH37qf9OTy6gl1shftrsR+yu3MXNyXgLoBoJcEQK1/gY/3/L9AVlWGa0nU9LgGDRbqwkwoTlfZtreeChMutSQVDIgT6Zn/6qFX70vFuIrbRqG3fQkjrSh1c8HsKgk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKLWzt4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKLWzt4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF708C4CEE4;
	Thu, 17 Apr 2025 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915819;
	bh=EaOFcMxJsmUI+M9OGxZW1osap84Vg8BACBQ32xBhaaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKLWzt4GYlnswLLJsYppr+UbhQCXoPNY/nf19X2td3VWa4zTP9KWTHKpYTAEVZ8kc
	 Fxk158G3xi0x095lwhih6y7CxGvKv+www9aHg3XQ4JBN3csKkxJQ0rix0oDl1+Dzgf
	 Ac83oYZIHVUkADQ+LKaHZwAOrzAWWputMYXVI5PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 249/393] ASoC: codecs: wcd937x: fix a potential memory leak in wcd937x_soc_codec_probe()
Date: Thu, 17 Apr 2025 19:50:58 +0200
Message-ID: <20250417175117.606443633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2564,6 +2564,7 @@ static int wcd937x_soc_codec_probe(struc
 						ARRAY_SIZE(wcd9375_dapm_widgets));
 		if (ret < 0) {
 			dev_err(component->dev, "Failed to add snd_ctls\n");
+			wcd_clsh_ctrl_free(wcd937x->clsh_info);
 			return ret;
 		}
 
@@ -2571,6 +2572,7 @@ static int wcd937x_soc_codec_probe(struc
 					      ARRAY_SIZE(wcd9375_audio_map));
 		if (ret < 0) {
 			dev_err(component->dev, "Failed to add routes\n");
+			wcd_clsh_ctrl_free(wcd937x->clsh_info);
 			return ret;
 		}
 	}


