Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636A215885A;
	Tue, 23 Jul 2024 18:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759267; cv=none; b=ejZR/ndmUt5GoFlSk/33qSo35IF4vZvDClmjRF86/u0o7N32VtCzkJlw2t34R/ymsncQ3JhuQv80YDPanBJQdWlCkdxcLlJzrhl+2ZsvEib+v8+xjV7K7IMAAGanA6kSeBwHHcQ2/RH6/Rwjta+go3h5hbX5HDQX6upVS/wlFf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759267; c=relaxed/simple;
	bh=mC4ILENqXIjf2QB5k+HzOZQ3d7d6FpIexA38Ve27zzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzIYG1id2hNZOfrQx5JZr7LPzl5QAAMZi3yVTvs5E8oVbUeGzcJbV8z5NsqajkbLweMOAVfXIZhmI5I75lxRxMnqttYpOiDgvuOcaMcmW8B8MISH5PqK0/bIkw4zoboq9sCetQBHrS9Y04YeT6Y866jVcWkB2+AdYD8bO/m2SdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pfyg0WBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pfyg0WBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC7EC4AF09;
	Tue, 23 Jul 2024 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759267;
	bh=mC4ILENqXIjf2QB5k+HzOZQ3d7d6FpIexA38Ve27zzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pfyg0WBMeppOT7REzoVzEOEZVwAYQm3IUylGNUvC2l12lM+HtKzT0kkSLf6bhAvmN
	 QQnBKxq2hFMSho9mVfud7O+e6M+glrs/sjEzq+zMeWMoaAb9LH+tPLFAbZWwEL/Hxc
	 zzLer8IOkDNryP4qPz3TDugYvZEfSPipjvSWJv+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/105] ASoC: topology: Do not assign fields that are already set
Date: Tue, 23 Jul 2024 20:23:34 +0200
Message-ID: <20240723180405.447172709@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit daf0b99d4720c9f05bdb81c73b2efdb43fa9def3 ]

The routes are allocated with kzalloc(), so all fields are zeroed by
default, skip unnecessary assignments.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240603102818.36165-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index b07083bae65ed..d3cbfa6a704f9 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1113,11 +1113,7 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 			break;
 		}
 
-		/* set to NULL atm for tplg users */
-		route->connected = NULL;
-		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) == 0) {
-			route->control = NULL;
-		} else {
+		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) != 0) {
 			route->control = devm_kmemdup(tplg->dev, elem->control,
 						      min(strlen(elem->control),
 							  SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
-- 
2.43.0



