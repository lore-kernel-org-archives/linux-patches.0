Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F336218D649;
	Mon, 28 Oct 2024 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098487; cv=none; b=C5rx2UMYsJiM8hWbZxidwl5rHuZPxYFffEVPDCAzQ9lLwrxUG6NBpmya4f1KeBs5jGu4SU/+6hPet5VYBEek+AdsDnqpdnkRaqxsvqL8PxjcC2GtY4wHoCPStEUG4tzrfUx3XzfxV8Ahn5wqVtmENmgN4WRt/pK/EWjH/krNd4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098487; c=relaxed/simple;
	bh=9WnbuzT9v4C17cD7vhX8L8vtyu1Yqyprmc30sXyevmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyYc+/uxEmK9c/iOkKBGUrufuZf4jJDx07KJsRe4eO0sSGO4SGftN+vrE/XL9/qBizabeuLYGwVskllJD0C0EjgUdkeIlvMC4ISdid8oY9zsOME35RmgCHQHawsTpUFc4Xc/jO9xyGeFy3YiVfEunoGKtfHI+iinR6ProP9sqYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKeq6BHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKeq6BHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93685C4CEC3;
	Mon, 28 Oct 2024 06:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098486;
	bh=9WnbuzT9v4C17cD7vhX8L8vtyu1Yqyprmc30sXyevmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKeq6BHRXMgrsF+2OoP4KFL/MPjQj+rfQVKMUpzLimdHzwTl1MYIYqFPyNS8qtCzN
	 n+h8n080gkMAgg4N6K4syZwBZh0F93rmVpCoerA5eTAVPGrA6+ATTcfksOHQGSHQX/
	 Ep1aOcuTsJtt11a6QXUp5XHn5Q1TlYTU3qq4uCmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Bara <benjamin.bara@skidata.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 247/261] ASoC: dapm: avoid container_of() to get component
Date: Mon, 28 Oct 2024 07:26:29 +0100
Message-ID: <20241028062318.302926744@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Benjamin Bara <benjamin.bara@skidata.com>

commit 3fe9f5882cf71573516749b0bb687ef88f470d1d upstream.

The current implementation does not work for widgets of DAPMs without
component, as snd_soc_dapm_to_component() requires it. If the widget is
directly owned by the card, e.g. as it is the case for the tegra
implementation, the call leads to UB. Therefore directly access the
component of the widget's DAPM to be able to check if a component is
available.

Fixes: f82eb06a40c8 ("ASoC: tegra: machine: Handle component name prefix")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Benjamin Bara <benjamin.bara@skidata.com>
Link: https://patch.msgid.link/20241008-tegra-dapm-v2-1-5e999cb5f0e7@skidata.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-dapm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2786,10 +2786,10 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_update_da
 
 int snd_soc_dapm_widget_name_cmp(struct snd_soc_dapm_widget *widget, const char *s)
 {
-	struct snd_soc_component *component = snd_soc_dapm_to_component(widget->dapm);
+	struct snd_soc_component *component = widget->dapm->component;
 	const char *wname = widget->name;
 
-	if (component->name_prefix)
+	if (component && component->name_prefix)
 		wname += strlen(component->name_prefix) + 1; /* plus space */
 
 	return strcmp(wname, s);


