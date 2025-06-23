Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168623FB1B;
	Mon, 23 Jun 2025 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716147; cv=none; b=neMXVq/xBf24MdW8ICo1rsgvofKsElE1ATmTeKIY2Jw2mBm/xr3tRleVG91o5uMaVS7hWq9uU76rJBsBzXHZdJ1kFBV9l5nFEMRv9JrjdyQA52Jabnjhz6SO+1/SVXhY3VCYn4u0QGqR2tofp/Pcc10/FWK5UPBnU22/BZ8mMLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716147; c=relaxed/simple;
	bh=D6PRV+QxArvZo+UkfE8WRXn1tsZ4PJk5aQe3lVwVJx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thia1gd0EK3H17uKVRML6118/h7GXqD4gZ1R1oKsWZbfg/4RDWlU4ye7rvAlTn7wVLn7R3LsLCODRe/xyKFj5nT3sIigSUGMaHtqfUTasjT4at7GbuRgrWJ/6bGvp5YkNSkOKEHBZG2nWHo704IqOyjW2XlsLdESplt9v8+D9sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9DbdRn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9DbdRn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97312C4CEEA;
	Mon, 23 Jun 2025 22:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716146;
	bh=D6PRV+QxArvZo+UkfE8WRXn1tsZ4PJk5aQe3lVwVJx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9DbdRn27oqSvxW0YbUUvNnfvsUTRAoVIBJoVeC7QXWJsFlsAdvSMPfNnsvKSgBvq
	 WgD+PGEJ26Ptp9y/1L5tr7swLyeDWA4MwWR0378RK6DNxoVxSzHfCRAVlDFcX9pCNq
	 QTA+GdD5RAJ2wWpCdwnVlrxPkp1pVea/+Ng1ivRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/355] hwmon: (occ) Add soft minimum power cap attribute
Date: Mon, 23 Jun 2025 15:08:25 +0200
Message-ID: <20250623130635.918691563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 580e63d7daa00..ce4a16b475fd1 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -685,6 +685,9 @@ static ssize_t occ_show_caps_3(struct device *dev,
 	case 7:
 		val = caps->user_source;
 		break;
+	case 8:
+		val = get_unaligned_be16(&caps->soft_min) * 1000000ULL;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -845,12 +848,13 @@ static int occ_setup_sensor_attrs(struct occ *occ)
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
@@ -1057,6 +1061,15 @@ static int occ_setup_sensor_attrs(struct occ *occ)
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



