Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB0396565;
	Fri,  7 Aug 2026 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115244; cv=none; b=THUgqTsrnvNosa846mwzjIs1GJqYKs0h8hxNnMWOAwlMlEIqr10C1QblbdwSL+xzOmJMLjMK3Xz52HRS4mbulTrnNKGvm9j0vlJs1FFlZ/5UClZvDJTPE4+Uti/IaUf7BxU32tizVsbZuXXtdrDtH2PQxmp78zHU4IkUQaDRmqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115244; c=relaxed/simple;
	bh=FP7IyckjfFNQ8/nxdnzkpXo/o548vTRuDOyxLUka578=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYPpRM4eqDw/BeLDzpyDGMhmxNlMiiQum4IacDcyV7YJme1/UbMJRmiF7RH5oF5Y8T59pD/485J9Dws5gCW2Pl3k6vTr12OQPJA23Di6ijXBgeSZ+8GYmBlHR1AJLy1cZngKprC7TonJ8v/W699UfQ75b3JkSRQex5nOxWGGT6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNht+UOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNht+UOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0111F000E9;
	Fri,  7 Aug 2026 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115243;
	bh=UUFPKqukLmLy7n3xbBjhMgIlIomDndSX+rWKDYrEdiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNht+UOba90CXVVE+kwsJDVOS06iM8A6IN+uMIYvigy3iG6OfaGL21Y5syj7zxbEH
	 B6W7I675Zv6B3t2Qug74yGE8yY20ZfHwA5P3ieG4EX1alwb2thv0K0rt9KKt2Tao2S
	 6G3CO5+0XiYXhpDz1e//j4FhXMvA66UG/C2dH2u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 208/396] ASoC: fsl_asrc: fix m2m_init error path to use goto instead of bare return
Date: Fri,  7 Aug 2026 16:36:08 +0200
Message-ID: <20260807143428.763102687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 890b4253134f3a39883af7d5bea67af9c494c56d upstream.

When fsl_asrc_m2m_init() fails in fsl_asrc_probe(), the code did a
bare return ret, bypassing pm_runtime_disable() in err_pm_get_sync.
Use goto err_pm_get_sync to ensure proper cleanup on failure.

Fixes: 286d658477a4 ("ASoC: fsl_asrc: register m2m platform device")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260715024758.1252801-2-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_asrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -1388,7 +1388,7 @@ static int fsl_asrc_probe(struct platfor
 	ret = fsl_asrc_m2m_init(asrc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init m2m device %d\n", ret);
-		return ret;
+		goto err_pm_get_sync;
 	}
 
 	return 0;


