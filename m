Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9E326B098;
	Thu, 13 Feb 2025 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460310; cv=none; b=Q8NMeqBptgHRtzm7uf5daCBNYDFZl1ATUo9eGDlLszxc9g+c2tkhA4s6GXVAAEZrr0z29znWMeRY2QdSHpYpvkUe+Emnz42MuLK03aNFPKmdouS0g9wLHFzon67Q2AgUAZBr6z0sG7xlhqleiM0iuQ7DcZWm6F8iGtAGjC/CD1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460310; c=relaxed/simple;
	bh=ClCbT+Nh0rLjuF1WJAwS94smox5O4RSOC+L3j3tpsWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peEVO9sWe5e1lcStXV/KxnctymgYJSWx7rihL+duOv8OKDEYxNSLmTXEamG3OGc4GIP991mWBUQdXottrs4WPzEg8wE3iBOZSMkf49Du84Zpow3WoG96SyFhZB6XUwHkfT38GRKj3/X14LKQ4QyRSaBCklNucxD2LdvsLbaUDLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6Kq2ZjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6Kq2ZjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FEEC4CED1;
	Thu, 13 Feb 2025 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460310;
	bh=ClCbT+Nh0rLjuF1WJAwS94smox5O4RSOC+L3j3tpsWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6Kq2ZjUUuR4hgpS3PW1pV9uy1/AtNY1HAh7/SrkSLN867/9+ArFx41CMsr6nhW43
	 QZ5S/8UEqB2dkIohtiJBBXfJVmTASh1B5RxYU9qvyJnJX5EUKm6mCDOwW65TCdJ/ev
	 3XvYNL3PDytI9hmv1YgmWJbBlkiaEHX1tBOybk9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/273] ACPI: property: Fix return value for nval == 0 in acpi_data_prop_read()
Date: Thu, 13 Feb 2025 15:27:28 +0100
Message-ID: <20250213142410.352031294@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ab930483eca9f3e816c35824b5868599af0c61d7 ]

While analysing code for software and OF node for the corner case when
caller asks to read zero items in the supposed to be an array of values
I found that ACPI behaves differently to what OF does, i.e.

 1. It returns -EINVAL when caller asks to read zero items from integer
    array, while OF returns 0, if no other errors happened.

 2. It returns -EINVAL when caller asks to read zero items from string
    array, while OF returns -ENODATA, if no other errors happened.

Amend ACPI implementation to follow what OF does.

Fixes: b31384fa5de3 ("Driver core: Unified device properties interface for platform firmware")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20250203194629.3731895-1-andriy.shevchenko@linux.intel.com
[ rjw: Added empty line after a conditional ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/property.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 4d958a165da05..dca5682308cb3 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1116,8 +1116,6 @@ static int acpi_data_prop_read(const struct acpi_device_data *data,
 		}
 		break;
 	}
-	if (nval == 0)
-		return -EINVAL;
 
 	if (obj->type == ACPI_TYPE_BUFFER) {
 		if (proptype != DEV_PROP_U8)
@@ -1141,9 +1139,11 @@ static int acpi_data_prop_read(const struct acpi_device_data *data,
 		ret = acpi_copy_property_array_uint(items, (u64 *)val, nval);
 		break;
 	case DEV_PROP_STRING:
-		ret = acpi_copy_property_array_string(
-			items, (char **)val,
-			min_t(u32, nval, obj->package.count));
+		nval = min_t(u32, nval, obj->package.count);
+		if (nval == 0)
+			return -ENODATA;
+
+		ret = acpi_copy_property_array_string(items, (char **)val, nval);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.5



