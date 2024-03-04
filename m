Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531B68F58;
	Mon,  4 Mar 2024 21:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588353; cv=none; b=ZcUlESQ4jgL6kEENYXD/Dqecf6Oa2IZiWI0hEJX3KSQ+BF5sTh17gn9mOoDjJtMgvI270beuKblZpDz7gTykNaV/jZJ0r2znOI25a7xVZ6dlpFtkoMEDtaNFSAW2gCoJDzsRIquUfFv8+NwOlsz74f8Z/SSTMHnZ8JbgfTgJ/R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588353; c=relaxed/simple;
	bh=QcdnzBoQGFibhZB2grVH3Hyh4VXo7epcu/sRRC+IaEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mict1BcZ4tq6ccvrCRj5BM15gpNlAwKQVOf/0y8QtJAYsZOH4QYqIlKxixicFPHECbeD1bjMk5e5RYLTeIzuSnk+gRfRWyOW7r6vIjw3f219aOmzfRbrKZi/W5rJEaDFQlEe8GhD1XxyMU6bykPRtoeKg6HYHS2cwPBvGIFQBjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08/nshdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08/nshdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59E3C433C7;
	Mon,  4 Mar 2024 21:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588353;
	bh=QcdnzBoQGFibhZB2grVH3Hyh4VXo7epcu/sRRC+IaEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08/nshdpsOI6xy8hM6fv087lfUUNDKULdchavDWjOWykqgaGw/5SLXlxiYCp9d0jq
	 0viSHQw3kOOGZ0q8af3aCcXPDqfbEpEfsgTuGdyxHms1tevbYPmPHvX4F7gb/MJLWS
	 dnlyKpWp4wx4ymGvjRpMkNT2eFZhmDA8Ru7yahYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/143] ASoC: cs35l56: cs35l56_component_remove() must clear cs35l56->component
Date: Mon,  4 Mar 2024 21:22:50 +0000
Message-ID: <20240304211551.532251973@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ae861c466ee57e15a29d97629e1c564e3f714a4f ]

The cs35l56->component pointer is used by the suspend-resume handling to
know whether the driver is fully instantiated. This is to prevent it
queuing dsp_work which would result in calling wm_adsp when the driver
is not an instantiated ASoC component. So this pointer must be cleared
by cs35l56_component_remove().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Link: https://msgid.link/r/20240129162737.497-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 32d4ab2cd6724..e850f906f1079 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -809,6 +809,8 @@ static void cs35l56_component_remove(struct snd_soc_component *component)
 	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(component);
 
 	cancel_work_sync(&cs35l56->dsp_work);
+
+	cs35l56->component = NULL;
 }
 
 static int cs35l56_set_bias_level(struct snd_soc_component *component,
-- 
2.43.0



