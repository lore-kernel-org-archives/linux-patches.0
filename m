Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76149251793;
	Mon, 23 Jun 2025 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684297; cv=none; b=UWbdlM6teljhPkGJABpWXs02gndC2qr+RnDqfFX2gWYA7qJNo79QhXcOxwUFvXj8a69EDeaCUNA/J7nFrrIfrrzRgC0ENEWnsYU7GsvyQjG4+/q7ibibk4BPlgv/jXWtoku+8NuxFkAHed82rhpbjf2fc/Z+HsM5qrfF+ldBjT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684297; c=relaxed/simple;
	bh=pbNOVxkZJbdHqNLZ2/6K+3HGBRL+DKrb7D3Hzg69bNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF3hguwmwACDb2lgJQ8X6BjjjpJT5QCT1Qc+gEYSpyOCL4IaSfJTqzm3pq9luhU6YGxYhT8KJQ/Cmf8JADh6w0o63bTfv3N3rKCPxSTiXZfqELDugTQ9EuZ0/h6G0EjfeS7Wiij1hxWafpnwqUWBhZobPmmUnFG1lRDUfaZec2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATHaNZuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATHaNZuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B044C4CEEA;
	Mon, 23 Jun 2025 13:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684297;
	bh=pbNOVxkZJbdHqNLZ2/6K+3HGBRL+DKrb7D3Hzg69bNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATHaNZuOj1o2FNTdJc/ADO8Ucca124qAoUQYomBjymjLhhyZBHgRtpr4yeUukrzgB
	 bUw9mZuaQP51eVpT5uEerAtD3G4+hKwT/NtdWk2peapysT/Va5ZxZkOShGfRCIoxdC
	 8q1ipmC+oMSmITT9kowJUJB6BS2NqVPCvjvaOxzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 015/592] ASoC: amd: amd_sdw: Fix unlikely uninitialized variable use in create_sdw_dailinks()
Date: Mon, 23 Jun 2025 14:59:33 +0200
Message-ID: <20250623130700.587345619@linuxfoundation.org>
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

commit 4d87ae7508cb7ff58fd0bcecc6e9491f42f987f8 upstream.

Initialize current_be_id to 0 in AMD legacy stack(NO DSP enabled) SoundWire
generic machine driver code to handle the unlikely case when there are no
devices connected to a DAI.

In this case create_sdw_dailink() would return without touching the passed
pointer to current_be_id.

Found by gcc -fanalyzer

Cc: stable@vger.kernel.org
Fixes: 2981d9b0789c4 ("ASoC: amd: acp: add soundwire machine driver for legacy stack")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20250506120823.3621604-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -272,7 +272,7 @@ static int create_sdw_dailinks(struct sn
 
 	/* generate DAI links by each sdw link */
 	while (soc_dais->initialised) {
-		int current_be_id;
+		int current_be_id = 0;
 
 		ret = create_sdw_dailink(card, soc_dais, dai_links,
 					 &current_be_id, codec_conf, sdw_platform_component);


