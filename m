Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1A3F4DC0;
	Wed, 20 May 2026 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299582; cv=none; b=IEMfbH4F8/5DZtWHQn2skqrwloJBiSNRV6/+FNKgD2WNEkPvgJ7u0tEDdwrN60NX/qrF6JTGACy7PrrkqJCRZ18/27OaHW5vFIPq4zbbVsiw4xV51oRlkMy0LHYAZ0gqwcQ5XlElOu3ix07IRqcIaKWxHKbyuaXVBmAKr6LqMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299582; c=relaxed/simple;
	bh=5YPheWmDFDXtVupUi/JLXk0OT0gHYcrkkasSv3TfNmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu+htWip4K5TIdBP3C/pchxTRBjpJjjuXYJcbp739rggJ/hBzekFlI+uCThd12G6sJk4Le8vryE5glYNf/7kLQw4LWzWbWf9HjMVaoFgIDnFCsiu8YJVKhgLh9R3+4IFMxJVpc9ZxNGhswdeaVP4f/giS2+gf2fyxvWnG+VIoVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pu0k2h4N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pu0k2h4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F317B1F000E9;
	Wed, 20 May 2026 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299579;
	bh=l6/2VSPdepYx7ZuvKOGMX3vQqsdaDln/0cusH+MBjco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pu0k2h4NuYmpwilv7sAlOwO3RJFY8Myqka2P9Sehc3polC85O3RgQwzITOnSKbpFL
	 B584w2Ljnoxa1iEK2oHcP/k+4HBpDI38s4S7Lz305OhMFarOZboAhOY+C9Q7ZBaasq
	 jj1dGrJjKexjxURdhVUUmMFF1r9lqshQDrYlz1EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 825/957] ALSA: hda: cs35l56: Fix uninitialized value in cs35l56_hda_read_acpi()
Date: Wed, 20 May 2026 18:21:48 +0200
Message-ID: <20260520162152.460177823@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 82b7352e7ea97..79c15e21d4bcb 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -884,6 +884,7 @@ static int cs35l56_hda_system_resume(struct device *dev)
 static int cs35l56_hda_fixup_yoga9(struct cs35l56_hda *cs35l56, int *bus_addr)
 {
 	/* The cirrus,dev-index property has the wrong values */
+	cs35l56->num_amps = 2;
 	switch (*bus_addr) {
 	case 0x30:
 		cs35l56->index = 1;
@@ -933,7 +934,6 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 	char hid_string[8];
 	struct acpi_device *adev;
 	const char *property, *sub;
-	size_t nval;
 	int i, ret;
 
 	/*
@@ -969,13 +969,14 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
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
@@ -998,7 +999,8 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
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
index 38d94fb213a50..0074e8f5f18cb 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.h
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.h
@@ -25,6 +25,7 @@ struct cs35l56_hda {
 	struct work_struct dsp_work;
 
 	int index;
+	int num_amps;
 	const char *system_name;
 	const char *amp_name;
 
-- 
2.53.0



