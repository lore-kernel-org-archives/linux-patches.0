Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F37212F00;
	Tue, 12 Nov 2024 10:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408134; cv=none; b=s4XX6RStpadH3xdaPKQlWTOj9R4IGIH74rjZVnsvz8PxHM/jVTdrIDxHA+eKraaP+4uqrEZh5aIeEAuar37imd08uVsb2ZYgnWwN7lPbUy9iEgLo2J4xrR0gFF5+SZPAv79ImFMG9lEEfB56A27ql1ECZmE44Fz2ScPw3ZMo/0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408134; c=relaxed/simple;
	bh=TVai+8R/iYsF4KSHlDl2ZOkWjXBRKMGN0LwdPkvnRAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChGYw3qqXexU9jgSSAYUpg56OGhKVHsJ4qUoO9ij3fkVHYrwR5kzaAeMCtR/OZ3NEd8ZlwDlWpQ6bySo2JWxOZiZmc9NuaDTrcdBHyQ0PzqUWm39CwmlSqHCgKKj9ZPEMFJKQyuj7XOgdxx/okCeBSWiYY0V0xsLGKFaHznfOBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCxqhpeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCxqhpeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF4BC4CECD;
	Tue, 12 Nov 2024 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408134;
	bh=TVai+8R/iYsF4KSHlDl2ZOkWjXBRKMGN0LwdPkvnRAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCxqhpeE4M6iNi7a3lj37ZxBGbgcTdmxFtFUaWA0SvUUnOZ2M9jTVsPXqOhfGZyeX
	 cePlw6yTHxE5/MGvdCs6T3C/cTyw8aPEAkgdrNSUcA0nhhlySvC8IivLA/pnGc9eW+
	 VNFzRul2d3N95lDBEXTyQNwmqTrlntJlPbOpAI40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Dahl Juhl <emdj@bang-olufsen.dk>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 071/184] tools/lib/thermal: Fix sampling handler context ptr
Date: Tue, 12 Nov 2024 11:20:29 +0100
Message-ID: <20241112101903.590139319@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Dahl Juhl <emdj@bang-olufsen.dk>

[ Upstream commit fcd54cf480c87b96313a97dbf898c644b7bb3a2e ]

The sampling handler, provided by the user alongside a void* context,
was invoked with an internal structure instead of the user context.

Correct the invocation of the sampling handler to pass the user context
pointer instead.

Note that the approach taken is similar to that in events.c, and will
reduce the chances of this mistake happening if additional sampling
callbacks are added.

Fixes: 47c4b0de080a ("tools/lib/thermal: Add a thermal library")
Signed-off-by: Emil Dahl Juhl <emdj@bang-olufsen.dk>
Link: https://lore.kernel.org/r/20241015171826.170154-1-emdj@bang-olufsen.dk
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/sampling.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/thermal/sampling.c b/tools/lib/thermal/sampling.c
index 70577423a9f0c..f67c1f9ea1d78 100644
--- a/tools/lib/thermal/sampling.c
+++ b/tools/lib/thermal/sampling.c
@@ -16,6 +16,8 @@ static int handle_thermal_sample(struct nl_msg *n, void *arg)
 	struct thermal_handler_param *thp = arg;
 	struct thermal_handler *th = thp->th;
 
+	arg = thp->arg;
+
 	genlmsg_parse(nlh, 0, attrs, THERMAL_GENL_ATTR_MAX, NULL);
 
 	switch (genlhdr->cmd) {
-- 
2.43.0



