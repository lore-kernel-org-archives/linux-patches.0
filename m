Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ED72222AF;
	Mon, 23 Jun 2025 22:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716916; cv=none; b=CsLGt8Snt1pmH7o7KoCxrfAAdoJFyWqVjZ1L+jtTnP7NNcRFyWMl6w+OxwdCnGq1sGkH6yzYM0rAA2fLZdKptQDpu6G/Ogm5tglw1QxlmLxY7NsOQ08zHSw73XtxE2qR6UMXUqCNJexN0p0YIjwOWgGTK1V/9AKuS4I4WWqesk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716916; c=relaxed/simple;
	bh=Vo0TCtqkjiZyWcEo2i2JwJ+ykQ+DLjn08lt0LakBrXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey0tE/wxEY0a31+vTTVaiZWo/8sHe+adEQp1Pd/xAFtf1RYpg1Ya7YGZoI23zK4h2P+MVRcSB+StyoJCMH4AyhrQvEek3FDKx6NjZUlqaRZCxhKE/GOW4HiSEmcOz2ynpc0dv8n3Hin+UYo17NwrtdTbcRWebarOB3QmjnDzxtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wcgPifJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wcgPifJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B34C4CEEA;
	Mon, 23 Jun 2025 22:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716916;
	bh=Vo0TCtqkjiZyWcEo2i2JwJ+ykQ+DLjn08lt0LakBrXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wcgPifJMuQt4sB+HjqVFNpiUNbsNV2yQf8M/nQwisJl1+Nx/I0OhnnoXdGelJJBE
	 2N/uq0gYAU+wXYw22icunk9aMTnD4NNUlNZflZJbVyJGvFSo2PfcHqf011FyVYPzbh
	 KlItjiYQnKDzUzvSJ4jZO0VRSovhuovpa39quXVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/411] hwmon: (occ) Add soft minimum power cap attribute
Date: Mon, 23 Jun 2025 15:08:32 +0200
Message-ID: <20250623130642.905314603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 84dc9e8a7eec2cdff00728baedf0fb35fc7c11e8 ]

Export the power caps data for the soft minimum power cap through hwmon.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220215151022.7498-5-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 744c2fe950e9 ("hwmon: (occ) Rework attribute registration for stack usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index bbe5e4ef4113c..1757f3ab842e1 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -675,6 +675,9 @@ static ssize_t occ_show_caps_3(struct device *dev,
 	case 7:
 		val = caps->user_source;
 		break;
+	case 8:
+		val = get_unaligned_be16(&caps->soft_min) * 1000000ULL;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -836,12 +839,13 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 	case 1:
 		num_attrs += (sensors->caps.num_sensors * 7);
 		break;
-	case 3:
-		show_caps = occ_show_caps_3;
-		fallthrough;
 	case 2:
 		num_attrs += (sensors->caps.num_sensors * 8);
 		break;
+	case 3:
+		show_caps = occ_show_caps_3;
+		num_attrs += (sensors->caps.num_sensors * 9);
+		break;
 	default:
 		sensors->caps.num_sensors = 0;
 	}
@@ -1048,6 +1052,15 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
 						     show_caps, NULL, 7, 0);
 			attr++;
+
+			if (sensors->caps.version > 2) {
+				snprintf(attr->name, sizeof(attr->name),
+					 "power%d_cap_min_soft", s);
+				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
+							     show_caps, NULL,
+							     8, 0);
+				attr++;
+			}
 		}
 	}
 
-- 
2.39.5



