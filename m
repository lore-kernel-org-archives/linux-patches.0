Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEBB368941;
	Wed, 20 May 2026 16:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294986; cv=none; b=gBxSzDZa/cVy8bLQ+2C6X5KgUfkS21NCMKGLKcWFSH31Xvge6UTmRQXvtO5c6UOjRnTB94t42/Gh/1tGTpX9dvOOE9FdgSq1wc2qY/KPtFld/dIvr5uUUsoIRuXA+7CRN2CM3QewoQRAmv5N2PuAGuzQbCsRlMlGr/JflCr6a/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294986; c=relaxed/simple;
	bh=r/evPfu4llaNQHAlcdeUKPuyEIx7/0ziqeaIW0s2keE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5yDrT98f1WZUlYKiJ+eSNS8tBiFKaKA0+5C700U66LznvqusIH9ymoiBtr9bDOykpSdEsf/9wvsBy+ZwOpyjduVI4UnIBcxBJHbeILM+HHl1JlJzRwfRyMa0RNKsHphI5Flb1s3/1xdRoFytY2orYBt+nthghOazeWndCrUeao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMaUkjN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMaUkjN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430EA1F000E9;
	Wed, 20 May 2026 16:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294984;
	bh=h5t1NnjIFjToEBmPa4DMxg/dUQCZPONGQfV8oax0Ji8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMaUkjN03QquIsrZawtGQ9Sf60I8tu/DaaMy+QxtOrPtjMo53zOdJBSX+HuKTDmn7
	 b17pbumm9aht2AYoqEIHyUO27ZCjVliomWHe9sAfhHaEUEijK6uc34tYT7aL151bU6
	 1M/IwSDjV4SCDBFVQJ64RST4GajoprBQ6Bxt6NLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0246/1146] ASoC: SDCA: Update counting of SU/GE DAPM routes
Date: Wed, 20 May 2026 18:08:16 +0200
Message-ID: <20260520162153.804603851@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 1fb720d33eecdb9a90ee340b3000ba378d49f5ca ]

Device Layer Selector Unit's are controlled by a Group Entity control
rather than by the host directly. For the purposes of the ASoC class
driver the number of input routes to the SU is controlled by the number
of options within the Group Entity Selected Mode Control. ie. One valid
DAPM route for each valid route defined in the Group Entity.

Currently the code assumes that a Device Layer SU will have a number of
routes equal to the number of potential sources for the SU. ie. it
counts the routes using the SU, but then creates the routes using the
GE. However, this isn't actually true, it is perfectly allowed for the
GE to only define options for some of the potential sources of the SU.o
In such a case the number of routes return will not match those created,
leading to either an overflow of the routes array or undefined routes to
be past to the ASoC core, both of which generally lead to the sound card
failing to probe.

Update the handling for the counting of routes to count the connected
routes on the GE itself and then ignore the source routes on the SU.
This makes it match the logic generating the routes and ensuring that
both remain in sync.

Fixes: 2c8b3a8e6aa8 ("ASoC: SDCA: Create DAPM widgets and routes from DisCo")
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260225140118.402695-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_asoc.c | 41 +++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/sound/soc/sdca/sdca_asoc.c b/sound/soc/sdca/sdca_asoc.c
index a0191e5a5a7dd..b6536eeecf58f 100644
--- a/sound/soc/sdca/sdca_asoc.c
+++ b/sound/soc/sdca/sdca_asoc.c
@@ -51,6 +51,25 @@ static bool readonly_control(struct sdca_control *control)
 	return control->has_fixed || control->mode == SDCA_ACCESS_MODE_RO;
 }
 
+static int ge_count_routes(struct sdca_entity *entity)
+{
+	int count = 0;
+	int i, j;
+
+	for (i = 0; i < entity->ge.num_modes; i++) {
+		struct sdca_ge_mode *mode = &entity->ge.modes[i];
+
+		for (j = 0; j < mode->num_controls; j++) {
+			struct sdca_ge_control *affected = &mode->controls[j];
+
+			if (affected->sel != SDCA_CTL_SU_SELECTOR || affected->val)
+				count++;
+		}
+	}
+
+	return count;
+}
+
 /**
  * sdca_asoc_count_component - count the various component parts
  * @dev: Pointer to the device against which allocations will be done.
@@ -74,6 +93,7 @@ int sdca_asoc_count_component(struct device *dev, struct sdca_function_data *fun
 			      int *num_widgets, int *num_routes, int *num_controls,
 			      int *num_dais)
 {
+	struct sdca_control *control;
 	int i, j;
 
 	*num_widgets = function->num_entities - 1;
@@ -83,6 +103,7 @@ int sdca_asoc_count_component(struct device *dev, struct sdca_function_data *fun
 
 	for (i = 0; i < function->num_entities - 1; i++) {
 		struct sdca_entity *entity = &function->entities[i];
+		bool skip_primary_routes = false;
 
 		/* Add supply/DAI widget connections */
 		switch (entity->type) {
@@ -96,6 +117,17 @@ int sdca_asoc_count_component(struct device *dev, struct sdca_function_data *fun
 		case SDCA_ENTITY_TYPE_PDE:
 			*num_routes += entity->pde.num_managed;
 			break;
+		case SDCA_ENTITY_TYPE_GE:
+			*num_routes += ge_count_routes(entity);
+			skip_primary_routes = true;
+			break;
+		case SDCA_ENTITY_TYPE_SU:
+			control = sdca_selector_find_control(dev, entity, SDCA_CTL_SU_SELECTOR);
+			if (!control)
+				return -EINVAL;
+
+			skip_primary_routes = (control->layers == SDCA_ACCESS_LAYER_DEVICE);
+			break;
 		default:
 			break;
 		}
@@ -104,7 +136,8 @@ int sdca_asoc_count_component(struct device *dev, struct sdca_function_data *fun
 			(*num_routes)++;
 
 		/* Add primary entity connections from DisCo */
-		*num_routes += entity->num_sources;
+		if (!skip_primary_routes)
+			*num_routes += entity->num_sources;
 
 		for (j = 0; j < entity->num_controls; j++) {
 			if (exported_control(entity, &entity->controls[j]))
@@ -442,7 +475,6 @@ static int entity_parse_su_device(struct device *dev,
 				  struct snd_soc_dapm_route **route)
 {
 	struct sdca_control_range *range;
-	int num_routes = 0;
 	int i, j;
 
 	if (!entity->group) {
@@ -478,11 +510,6 @@ static int entity_parse_su_device(struct device *dev,
 				return -EINVAL;
 			}
 
-			if (++num_routes > entity->num_sources) {
-				dev_err(dev, "%s: too many input routes\n", entity->label);
-				return -EINVAL;
-			}
-
 			term = sdca_range_search(range, SDCA_SELECTED_MODE_INDEX,
 						 mode->val, SDCA_SELECTED_MODE_TERM_TYPE);
 			if (!term) {
-- 
2.53.0



