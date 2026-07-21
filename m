Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E56846D54D;
	Tue, 21 Jul 2026 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648686; cv=none; b=QNFzVxubyVKyAxN4TRpaYGGm10w3jIGXP/V7a9uBzRRtEjbmfTK0Ts0GXAH2InHipWsyPqeHmpsX1SZxVN8Pj7ujl1w30/JJDwt7rS3E7WUY0JmklNzrFeX7//ajQswUKafPM7FtBzKMMpw/LLyvMn8x8u7uu/TLo1/e9xsUT6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648686; c=relaxed/simple;
	bh=Y1uX0Kb0/JjCvcZrI6GdQePTCHGm1BLTmwFTnmOKSM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqvXHrrBCzKqtTZuTGdM1iK5SjpR4M/JvFITs1sFdkLAw3Y20gUCF5vQNGRI+YUvtJwI3dzi74dZHztaSzBajnQl/n/Ob0zunmgh8/eLJ+4N6w85X3p9UPw0PONHY73h/JWwt7xlf69etRMZQ2ZvzlaXcqTNCBvNpI7ctrkZUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ro/63H8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ro/63H8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47EA1F00A3A;
	Tue, 21 Jul 2026 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648685;
	bh=ztB08IlgXj0brG8M5PmSjBR5yvJjGJbRErvKIG3oIk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ro/63H8ouN8/+Z0fqVYhk3cjNjrRLSWvAWc4zLkrvzpMfWCrVnjtyfp827apwDy/g
	 66qLC6aBjS00a7h7BSop1mdu3E6j5GM2uBQu0UrZJUD5347cRqJjp2SEh07M/1Z1Jm
	 eSa45BKefJfIZiWCJovhDvpbJ0dCdGTNwdFbNlQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0293/2077] ASoC: dapm: Fix widget lookup with prefixed names across DAPM contexts
Date: Tue, 21 Jul 2026 16:59:26 +0200
Message-ID: <20260721152559.585735532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 8468c8aafe8b5807e5acba2f8aa96d0b3ce0c248 ]

Currently dapm_find_widget() manually constructs a prefixed widget name
based on the provided DAPM context and compares it using strcmp(). This
happens to work in most cases because callers usually know which DAPM
context the target widget belongs to and pass in the matching DAPM
context.

However, this assumption breaks when search_other_contexts is enabled.
In such cases, callers may intentionally pass a different DAPM context,
while searching for a widget that actually belongs to another DAPM
context.

For example, when searching for a "DAC" widget, the widget belongs to
the codec DAPM and be registered with a codec prefix, while the caller
passes card->dapm and intends to search across all DAPM contexts. The
current implementation incorrectly applies the caller card DAPM causing
the lookup to fail even though the widget exists on the card.

Improve the matching strategy to support both use cases:
1. When the caller provides a fully qualified name with prefix, perform
   exact string matching. This preserves the ability to use prefixes for
   disambiguation.
2. When the caller provides a bare widget name without prefix, try exact
   matching first, then fall back to prefix-stripped comparison using
   snd_soc_dapm_widget_name_cmp().

To determine whether the pin name includes a prefix, a new helper
function snd_soc_dapm_pin_has_prefix() is introduced. It checks if the
pin name starts with any known component prefix on the card.

This fixes widget lookup failures when searching across different DAPM
contexts while maintaining backward compatibility for explicitly
prefixed lookups.

Fixes: ae4fc532244b ("ASoC: dapm: use component prefix when checking widget names")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Assisted-by: Cody:Claude-4.5-Sonnet
Link: https://patch.msgid.link/20260507013654.2945915-2-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dapm.h |  1 +
 sound/soc/soc-dapm.c     | 49 ++++++++++++++++++++++++++++++----------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 4f8fb7622a139d..c1e4f467efda73 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -685,6 +685,7 @@ int snd_soc_dapm_sync_unlocked(struct snd_soc_dapm_context *dapm);
 int snd_soc_dapm_force_enable_pin(struct snd_soc_dapm_context *dapm, const char *pin);
 int snd_soc_dapm_force_enable_pin_unlocked(struct snd_soc_dapm_context *dapm, const char *pin);
 int snd_soc_dapm_ignore_suspend(struct snd_soc_dapm_context *dapm, const char *pin);
+bool snd_soc_dapm_pin_has_prefix(struct snd_soc_card *card, const char *pin);
 void snd_soc_dapm_mark_endpoints_dirty(struct snd_soc_card *card);
 
 /* dapm path query */
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index d6192204e613da..a26771c8e6ee69 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2906,20 +2906,18 @@ static struct snd_soc_dapm_widget *dapm_find_widget(
 {
 	struct snd_soc_dapm_widget *w;
 	struct snd_soc_dapm_widget *fallback = NULL;
-	char prefixed_pin[80];
-	const char *pin_name;
-	const char *prefix = dapm_prefix(dapm);
-
-	if (prefix) {
-		snprintf(prefixed_pin, sizeof(prefixed_pin), "%s %s",
-			 prefix, pin);
-		pin_name = prefixed_pin;
-	} else {
-		pin_name = pin;
-	}
+	bool pin_has_prefix = snd_soc_dapm_pin_has_prefix(dapm->card, pin);
+	bool match;
 
 	for_each_card_widgets(dapm->card, w) {
-		if (!strcmp(w->name, pin_name)) {
+		match = false;
+
+		if (!strcmp(pin, w->name))
+			match = true;
+		else if (!pin_has_prefix && !snd_soc_dapm_widget_name_cmp(w, pin))
+			match = true;
+
+		if (match) {
 			if (w->dapm == dapm)
 				return w;
 			else
@@ -4872,6 +4870,33 @@ int snd_soc_dapm_ignore_suspend(struct snd_soc_dapm_context *dapm,
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_ignore_suspend);
 
+/**
+ * snd_soc_dapm_pin_has_prefix - check if given pin has a known prefix
+ * @card: card to be checked
+ * @pin: pin name
+ *
+ * Returns true if given pin has a known prefix
+ */
+bool snd_soc_dapm_pin_has_prefix(struct snd_soc_card *card, const char *pin)
+{
+	struct snd_soc_component *component;
+	const char *prefix;
+	size_t prefix_len;
+
+	for_each_card_components(card, component) {
+		prefix = component->name_prefix;
+		if (!prefix)
+			continue;
+
+		prefix_len = strlen(prefix);
+		if (!strncmp(pin, prefix, prefix_len) && pin[prefix_len] == ' ')
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_pin_has_prefix);
+
 /**
  * snd_soc_dapm_free - free dapm resources
  * @dapm: DAPM context
-- 
2.53.0



