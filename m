Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6283A6B7F;
	Thu, 30 Jul 2026 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421747; cv=none; b=IFbALyqVwBFipSYvDCSrnc5s65uW6YeKteCLnnjs4K4aG65JLj7Xzoo1/Hl+ZOjTO3sQvOk+cioRd1tZOZ/hfKgRAIqinsh/utZGL1/MACemSAVmxPrwF6kTtt9WEs4IDMVDALjyCRganxtBu51ILoxbAaObvvfAEIPiYaGA95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421747; c=relaxed/simple;
	bh=iJjZSpE1V+90t/bJ0xtLugcASoMnJl9XBGLziFODjrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbDtpXRvxcz9ZtGU0aFHYYroMjaTCRwmxSzJSa1iScDG8E5RJLl3dtfArfWVXrGOue2YT6HWHNKjqcH5Z8lj5hu9IQVHWQJf3jFeW86NZ3kmnpkWXuxS+pvenTatS8wkPP+daXQWC0zWhhqPmDurnIEzsVo3umkCGilzPCquTCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldN83ySG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldN83ySG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F4B1F000E9;
	Thu, 30 Jul 2026 14:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421745;
	bh=D0/1fwhIDzYQzMawKswArK7QkCAOHXejSZzA5sYXuWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldN83ySGnwPeB5hbnFvf42vxBOJLsLQ13Rc7gHCwdvjjv+ZOkSAjCvDxDmLHYuI8o
	 Fbe2hTuHf7YlPv3yayWsNoITKh85aJWiLgdjdY6pLDHxuW7JSHwY+s13p34LCZhB8L
	 rvKHSaD7V3E03kk1bJoaQq7S9yBz2G+AduNBLvZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 206/744] ASoC: cs35l56: Use complete_all() to signal init_completion
Date: Thu, 30 Jul 2026 16:07:59 +0200
Message-ID: <20260730141448.658657233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit e0bffb63a2eda0af82ed7e6357ac67c2db990c21 ]

In cs35l56_init() use complete_all() to signal init_completion instead
of complete().

cs35l56_init() was signaling init_completion using the complete() function.
This only releases ONE waiter.

If cs35l56_component_probe() was called multiple times the first time
would consume that one signal, then future calls would timeout waiting for
the completion. This could happen if:

 - The component is probed, removed, then probed again without the cs35l56
   module being removed.

 - A call to component_probe() returns an error and ASoC calls it again
   later.

It should use complete_all() so that after it has been signaled it will
allow any code that waits on it to continue immediately.

The one case where the driver must wait for initialization to run again is
when waiting for a reboot after firmware download, and here the code
correctly calls reinit_completion() first.

Fixes: e496112529006 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260716132045.1469156-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 001985e07d57c9..ad0f88cc0fb4b6 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -2089,7 +2089,7 @@ int cs35l56_init(struct cs35l56_private *cs35l56)
 		return dev_err_probe(cs35l56->base.dev, ret, "Failed to write ASP1_CONTROL3\n");
 
 	cs35l56->base.init_done = true;
-	complete(&cs35l56->init_completion);
+	complete_all(&cs35l56->init_completion);
 
 	return 0;
 }
-- 
2.53.0



