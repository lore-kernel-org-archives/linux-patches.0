Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B193332EBD;
	Wed, 20 May 2026 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301492; cv=none; b=rd4mNxzYc3ka9US95tdWztmMbgbek/NpoDzVvBrGaTl+L/cH4sgEhmgY8cMst+Cfd521mVlYjeoQEzIlsK7Mrd3cr4FpAFXOdGfCePpEeRfFaYXXjb66HG8tv+FCQvZZoYrIQkLUW9dJD8eK/ksmeJecpfdZGMvsabhCv6ZmCNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301492; c=relaxed/simple;
	bh=7EOw0POkdQGSsPGdzWf0RQ8bpsYf3k7wyR+RhJqU0Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJpszMcGFiMwgSBM7dK/al72YD1Afik8WNWqGyr0jh0hbwh0aJaaYdDP8RYwM1GgF5/zUHY7bOZ+zgRtstWLWko/5OiVRgJLrq95IveEGqRGMzYShHfQe17Pk4Hos2jA+SuUmq+kTWwXamFXg+bLeufO2xlRUEb+LITauFu/siY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lt2gziLy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lt2gziLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9381F000E9;
	Wed, 20 May 2026 18:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301491;
	bh=e78utoOU6rL0b8IYxW0edMSm0bjwcw1VH4m6o8cLgaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lt2gziLy7SO7h/gWTHwfwvVukx76pMk2K1xkdrgv9SychhC1eYnNAynRZWKVcPpad
	 zeRD3ZRUO/tdQklnZZgwiUcASLQeaHpNSzSHA+aC7qqoRtq1yTF7vsDR3E1l5x7qwe
	 lQCwDbdJeBl1R+0Z1ULUUhubsWkKflksSyLstbTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 576/666] ALSA: hda: cs35l56: Fix uninitialized value in cs35l56_hda_read_acpi()
Date: Wed, 20 May 2026 18:23:07 +0200
Message-ID: <20260520162123.751073547@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/cs35l56_hda.c | 12 +++++++-----
 sound/pci/hda/cs35l56_hda.h |  1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index c868177712866..ee5387140ae48 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -888,6 +888,7 @@ static int cs35l56_hda_system_resume(struct device *dev)
 static int cs35l56_hda_fixup_yoga9(struct cs35l56_hda *cs35l56, int *bus_addr)
 {
 	/* The cirrus,dev-index property has the wrong values */
+	cs35l56->num_amps = 2;
 	switch (*bus_addr) {
 	case 0x30:
 		cs35l56->index = 1;
@@ -937,7 +938,6 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 	char hid_string[8];
 	struct acpi_device *adev;
 	const char *property, *sub;
-	size_t nval;
 	int i, ret;
 
 	/*
@@ -973,13 +973,14 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
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
@@ -1002,7 +1003,8 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 			 "Read ACPI _SUB failed(%ld): fallback to generic firmware\n",
 			 PTR_ERR(sub));
 	} else {
-		ret = cirrus_scodec_get_speaker_id(cs35l56->base.dev, cs35l56->index, nval, -1);
+		ret = cirrus_scodec_get_speaker_id(cs35l56->base.dev, cs35l56->index,
+						   cs35l56->num_amps, -1);
 		if (ret == -ENOENT) {
 			cs35l56->system_name = sub;
 		} else if (ret >= 0) {
diff --git a/sound/pci/hda/cs35l56_hda.h b/sound/pci/hda/cs35l56_hda.h
index 38d94fb213a50..0074e8f5f18cb 100644
--- a/sound/pci/hda/cs35l56_hda.h
+++ b/sound/pci/hda/cs35l56_hda.h
@@ -25,6 +25,7 @@ struct cs35l56_hda {
 	struct work_struct dsp_work;
 
 	int index;
+	int num_amps;
 	const char *system_name;
 	const char *amp_name;
 
-- 
2.53.0



