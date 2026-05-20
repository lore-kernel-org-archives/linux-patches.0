Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2511835F619;
	Wed, 20 May 2026 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297100; cv=none; b=pO3gkIbMbnsLgh7bQsg0wytEDHjOLb4+AFvaj+LDFfSbxc+1THAwADvowXLe6VeGzIUwjV8ikglqM2BFXiIDesZ46PVA8dUl4jnRaKtssjeM6DfTZxbymLIilN+vNzc9mHkU4Zrjqh9ukYWuzVw5PlhWDp8qdb2l219AGhqKdA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297100; c=relaxed/simple;
	bh=27VzVqbrDIOSxFFexTo4J2S7DfSyAqNnPa2v7OUj8mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFz1fcOQyv9yD+IIHkI/klnekY2W6YSR0Td9TW9hlUNf9LBx8LITsdW/ldGjm7GUYgFzkb2/gDJlI9axOWC2HCjxiN08jt5aiQyiM0m6ROs/wZU87JizOxrbz0w+dZxMOQXpJjm/8J1VdDp9fRGwIL2AhE/MeGIXP23T0TYeOMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvBDsUy8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvBDsUy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AF81F000E9;
	Wed, 20 May 2026 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297099;
	bh=BXb/NPV6r3Ml67Z4FQtix86Ny5yjQD/c5FHh1Q0qvro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvBDsUy8pMm2gmLlCvGO+wXVJ9kXv45cdBxrdPw8far/YsHAJ8oPQNShc6mxm5KYh
	 ws8mgh2AvrJa4Uqy++9aAmRPM1OiFKRjUCw/aahpT/sX8vej/ypVa49maotcd3eoQF
	 a3+V5V/qcYbUuMGnyLqZNhpshJIqPbSwhcC8VG7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0999/1146] ALSA: hda: cs35l56: Fix uninitialized value in cs35l56_hda_read_acpi()
Date: Wed, 20 May 2026 18:20:49 +0200
Message-ID: <20260520162210.844163439@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 90df4957a3271adf391b3432cd76a40887cf3273 ]

Eliminate the uninitialized 'nval' in cs35l56_hda_read_acpi() if a
system-specific quirk overrides processing of the dev-index property.
The value is now stored in a new 'num_amps' member of struct cs35l56_hda
so that the quirk handler can set the value.

The quirk for the Lenovo Yoga Book 9i GenX  replaces the values from the
dev-index property with hardcoded indexes. So cs35l56_hda_read_acpi() would
then skip reading the property. But this left the 'nval' local variable
uninitialized when it is later passed to cirrus_scodec_get_speaker_id().

Fixes: 40b1c2f9b299 ("ALSA: hda/cs35l56: Workaround bad dev-index on Lenovo Yoga Book 9i GenX")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-sound/aenFesLAStjrVNy8@stanley.mountain/T/#u
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260428130531.169600-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 12 +++++++-----
 sound/hda/codecs/side-codecs/cs35l56_hda.h |  1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index dc25960a4f231..4c8d01799931c 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -976,6 +976,7 @@ static int cs35l56_hda_system_resume(struct device *dev)
 static int cs35l56_hda_fixup_yoga9(struct cs35l56_hda *cs35l56, int *bus_addr)
 {
 	/* The cirrus,dev-index property has the wrong values */
+	cs35l56->num_amps = 2;
 	switch (*bus_addr) {
 	case 0x30:
 		cs35l56->index = 1;
@@ -1025,7 +1026,6 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 	char hid_string[8];
 	struct acpi_device *adev;
 	const char *property, *sub;
-	size_t nval;
 	int i, ret;
 
 	/*
@@ -1061,13 +1061,14 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 			ret = -EINVAL;
 			goto err;
 		}
-		nval = ret;
+		cs35l56->num_amps = ret;
 
-		ret = device_property_read_u32_array(cs35l56->base.dev, property, values, nval);
+		ret = device_property_read_u32_array(cs35l56->base.dev, property, values,
+						     cs35l56->num_amps);
 		if (ret)
 			goto err;
 
-		for (i = 0; i < nval; i++) {
+		for (i = 0; i < cs35l56->num_amps; i++) {
 			if (values[i] == id) {
 				cs35l56->index = i;
 				break;
@@ -1090,7 +1091,8 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 			 "Read ACPI _SUB failed(%ld): fallback to generic firmware\n",
 			 PTR_ERR(sub));
 	} else {
-		ret = cirrus_scodec_get_speaker_id(cs35l56->base.dev, cs35l56->index, nval, -1);
+		ret = cirrus_scodec_get_speaker_id(cs35l56->base.dev, cs35l56->index,
+						   cs35l56->num_amps, -1);
 		if (ret == -ENOENT) {
 			cs35l56->system_name = sub;
 		} else if (ret >= 0) {
diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.h b/sound/hda/codecs/side-codecs/cs35l56_hda.h
index cb4b5e7356a35..3705af7c186b3 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.h
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.h
@@ -26,6 +26,7 @@ struct cs35l56_hda {
 	struct work_struct dsp_work;
 
 	int index;
+	int num_amps;
 	const char *system_name;
 	const char *amp_name;
 
-- 
2.53.0



