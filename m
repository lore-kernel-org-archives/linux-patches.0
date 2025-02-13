Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A02222B1;
	Thu, 13 Feb 2025 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457482; cv=none; b=OgwK8utuV2BBRjsQrP/hr475hPIEHXeNsDpUGKVDgwPLfvdF7CtWps/O4zlB0MQ+wuZGoPDnMHwqBnzfMPIucQtIXAiOqQUSW44N4XwNcC18SnMoBJhUbXP7NwbkEezhyxs2tNfs7ETpCgpaCVGH8Gg4ywDopGsEcq5BNVpeCKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457482; c=relaxed/simple;
	bh=QKVQgHYWSIEDDMJoePgxTBntpDHyEQ58tNvQ+I8Mul0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCjs0Lwgye2JlPf4lXOnfLj/Cwr4nGwTL5SvV5FUq1rKrF8YFeTf/EtnM1E9xCfMYF8tDJu8PyOAG5O3TWsWrLXhmWAPIVj5KdGmaP/nqjg47pO3Hmi1E+pAGRWUsi0tu6l/lodLVX6I/ufJcCvpUYmOq8VRQLB4ba5bL48wr7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZMt3+ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZMt3+ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B6FC4CEE4;
	Thu, 13 Feb 2025 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457482;
	bh=QKVQgHYWSIEDDMJoePgxTBntpDHyEQ58tNvQ+I8Mul0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZMt3+psCVjUEXaAUQUnyLIi7lCzQO3txi2xtruNIeTu9juDBliCitSMmvQJyZXC4
	 jurXOCf7FEfymQRjE14WudZWHLmyoupOixW2HV6aPm8m8cljyWkLVOHTBmGYLNWzyf
	 qd712LWWqml8789SqTtAj1mHoaotFv3l0XD19zBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/422] ACPI: property: Fix return value for nval == 0 in acpi_data_prop_read()
Date: Thu, 13 Feb 2025 15:24:31 +0100
Message-ID: <20250213142441.257883023@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 80a52a4e66dd1..e9186339f6e6b 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1187,8 +1187,6 @@ static int acpi_data_prop_read(const struct acpi_device_data *data,
 		}
 		break;
 	}
-	if (nval == 0)
-		return -EINVAL;
 
 	if (obj->type == ACPI_TYPE_BUFFER) {
 		if (proptype != DEV_PROP_U8)
@@ -1212,9 +1210,11 @@ static int acpi_data_prop_read(const struct acpi_device_data *data,
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



