Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C298281349;
	Thu, 13 Feb 2025 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457383; cv=none; b=YOLXg9IWN+us/4FDEC9/3UbMB3ll2xwZ/rrp+ghRjvVWtTLHfge/gUZrxXzM6UGfslaFnEcxJXZxBoYiGc43ISF9IUbx4DRqV3fvrZXGUc815mrwmm0sTEFhc4BIbzhV4PBdA61imqpL/P/Rld+XzZFIk5LBufBVQYiaBkLnjBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457383; c=relaxed/simple;
	bh=pw61gJp9gnaTbqh19EEkDIdi0KWh7gDIUYrHnT6g5wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNd/eblIMthHesoE5EIZscXFa5RAw+cX0WgWkArmb1Rss1xSPTHVdaq85c6yMqVYxHNgJJTmKHu0p6icXaNhM5Cq7XItM9aLypk1hZXjmWEc+Mfm5t85IOZsyzI8sIdnIrFu3bgkjWhQc4mqpNRHT7FOyddTZQIko4L9Cc+ilWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=157PA7CV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="157PA7CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80547C4CED1;
	Thu, 13 Feb 2025 14:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457383;
	bh=pw61gJp9gnaTbqh19EEkDIdi0KWh7gDIUYrHnT6g5wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=157PA7CVdZ16z6uGDgCxGWC2jhTyLD6+2b7QtRgyY/XsaXrPreOA6DmJVBYJEMAOr
	 H7jeVjExh++zkwXOgdT6W08MMHbvsvkMs0avfg85IzHFQ7sFKoTLGG9uuE7dvoetsQ
	 TG5I7RGmc+xhQCTRiDcCS72bXBeUAupwIndNrxdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/422] wifi: iwlwifi: avoid memory leak
Date: Thu, 13 Feb 2025 15:23:31 +0100
Message-ID: <20250213142438.955143621@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 80e96206a3ef348fbd658d98f2f43149c36df8bc ]

A caller of iwl_acpi_get_dsm_object must free the returned object.
iwl_acpi_get_dsm_integer returns immediately without freeing
it if the expected size is more than 8 bytes. Fix that.

Note that with the current code this will never happen, since the caller
of iwl_acpi_get_dsm_integer already checks that the expected size if
either 1 or 4 bytes, so it can't exceed 8 bytes.

While at it, print the DSM value instead of the return value, as this
was the intention in the first place.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241228223206.bf61eaab99f8.Ibdc5df02f885208c222456d42c889c43b7e3b2f7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 0bc32291815e1..a26c5573d2091 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -108,7 +108,7 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
 				    size_t expected_size)
 {
 	union acpi_object *obj;
-	int ret = 0;
+	int ret;
 
 	obj = iwl_acpi_get_dsm_object(dev, rev, func, NULL, guid);
 	if (IS_ERR(obj)) {
@@ -123,8 +123,10 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
 	} else if (obj->type == ACPI_TYPE_BUFFER) {
 		__le64 le_value = 0;
 
-		if (WARN_ON_ONCE(expected_size > sizeof(le_value)))
-			return -EINVAL;
+		if (WARN_ON_ONCE(expected_size > sizeof(le_value))) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		/* if the buffer size doesn't match the expected size */
 		if (obj->buffer.length != expected_size)
@@ -145,8 +147,9 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
 	}
 
 	IWL_DEBUG_DEV_RADIO(dev,
-			    "ACPI: DSM method evaluated: func=%d, ret=%d\n",
-			    func, ret);
+			    "ACPI: DSM method evaluated: func=%d, value=%lld\n",
+			    func, *value);
+	ret = 0;
 out:
 	ACPI_FREE(obj);
 	return ret;
-- 
2.39.5



