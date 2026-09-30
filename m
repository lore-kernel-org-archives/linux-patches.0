Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5491A50EC15;
	Wed, 30 Sep 2026 16:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786170; cv=none; b=ckNYDNqNavA9hv4w3V8aE0CZ8MtyNbaqu0kVAUT9QlR+w2oFwq0ZxbXNAu602zKT0kVy90lYIaKkZUEvw0MOCSHqPygpKod0Y7DgsSXSOZyD7JVP3x2kaxRoESNIBpf34kJm129bgHtPCbgNgOx7v+NkNeSviCsQo7Mm97EOHQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786170; c=relaxed/simple;
	bh=Jzaeprq8/5vc9khflQyGh4czeTQuqSEOsnJHOnobJr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUcGmqZ6K507U5a8uZGMCXzNegeeSMmha0q6ili8C89POHiX71nbdKE9RdeEmZpuhlfD7/xReairLHlCaOKlu02pF/qRrr1FTlIasYga6oTiHbzw+stZMPiG3YPHXb7TgXQEC5zHSKCl4XssZRUSCxBr3etjfXlQmk3DvYm2N/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFALKvP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFALKvP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9851F000FF;
	Wed, 30 Sep 2026 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786169;
	bh=LEqJHFMa7RZ/Og/M37/ZbsDeBZQXzizPYA4/loo6yGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFALKvP5gqQK7prgjsIcOYqD8uVEkv/+v+b5rSvnywuL1UJzxnN7c1CExdAWDWlUl
	 k5rqJkLINr6WcbhmNKBqxIHeoRvvF5lcG1l9GJDxNglMN+NP+AYIPRUe9fpEnyLO8Y
	 zrce/nMYdVPOfEP+H+VWx+Wrdixn4zlzNmaz5PwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 766/982] wifi: p54: validate curve data length in the calibration curve converters
Date: Wed, 30 Sep 2026 17:25:02 +0200
Message-ID: <20260930152433.206935360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhuo Wei <me@cherr.cc>

commit ce858fa6b8a214dee5adb82358885fa024cdd887 upstream.

p54_convert_rev0() and p54_convert_rev1() read calibration curve
data from the device-supplied EEPROM entry using channel and
points-per-channel counts taken verbatim from that same entry, so
an entry that declares more data than it carries drives an
out-of-bounds read past the EEPROM buffer (verified with a KASAN
reproducer of the conversion loop). The sibling converters
p54_convert_output_limits() and p54_convert_db() already validate
their counts against the entry length; this path was missed.

Reject the entry when the counts do not fit in the entry data.

Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
Cc: stable@vger.kernel.org
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Link: https://patch.msgid.link/20260831-p54-pda-validation-v2-1-dae566b388c8@cherr.cc
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intersil/p54/eeprom.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -418,17 +418,22 @@ free:
 }
 
 static int p54_convert_rev0(struct ieee80211_hw *dev,
-			    struct pda_pa_curve_data *curve_data)
+			    struct pda_pa_curve_data *curve_data, size_t len)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_pa_curve_data_sample *dst;
 	struct pda_pa_curve_data_sample_rev0 *src;
+	size_t needed = curve_data->channels *
+		(sizeof(*src) * curve_data->points_per_channel + 2);
 	size_t cd_len = sizeof(*curve_data) +
 		(curve_data->points_per_channel*sizeof(*dst) + 2) *
 		 curve_data->channels;
 	unsigned int i, j;
 	void *source, *target;
 
+	if (len < sizeof(*curve_data) + needed)
+		return -EINVAL;
+
 	priv->curve_data = kmalloc(sizeof(*priv->curve_data) + cd_len,
 				   GFP_KERNEL);
 	if (!priv->curve_data)
@@ -470,17 +475,22 @@ static int p54_convert_rev0(struct ieee8
 }
 
 static int p54_convert_rev1(struct ieee80211_hw *dev,
-			    struct pda_pa_curve_data *curve_data)
+			    struct pda_pa_curve_data *curve_data, size_t len)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_pa_curve_data_sample *dst;
 	struct pda_pa_curve_data_sample_rev1 *src;
+	size_t needed = curve_data->channels *
+		(sizeof(*src) * curve_data->points_per_channel + 3);
 	size_t cd_len = sizeof(*curve_data) +
 		(curve_data->points_per_channel*sizeof(*dst) + 2) *
 		 curve_data->channels;
 	unsigned int i, j;
 	void *source, *target;
 
+	if (len < sizeof(*curve_data) + needed)
+		return -EINVAL;
+
 	priv->curve_data = kzalloc(cd_len + sizeof(*priv->curve_data),
 				   GFP_KERNEL);
 	if (!priv->curve_data)
@@ -767,6 +777,7 @@ int p54_parse_eeprom(struct ieee80211_hw
 		case PDR_PRISM_PA_CAL_CURVE_DATA: {
 			struct pda_pa_curve_data *curve_data =
 				(struct pda_pa_curve_data *)entry->data;
+
 			if (data_len < sizeof(*curve_data)) {
 				err = -EINVAL;
 				goto err;
@@ -774,10 +785,10 @@ int p54_parse_eeprom(struct ieee80211_hw
 
 			switch (curve_data->cal_method_rev) {
 			case 0:
-				err = p54_convert_rev0(dev, curve_data);
+				err = p54_convert_rev0(dev, curve_data, data_len);
 				break;
 			case 1:
-				err = p54_convert_rev1(dev, curve_data);
+				err = p54_convert_rev1(dev, curve_data, data_len);
 				break;
 			default:
 				wiphy_err(dev->wiphy,


