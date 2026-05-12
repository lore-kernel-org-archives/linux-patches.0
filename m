Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43243EDE41;
	Tue, 12 May 2026 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608600; cv=none; b=m32tU6SElMliEwMpuYmR03Hjkwfjkwps6jR/FKAFI9J0GhjXpLYGiP+9M8vSrJ1MYsk5QanpFFZytWdQebYSAXWPkax2rmJALYU5Hq2VZBGof6JK6KeScvu6wERiZxvKj6IEvaQwtMUvZ1IQlzdeFMtnsZP4EhPeg4xnSH8RlHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608600; c=relaxed/simple;
	bh=qcH6nmXS8EEy+E44lmVRQji33Hndw2AAY5ZU9qx8+DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y65kiPHlyfFXxYxZtHLRVDwXrku9gzT8CvTi92T8R+zoSm4D0zHA+QACYfF32Wb+ToEEzOj2J2sWjA2xcWq/C31jJVAXQKKDWMFQvYYzEKb/W2Gf6gYMFQPUJTALt8Me/vjuJwNMnwqvMTiPbR/azs/hBXX91GK/Q+jPXkuWHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCkG8PSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCkG8PSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30791C2BCC7;
	Tue, 12 May 2026 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608600;
	bh=qcH6nmXS8EEy+E44lmVRQji33Hndw2AAY5ZU9qx8+DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCkG8PSc8VcjWdadol5mBYaWladzS7MwDahtEF/MDMYJ7cWq7FWhP8iSp+jfG4CNv
	 dBOE5TSxVhKsxI4OVuotNoTz/5qEOtak4SbthgX2Rh3UQqGKb+0f4zggUuvT8a+mNn
	 KlugIY0P20HWDSl5TjKyYKQru754hHl+L2qvmLJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jian <lazycat-xiao@foxmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 142/270] ASoC: ES8389: convert to devm_clk_get_optional() to get clock
Date: Tue, 12 May 2026 19:39:03 +0200
Message-ID: <20260512173941.440081529@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Li Jian <lazycat-xiao@foxmail.com>

commit 8ed3311131077712cdd0b3afec6909b9388ad3e4 upstream.

When enabling ES8390 via ACPI description, es8389 would fail to
obtain a clock source, causing the driver to fail to initialize.
This was not an issue with older kernels, but since commit
abae8e57e49a ("clk: generalize devm_clk_get() a bit"),
devm_clk_get() would return an error pointer when a clock source
was not detected (instead of falling back to a static clock),
causing the driver to fail early.

Use devm_clk_get_optional() instead to return to the previous
behaviour, allowing the use of a static clock source.

Cc: stable@vger.kernel.org
Signed-off-by: Li Jian <lazycat-xiao@foxmail.com>
Link: https://patch.msgid.link/tencent_7C78374FB9F4B3A37101E5C719715D8BC40A@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/es8389.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/es8389.c
+++ b/sound/soc/codecs/es8389.c
@@ -827,7 +827,7 @@ static int es8389_probe(struct snd_soc_c
 		es8389->mclk_src = ES8389_MCLK_SOURCE;
 	}
 
-	es8389->mclk = devm_clk_get(component->dev, "mclk");
+	es8389->mclk = devm_clk_get_optional(component->dev, "mclk");
 	if (IS_ERR(es8389->mclk))
 		return dev_err_probe(component->dev, PTR_ERR(es8389->mclk),
 			"ES8389 is unable to get mclk\n");


