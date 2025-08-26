Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6C8221290;
	Tue, 26 Aug 2025 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215655; cv=none; b=D08nbOKjd6vbSOOSQj6MSsYZXra095+b/EMZoa3GdTU9i4XqN4yiQEBCtX4tfRHGA2E93eULQlversqdKDwCoTYr/5oZsNSJ8gpIGnMYQr4G55C57pgr9Ml5023flQmKIEkiilQiNoE74NZdp/LBAsFP6VOzV5i1+1VudyKfnLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215655; c=relaxed/simple;
	bh=28DhgTSq6/vnU/1cOwTvRZahJDKwkdMTsP9jnU9uvPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXdwIZJs9Qg7+UxttN+2F1FSZ/Hklk36/xcgxSNEC9vepLHX0PAXIxtK7zogWcGXsbRUCWQGJakNlD6lQjIGVC6pn194OXFVBHYIVT57szgwQBW43sm7r9VneA2XuXJW0Qanp8qKf8BKzpZO+8oDQLWQ/rjgEY298tHOgiSSogc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxWT6Ttd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxWT6Ttd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232B7C4CEF1;
	Tue, 26 Aug 2025 13:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215655;
	bh=28DhgTSq6/vnU/1cOwTvRZahJDKwkdMTsP9jnU9uvPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxWT6TtdnpKItQlibejSTcgQStdg9eFRnFNanSZNMApzN+amG+UhAC+Y01gBDIcvX
	 Qw9LAIz3MiMKUGGdOE4f2vjxcnFEanFH2fxprEHZm2NvOg+/VSk4OA06hvca3xywh7
	 5gaNi5Xcdjxf8YS60cfhYcISs6jiFOhH7xMKYguU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/644] ASoC: ops: dynamically allocate struct snd_ctl_elem_value
Date: Tue, 26 Aug 2025 13:03:26 +0200
Message-ID: <20250826110949.377025631@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7e10d7242ea8a5947878880b912ffa5806520705 ]

This structure is really too larget to be allocated on the stack:

sound/soc/soc-ops.c:435:5: error: stack frame size (1296) exceeds limit (1280) in 'snd_soc_limit_volume' [-Werror,-Wframe-larger-than]

Change the function to dynamically allocate it instead.

There is probably a better way to do it since only two integer fields
inside of that structure are actually used, but this is the simplest
rework for the moment.

Fixes: 783db6851c18 ("ASoC: ops: Enforce platform maximum on initial value")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250610093057.2643233-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 9eb4181c6697..7cb3a3f9d3ae 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -624,28 +624,32 @@ EXPORT_SYMBOL_GPL(snd_soc_get_volsw_range);
 static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 {
 	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-	struct snd_ctl_elem_value uctl;
+	struct snd_ctl_elem_value *uctl;
 	int ret;
 
 	if (!mc->platform_max)
 		return 0;
 
-	ret = kctl->get(kctl, &uctl);
+	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+	if (!uctl)
+		return -ENOMEM;
+
+	ret = kctl->get(kctl, uctl);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	if (uctl.value.integer.value[0] > mc->platform_max)
-		uctl.value.integer.value[0] = mc->platform_max;
+	if (uctl->value.integer.value[0] > mc->platform_max)
+		uctl->value.integer.value[0] = mc->platform_max;
 
 	if (snd_soc_volsw_is_stereo(mc) &&
-	    uctl.value.integer.value[1] > mc->platform_max)
-		uctl.value.integer.value[1] = mc->platform_max;
+	    uctl->value.integer.value[1] > mc->platform_max)
+		uctl->value.integer.value[1] = mc->platform_max;
 
-	ret = kctl->put(kctl, &uctl);
-	if (ret < 0)
-		return ret;
+	ret = kctl->put(kctl, uctl);
 
-	return 0;
+out:
+	kfree(uctl);
+	return ret;
 }
 
 /**
-- 
2.39.5



