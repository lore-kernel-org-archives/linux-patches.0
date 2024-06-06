Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82313197A83;
	Thu,  6 Jun 2024 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683008; cv=none; b=Zd01rFZr2+jtIRPHrQW/e+8RtDdybiJiR0cikzxmWtoUdFdx0xnOWNHfhHnIckD+Rdg3fhUQi3Jv+DsO7yz61l+WfUzsxaB6AJvUdbtHSbcAXXlhNhT/2NkBHe6u0Wwql1W1buV3qL+SU4Fmrj+IuvFN1evzZYN7qbKGEaUPPBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683008; c=relaxed/simple;
	bh=jM73STagFitRaYyJi/KqnTiP9/M/NSWcL2Mf/wree+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lencA+cNEFxQFZOzxN7/yIa9K37hDnDCp6rBycVmm0FVVs7jSiaeffvFTh8d0HuwmrBfRUP/j4cqreNcsWB04Gr0KEaVkcV8V4uLRKjmo4f6YJSzNYi9axvOk7Bj0Ui7u9IfQP7yUD+EfU8HiBsiUBRN/jKrmwaWfnjdVqj2GcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENELMMdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENELMMdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E296C4AF0A;
	Thu,  6 Jun 2024 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683008;
	bh=jM73STagFitRaYyJi/KqnTiP9/M/NSWcL2Mf/wree+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENELMMdhY/PgZ/olPKakVHFUmDfUgdpWUmtrIjeQjR65RUtDK35aVoO3w0R8s/ixh
	 P2blE71Siibdk8P6gpetsqUrJR1MtL09QpG7onmmO6EfON13u0/xDTYmvpcyr/uy/s
	 SVQ7EmzXKWJu4EfAGML7ronKZvRJAtcwwawxec0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 217/374] ALSA: hda: hda_component: Initialize shared data during bind callback
Date: Thu,  6 Jun 2024 16:03:16 +0200
Message-ID: <20240606131659.068873605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ec6f32bc924d1c00cbcd5672510758f7088f2513 ]

Move the initialization of the shared struct hda_component array into
hda_component_manager_bind().

The purpose of the manager bind() callback is to allow it to perform
initialization before binding in the component drivers. This is the
correct place to initialize the shared data.

The original implementation initialized the shared data in
hda_component_manager_init(). This is only done once during probe()
of the manager driver. So if the component binding was unbound and
then rebound, the shared data would not be re-initialized.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: fd895a74dc1d ("ALSA: hda: realtek: Move hda_component implementation to module")
Link: https://lore.kernel.org/r/20240508100347.47283-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_component.c | 16 +++++++++++++++-
 sound/pci/hda/hda_component.h |  7 ++-----
 sound/pci/hda/patch_realtek.c |  2 +-
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/hda_component.c b/sound/pci/hda/hda_component.c
index cd299d7d84baf..d02589014a3fa 100644
--- a/sound/pci/hda/hda_component.c
+++ b/sound/pci/hda/hda_component.c
@@ -123,6 +123,21 @@ static int hda_comp_match_dev_name(struct device *dev, void *data)
 	return !strcmp(d + n, tmp);
 }
 
+int hda_component_manager_bind(struct hda_codec *cdc,
+			       struct hda_component *comps, int count)
+{
+	int i;
+
+	/* Init shared data */
+	for (i = 0; i < count; ++i) {
+		memset(&comps[i], 0, sizeof(comps[i]));
+		comps[i].codec = cdc;
+	}
+
+	return component_bind_all(hda_codec_dev(cdc), comps);
+}
+EXPORT_SYMBOL_NS_GPL(hda_component_manager_bind, SND_HDA_SCODEC_COMPONENT);
+
 int hda_component_manager_init(struct hda_codec *cdc,
 			       struct hda_component *comps, int count,
 			       const char *bus, const char *hid,
@@ -143,7 +158,6 @@ int hda_component_manager_init(struct hda_codec *cdc,
 		sm->hid = hid;
 		sm->match_str = match_str;
 		sm->index = i;
-		comps[i].codec = cdc;
 		component_match_add(dev, &match, hda_comp_match_dev_name, sm);
 	}
 
diff --git a/sound/pci/hda/hda_component.h b/sound/pci/hda/hda_component.h
index c80a66691b5d8..c70b3de68ab20 100644
--- a/sound/pci/hda/hda_component.h
+++ b/sound/pci/hda/hda_component.h
@@ -75,11 +75,8 @@ int hda_component_manager_init(struct hda_codec *cdc,
 void hda_component_manager_free(struct hda_codec *cdc,
 				const struct component_master_ops *ops);
 
-static inline int hda_component_manager_bind(struct hda_codec *cdc,
-					     struct hda_component *comps)
-{
-	return component_bind_all(hda_codec_dev(cdc), comps);
-}
+int hda_component_manager_bind(struct hda_codec *cdc,
+			       struct hda_component *comps, int count);
 
 static inline void hda_component_manager_unbind(struct hda_codec *cdc,
 					       struct hda_component *comps)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3b8b4ab488a61..08598a4f1fa3f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6793,7 +6793,7 @@ static int comp_bind(struct device *dev)
 	struct alc_spec *spec = cdc->spec;
 	int ret;
 
-	ret = hda_component_manager_bind(cdc, spec->comps);
+	ret = hda_component_manager_bind(cdc, spec->comps, ARRAY_SIZE(spec->comps));
 	if (ret)
 		return ret;
 
-- 
2.43.0



