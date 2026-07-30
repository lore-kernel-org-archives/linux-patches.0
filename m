Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ADC3750CF;
	Thu, 30 Jul 2026 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423868; cv=none; b=MUxuZmqREnZD/AaDd5+9h5H9XdKHwtlBNxWeOz8RWevTwq3d0BlzylJYjFaEIqg/GCKbO8avcS3MN2NjRVdLUvjzKVNGmMI1FuetsuJnYEi89KsQafZMULTQOW1BwLfJY/xJSoLVW5fq0lcGTLgsl7w3SsyzIvjd2mNdh9m+99k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423868; c=relaxed/simple;
	bh=txvGqEWOOktwuF46NBdFUb1q+HJqnFl1+zo3XnQEE74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JP09pa76VivcfFq5Cm/DmqJ0sIcpdWD6LrGk5MrXEuL0Buex4YJ36RZoZlfqg0V7AowPlEv61s3izwLJH2ZKRQe9k/aIIuyTKYciz8Al66Ku4nHXEINWJrlp5LzlUb0Vq+ypCnZe1oLrjiINsZ9Tj7lnLN49xMhJXJ6K9m0m76A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxQyUBId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxQyUBId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F211F000E9;
	Thu, 30 Jul 2026 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423867;
	bh=7wufyWZnLmCL8xUDLWrKFsInDyaduxceBOfz8Kvq7n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxQyUBId5/gKWPI+eX6R1Che08wkhs9q7zqgddBZRkA0ALRlMz7ds3fNZYZnhNZrw
	 mPUVjrJ+Qi7bNSgxbqteD57tdHoH8qgZzAbEExq9DtNXYFtGAHY16DdmxTb09phbXN
	 XX/MWwmN33LZ6Ll5fv70ZIPSwdCJix4Entkxfk1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/675] ASoC: cs35l56: Use complete_all() to signal init_completion
Date: Thu, 30 Jul 2026 16:08:44 +0200
Message-ID: <20260730141449.267053662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index f8468b3ae593a1..e3334b2d845323 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1548,7 +1548,7 @@ int cs35l56_init(struct cs35l56_private *cs35l56)
 		return dev_err_probe(cs35l56->base.dev, ret, "Failed to write ASP1_CONTROL3\n");
 
 	cs35l56->base.init_done = true;
-	complete(&cs35l56->init_completion);
+	complete_all(&cs35l56->init_completion);
 
 	return 0;
 }
-- 
2.53.0



