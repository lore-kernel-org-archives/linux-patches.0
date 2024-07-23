Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74488158879;
	Tue, 23 Jul 2024 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759264; cv=none; b=J7tpWDX3L+eEiFYCTgO8P7O+a6GCFicedCoFNeHBDP1ar8b4OhFP9gHOb3psi8cqb215PCpTfcQEntC8/Qupc6+eJGey5hoGBQ4MWKMijE0HRD0Ol3GjkYE+O8T7TAYd1tpy/rdHSnvMS0Wr/WNdlq4wk76XusGXB03xRDhcvfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759264; c=relaxed/simple;
	bh=efTO3+/B1MAmg3U4vt44zTPRDgufofx2bKNB42nuQvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8P0BiPc82+DYzuBuq73yYigjqK7F4ntxQCpOrkX3n2tSo467nNL3yMycnZ78x3u5qVsMuI+vPYOOoEYt0eaaMHoNAR4ycata66fYRkHOTIwnuBVrYqTsdtENVHkDi1uqJYUNMLtRdlXcS8Vwt1ZfvKAbSg/u/wGg6VBFPlL8HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiDSSSYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiDSSSYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED525C4AF0A;
	Tue, 23 Jul 2024 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759264;
	bh=efTO3+/B1MAmg3U4vt44zTPRDgufofx2bKNB42nuQvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiDSSSYNlY8qJFl5/mW6+BroF/UYFLh6m85KScgMY9jflRZo7m5A841TuP04EbjSr
	 D4ev4EXTLD57MR6xTBTj8521aVNlhbAawdYluh0x50AVZAEl/07qRt8Z6h5F1WqYFo
	 N83d3gTDDx6QaGnj5x9qZKJuI7qC41gDHN68RWqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Montleon <jmontleo@redhat.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/105] ASoC: topology: Fix references to freed memory
Date: Tue, 23 Jul 2024 20:23:33 +0200
Message-ID: <20240723180405.408885930@linuxfoundation.org>
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

[ Upstream commit 97ab304ecd95c0b1703ff8c8c3956dc6e2afe8e1 ]

Most users after parsing a topology file, release memory used by it, so
having pointer references directly into topology file contents is wrong.
Use devm_kmemdup(), to allocate memory as needed.

Reported-by: Jason Montleon <jmontleo@redhat.com>
Link: https://github.com/thesofproject/avs-topology-xml/issues/22#issuecomment-2127892605
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240603102818.36165-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index d68c48555a7e3..b07083bae65ed 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1101,15 +1101,32 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 			break;
 		}
 
-		route->source = elem->source;
-		route->sink = elem->sink;
+		route->source = devm_kmemdup(tplg->dev, elem->source,
+					     min(strlen(elem->source),
+						 SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
+					     GFP_KERNEL);
+		route->sink = devm_kmemdup(tplg->dev, elem->sink,
+					   min(strlen(elem->sink), SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
+					   GFP_KERNEL);
+		if (!route->source || !route->sink) {
+			ret = -ENOMEM;
+			break;
+		}
 
 		/* set to NULL atm for tplg users */
 		route->connected = NULL;
-		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) == 0)
+		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) == 0) {
 			route->control = NULL;
-		else
-			route->control = elem->control;
+		} else {
+			route->control = devm_kmemdup(tplg->dev, elem->control,
+						      min(strlen(elem->control),
+							  SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
+						      GFP_KERNEL);
+			if (!route->control) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
 
 		/* add route dobj to dobj_list */
 		route->dobj.type = SND_SOC_DOBJ_GRAPH;
-- 
2.43.0



