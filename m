Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1073563D4;
	Fri, 24 Apr 2026 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037649; cv=none; b=Ie93A3pnFJHCgSXIg72v4TUHSiQiqAXkfxBbRVA5hiMek1IMeyOLBQ3HUM89AuGdi/Fim+lRFJ8gOGm9z51JdGyluiYzawbqgYdrDVJ2i6p22Q0hm9Tl8nEud4k0JtekrjqXqjI1csqs5ZAakZNnsRJdFoZ3s4JBzrbhKVCZCnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037649; c=relaxed/simple;
	bh=VkFiDOCJ6jhOE8a2UXnLKXyGsWsKzpx9LWyrZ84o4hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jR5wLrHzN1UPReVCWWfuz90o54DyaKsbxitjOQ2yLZGR7hpwYg0XbhN4qC4xaPmIue+zRi/2BMZfWGmuZPJPl/lsnAf6khaCUIuzN2KOEI0stafxMddgWsW/p72x/Upq2mWCHSXS02c/jO8H+gPNGgng0Qe5s7cGjaWzOhP58UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpcvJlBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpcvJlBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32200C19425;
	Fri, 24 Apr 2026 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037649;
	bh=VkFiDOCJ6jhOE8a2UXnLKXyGsWsKzpx9LWyrZ84o4hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpcvJlBfaJ1rOV36v+nusIQt8mDyjLKqDOgj8pq73G51dZYGy1Kitoyjg0hyOmXPG
	 pxYAcQHug5KksXTTbSYx1UxTVg2Ct52sDeTK9CEyx0sTDyBhnC8ibCuvquVXq/lpSZ
	 7KjkRsH0cfckIPL83NRPruSly4DRQXhv7eW0TfIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/166] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Fri, 24 Apr 2026 15:28:42 +0200
Message-ID: <20260424132534.607201426@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 215e5fe75881a7e2425df04aeeed47a903d5cd5d ]

sof_parse_token_sets() accepts array->size values that can be invalid
for a vendor tuple array header. In particular, a zero size does not
advance the parser state and can lead to non-progress parsing on
malformed topology data.

Validate array->size against the minimum header size and reject values
smaller than sizeof(*array) before parsing. This preserves behavior for
valid topologies and hardens malformed-input handling.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260319-sof-topology-array-size-fix-v1-1-f9191b16b1b7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index c18a1fdd40ee3..51a29d2de5ed4 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -722,7 +722,7 @@ static int sof_parse_token_sets(struct snd_soc_component *scomp,
 		asize = le32_to_cpu(array->size);
 
 		/* validate asize */
-		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
+		if (asize < sizeof(*array)) {
 			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
 				asize);
 			return -EINVAL;
-- 
2.53.0



