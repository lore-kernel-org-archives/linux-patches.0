Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A303C11193;
	Mon,  4 Mar 2024 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588463; cv=none; b=YE2p01g0ASa2rNqYeeBqc22m9SrpZXvFJGsLc+4/ABVJ2LzVh4e0C8aJfeXyIdBuFKklSUDHfN5cBeio4RLFvaAtwTgLqrL3eitXrnEj4N6AV5Q5zqwLsSDX6CU5NAmSio0nwumsbsTr14Ecqc39/RaB2WfTa3Cwsy/3GsS9UzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588463; c=relaxed/simple;
	bh=lxMQWR3eA7KwruPLKN+2J9+MD3vIRPYPRpwgGQ+8jJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpTG9BX9Am+KOKL49hzRGrhOx9LDUGWxbFyoLXq2dnRFuVbZuzRU3eh8gxei/Ur2gie/1f1BTA5ivJ1l8YpXuE7wXXrH8nYZbdVD8vh3kgpLoXWfjXil8g1WDW73ZgggMDYxRnHxSoPqdxU6lFpje7q5WAkkV/YwlxqHZSoGyko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm3MndlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm3MndlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31600C433F1;
	Mon,  4 Mar 2024 21:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588463;
	bh=lxMQWR3eA7KwruPLKN+2J9+MD3vIRPYPRpwgGQ+8jJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm3MndlZfbIaJGBOIFr2vfYK4jCLFVsiW77Pxjd7n+GWdsX8YeRVML+1iMUlW53oM
	 RkFlOYIHDQdvECJHVSAYpeCJxA3Ht84mS0ln31EqP4jA+5qeUIi4f0AiM8JyX3YN+7
	 3IN4RiN4zN0/fs+7OwDYR7aQyg1vB/712h5pCW78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 117/143] ASoC: cs35l56: fix reversed if statement in cs35l56_dspwait_asp1tx_put()
Date: Mon,  4 Mar 2024 21:23:57 +0000
Message-ID: <20240304211553.656421897@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 4703b014f28bf7a2e56d1da238ee95ef6c5ce76b upstream.

It looks like the "!" character was added accidentally.  The
regmap_update_bits_check() function is normally going to succeed.  This
means the rest of the function is unreachable and we don't handle the
situation where "changed" is true correctly.

Fixes: 07f7d6e7a124 ("ASoC: cs35l56: Fix for initializing ASP1 mixer registers")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/0c254c07-d1c0-4a5c-a22b-7e135cab032c@moroto.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l56.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -175,7 +175,7 @@ static int cs35l56_dspwait_asp1tx_put(st
 
 	ret = regmap_update_bits_check(cs35l56->base.regmap, addr,
 				       CS35L56_ASP_TXn_SRC_MASK, val, &changed);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	if (changed)


