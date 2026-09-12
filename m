Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDA82DE702;
	Sat, 12 Sep 2026 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220671; cv=none; b=GfeCOi2uiHRuFhS3gFSnqPM6QYvebPeqmigslNRQfueNOCCVfhdZEXCaa328hqA9Vyl6G5/8h2fP4RpcHYhmPHJGvstt/TB8zHCVIvVm/xLNRZmRLG7+ZWKpli+Wmx4rws9F9Cn8HN9/75h/qllUaFSXbEIKhbOPXyg+JgUl/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220671; c=relaxed/simple;
	bh=5J0TJBNNeYWVDnrAXHqISON0LaHK4Ksud0XQi1c4uik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTJ4/2x0oeYrYo3GNltkLujKHO4oVUJx13EUdQRCM8Ai7PFHzFzm2q5B1t9LjOpXGwPMu+oI87lhWxFmPDRAbBYQd8NZ8bxCGZuvREvAoJ6LdPuWceO/vaQoXM4gtw49UX2Fe5C6p2IN2UeamoGSCXb8IvBHuPJTMQ/7RO4XaEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxvTaP0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxvTaP0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391BC1F000FF;
	Sat, 12 Sep 2026 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220670;
	bh=FZPhdnFDo1E1PKcfbimx0JxUIVfCpIYNOAE9cOatzFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxvTaP0fNx7q+tph4pkbBA7eJDBJSFOCVXecvjYv/kq9c0PHvEDfx94F/UbbloiyV
	 4Yff4RLJiA6Up//nm4CKkTIyXT6KQcRjRd/zbyrSR5VxhyJIGocgSmLThsoZ5j9Quy
	 OaHl3PyNaCMUosnfl8bJ6wOzwoTBp3Q8kOFhLNNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0208/1424] power: supply: bq25890: Fix power_supply reference leak
Date: Sat, 12 Sep 2026 08:44:00 +0200
Message-ID: <20260912065611.945888891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

commit 863c32a83e4235eb0cbf6106f2b124e645302156 upstream.

bq25890_fw_probe() acquires a reference to a secondary charger using
power_supply_get_by_name(), but the reference is not released on later
probe failures or on driver detach.

In particular, failures after bq25890_fw_probe() returns successfully,
such as a failure in bq25890_hw_init(), also leak the reference.

Register a device-managed cleanup action immediately after acquiring
the secondary charger. This releases the reference on all subsequent
probe failures and on driver detach.

Found by code review.

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Cc: stable@vger.kernel.org
Fixes: d54bf877fd87 ("power: supply: bq25890: Add support for having a secondary charger IC")
Link: https://patch.msgid.link/20260722044416.1623621-1-make_ruc2021@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq25890_charger.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1389,6 +1389,14 @@ static int bq25890_fw_read_u32_props(str
 	return 0;
 }
 
+static void bq25890_release_secondary_chrg(void *data)
+{
+	struct bq25890_device *bq = data;
+
+	power_supply_put(bq->secondary_chrg);
+	bq->secondary_chrg = NULL;
+}
+
 static int bq25890_fw_probe(struct bq25890_device *bq)
 {
 	int ret;
@@ -1401,6 +1409,10 @@ static int bq25890_fw_probe(struct bq258
 		bq->secondary_chrg = power_supply_get_by_name(str);
 		if (!bq->secondary_chrg)
 			return -EPROBE_DEFER;
+
+		ret = devm_add_action_or_reset(bq->dev, bq25890_release_secondary_chrg, bq);
+		if (ret)
+			return ret;
 	}
 
 	/* Optional, left at 0 if property is not present */


