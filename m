Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C14339387;
	Fri,  7 Aug 2026 15:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116724; cv=none; b=IaJGEGlBze5xuvttpteIG4VtDSFZk9sYJtq2OZgPDH+1b5d/QkgFvYvH/ejPPzA4unwWao5mddMZu+4++06kSvNdZ0rmoEHuVCghXmTdieHpByR6IwbE4l9K5u8PeSakp+C/JZcVvPBR95jwkfSp0abNW64T+Wq/UEsBju14smI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116724; c=relaxed/simple;
	bh=VSmnF6tA2k+Tpv/Du1r6CvU3oeuhXpk567UDUpZagkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaG27aLhtpQjhCFE/1o+HAiptK/roapQ8tkyIrbf08PG0VFWDnC4zQm768lNdqIU1dTkgBD9+ntjUSc6CmJ/uboejJ9T5yY5FOyrS6DhRjaRNrLye5LfygSDmq3j2GwBP+qz6WUo/EnQGzDSsTu8dgaH3gen8m+7UUxkp3+wGi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKzLg7Q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKzLg7Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4073D1F000E9;
	Fri,  7 Aug 2026 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116722;
	bh=ZgkYE0lgtdsVy97fJNrLj8HVZ3i3xerXcxELRxP8rf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKzLg7Q7ELfYf2DNsaqg+gOmn0+MPhW1sO2hVFeBSMRLw28I6nyZ0hMu73tsLjMrv
	 4jkuOt1Fs7fopzxbZYDC7I4o/CAsXHtnLWxZ883rxIYVgtA15F+J78rkhg2xVMCg9c
	 1dVT2rE1YdTy6lV3c8yGfTm8VuQ/7lanrPby25YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 023/438] ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup
Date: Fri,  7 Aug 2026 16:33:39 +0200
Message-ID: <20260807143428.503776385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit a792ce0fad61a70793ec565743f11d6ca534de59 ]

In max98090_probe(), the -EPROBE_DEFER check after devm_clk_get() is
broken due to a missing IS_ERR() guard.

The code intends to return -EPROBE_DEFER only when the clock lookup
fails with that specific error.  However, without IS_ERR() the check:

    if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)

is called unconditionally, including when devm_clk_get() succeeds and
returns a valid pointer.  Calling PTR_ERR() on a valid pointer
reinterprets its address as a signed long; the result is arbitrary
and is almost never equal to -EPROBE_DEFER, so the check silently
does nothing in the success case.  When devm_clk_get() fails with
any error other than -EPROBE_DEFER the check is also skipped, leaving
max98090->mclk holding an error pointer with no indication to the caller.

This means a deferred probe will never actually be triggered for this
device, and any non-EPROBE_DEFER clock error is silently swallowed with
the error pointer left in the mclk field.

Fix this by adding the missing IS_ERR() guard around the PTR_ERR() call,
matching the pattern already used in the sibling max98088 and wm8960
drivers.

Fixes: b10ab7b838bd ("ASoC: max98090: Add master clock handling")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260720104254.14948-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 13a15459040fc..595efd84b62b3 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2424,8 +2424,9 @@ static int max98090_probe(struct snd_soc_component *component)
 	dev_dbg(component->dev, "max98090_probe\n");
 
 	max98090->mclk = devm_clk_get(component->dev, "mclk");
-	if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (IS_ERR(max98090->mclk))
+		if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 
 	max98090->component = component;
 
-- 
2.53.0



