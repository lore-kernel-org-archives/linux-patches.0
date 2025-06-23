Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153A0233D8E;
	Mon, 23 Jun 2025 13:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684300; cv=none; b=pqGfBSFmYdRQ3nx8Kfuc0VGCgwofQttd4cmP3TVyYsYYa4e4Ur6hTqFjQ8fO9fc0mSG53ACngpDuKElVyYFGhlOymPlzRbU9vSklaLTF8apy3uR6LiZK3F5VnK4m8IIDpFUAtiRGlWr7oYhhW6sc2kTWf+Em4zV+IBcgu4FiFc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684300; c=relaxed/simple;
	bh=QtMHegsboKGGL++XH8NPI/Fy25JC4a6ReWVv1EbZ3wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9HMpEMf4cXDt2lTLy0SPChJv9ipnhwgQCwKJoBOtjhVuK5vRA7Jh33vcmD5aVGVBStVhzGjAHo2cR3dcVt4z6HYUCifg1QIFqni8cwbFJNjmksZ+bHnkDJIja2iMs4EigC498DXwrYJsnQwhYwVpx+HOzY+PZ5myw97m717lnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9Nb7Z/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9Nb7Z/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87247C4CEEA;
	Mon, 23 Jun 2025 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684299;
	bh=QtMHegsboKGGL++XH8NPI/Fy25JC4a6ReWVv1EbZ3wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9Nb7Z/JLKkyKbbBaRaq7R/N5pHWgMQ+AKUZHXvx0WuOHgAN4nCyYwJVc7M6fD3K9
	 9/dWYA/K+OcN3eKtj/uzU4Q/n/3dgKyENKYxIXCUOB1MqIvYNXsKmV9iucV/jtFpJl
	 YxFOfmXj2R5eiXKToMJ090TGPFvy4nwdt4XQA4js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 016/592] ASoC: amd: sof_amd_sdw: Fix unlikely uninitialized variable use in create_sdw_dailinks()
Date: Mon, 23 Jun 2025 14:59:34 +0200
Message-ID: <20250623130700.610085800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

commit 6b83ba4bc3ecb915476d688c9f00f3be57b49a0c upstream.

Initialize current_be_id to 0 in SOF based AMD generic SoundWire machine
driver to handle the unlikely case when there are no devices connected to
a DAI.
In this case create_sdw_dailink() would return without touching the passed
pointer to current_be_id.

Found by gcc -fanalyzer

Cc: stable@vger.kernel.org
Fixes: 6d8348ddc56ed ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20250506120823.3621604-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -219,7 +219,7 @@ static int create_sdw_dailinks(struct sn
 
 	/* generate DAI links by each sdw link */
 	while (sof_dais->initialised) {
-		int current_be_id;
+		int current_be_id = 0;
 
 		ret = create_sdw_dailink(card, sof_dais, dai_links,
 					 &current_be_id, codec_conf);


