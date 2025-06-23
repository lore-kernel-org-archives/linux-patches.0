Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E9625334B;
	Mon, 23 Jun 2025 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685870; cv=none; b=FJ2p7KqsGo7raTgTzo6jG0ZzqVFTgDGcjtDzfmLYRF970YShdJSknFj0I7RHefUe8c0mX5b7iOAb7pozdZlmlWAjnUiANoemzeQe6y8IXuCSpBS1lVjv4RK8xTWSa82+gTHAdjGeRp615hDOKhEz0nHWLYqmRWg53t/e500OZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685870; c=relaxed/simple;
	bh=tjRpYGGlByNtz4OPfINBltHbscSTGG/Uzgmy3T7xjbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGUZrX/7aAtW3VE1Us88atb3NPAKVcvGzecKAQj6PXhO+0kJl3nH0JO7lvaDY3jLM0V4rP2hojXZZywd76vn01cCniyo6mdgcb+B3a++nu7rehPin7HwlqY1bUO4slgtCP8FnV9UdZcXafeu0StMcCjmLvO9BwQm/Y/GQKRLiYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZB4ZgxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZB4ZgxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAF0C4CEEA;
	Mon, 23 Jun 2025 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685870;
	bh=tjRpYGGlByNtz4OPfINBltHbscSTGG/Uzgmy3T7xjbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZB4ZgxYeWuaEgiwuq7tSNZ+96Md0HOB4hZuEV/UheATXEXWSRb96z04rt3sJ9Eb+
	 PNz5EYGtZ9ttFzozhKaFWlSlFFNYrZzaqIVwpdatC/E9X9N1lbs3TgFHGhCiRP/fK+
	 E/8/gwSu5RANGY3d9lMI0O9P4Z0xfVaes72icnWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 011/414] ASoC: amd: sof_amd_sdw: Fix unlikely uninitialized variable use in create_sdw_dailinks()
Date: Mon, 23 Jun 2025 15:02:28 +0200
Message-ID: <20250623130642.309835484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
@@ -267,7 +267,7 @@ static int create_sdw_dailinks(struct sn
 
 	/* generate DAI links by each sdw link */
 	while (sof_dais->initialised) {
-		int current_be_id;
+		int current_be_id = 0;
 
 		ret = create_sdw_dailink(card, sof_dais, dai_links,
 					 &current_be_id, codec_conf);


