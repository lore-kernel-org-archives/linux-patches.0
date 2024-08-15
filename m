Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5331A08DD;
	Thu, 15 Aug 2024 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730864; cv=none; b=BZzZgGFE8mPaO8IW4nBo9D2bXI6+r8KjseFROuP5Xpr6pZ4DvEVZPjKUt7b7xdaYq7YdH8WbME1gYsTvdIQl44F0qSR4W9PaNexbcV125HFL83IAd50t52WBBnS0gYvzdbeHinNY50xkudhog7QOEO1AcF/UWPVKDvtDzX2WdMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730864; c=relaxed/simple;
	bh=9L1xsDUHAKiqEV4T+1bCTA7iqDb4iPIW07QPUBK2/Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPNQrN0YIy1+pxY9e2+qhkiqvsLheZq/+9ZJk2ZW1m2oB3PVFyCecpJygr/9/Mbny5t23wAQz5gLFTyMktlqYX5H4w3/3ccyZnRkMkp5L+9hhohx7wRX1RF6mZyMW7M4PY6vcOXKsHOuqvfztGQWEYyBg1eGYzIGhv+QHuoHuFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNPQrEe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNPQrEe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC38EC4AF0A;
	Thu, 15 Aug 2024 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730863;
	bh=9L1xsDUHAKiqEV4T+1bCTA7iqDb4iPIW07QPUBK2/Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNPQrEe0PU2l/38oTz1ZHGNFcWpNc5ZrrwS6FZ6ot9tkcTMBi17WqgmApLcfqs4GE
	 d/fdKmazQZfJewl1KrY8Vvuk9S9wNRjx7oai2EhBpFY79ume8F1ARA8/flKQin7EOA
	 2Z2PgPI5LZFd48Sj54ZX1O6lW7BdVMD+QaYXAEg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 02/67] ASoC: topology: Clean up route loading
Date: Thu, 15 Aug 2024 15:25:16 +0200
Message-ID: <20240815131838.408699797@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

commit e0e7bc2cbee93778c4ad7d9a792d425ffb5af6f7 upstream.

Instead of using very long macro name, assign it to shorter variable
and use it instead. While doing that, we can reduce multiple if checks
using this define to one.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240603102818.36165-5-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-topology.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1021,6 +1021,7 @@ static int soc_tplg_dapm_graph_elems_loa
 	struct snd_soc_tplg_hdr *hdr)
 {
 	struct snd_soc_dapm_context *dapm = &tplg->comp->dapm;
+	const size_t maxlen = SNDRV_CTL_ELEM_ID_NAME_MAXLEN;
 	struct snd_soc_tplg_dapm_graph_elem *elem;
 	struct snd_soc_dapm_route *route;
 	int count, i;
@@ -1044,38 +1045,27 @@ static int soc_tplg_dapm_graph_elems_loa
 		tplg->pos += sizeof(struct snd_soc_tplg_dapm_graph_elem);
 
 		/* validate routes */
-		if (strnlen(elem->source, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) ==
-			    SNDRV_CTL_ELEM_ID_NAME_MAXLEN) {
-			ret = -EINVAL;
-			break;
-		}
-		if (strnlen(elem->sink, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) ==
-			    SNDRV_CTL_ELEM_ID_NAME_MAXLEN) {
-			ret = -EINVAL;
-			break;
-		}
-		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) ==
-			    SNDRV_CTL_ELEM_ID_NAME_MAXLEN) {
+		if ((strnlen(elem->source, maxlen) == maxlen) ||
+		    (strnlen(elem->sink, maxlen) == maxlen) ||
+		    (strnlen(elem->control, maxlen) == maxlen)) {
 			ret = -EINVAL;
 			break;
 		}
 
 		route->source = devm_kmemdup(tplg->dev, elem->source,
-					     min(strlen(elem->source),
-						 SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
+					     min(strlen(elem->source), maxlen),
 					     GFP_KERNEL);
 		route->sink = devm_kmemdup(tplg->dev, elem->sink,
-					   min(strlen(elem->sink), SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
+					   min(strlen(elem->sink), maxlen),
 					   GFP_KERNEL);
 		if (!route->source || !route->sink) {
 			ret = -ENOMEM;
 			break;
 		}
 
-		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) != 0) {
+		if (strnlen(elem->control, maxlen) != 0) {
 			route->control = devm_kmemdup(tplg->dev, elem->control,
-						      min(strlen(elem->control),
-							  SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
+						      min(strlen(elem->control), maxlen),
 						      GFP_KERNEL);
 			if (!route->control) {
 				ret = -ENOMEM;


