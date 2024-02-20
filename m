Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0AD76C9C;
	Tue, 20 Feb 2024 21:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463364; cv=none; b=FmiNQ3IwptuagRwi3FCsRTB5QSzryXDqnBRNNP3WV+twSqnVUHSieaWyapVHb5We/P7PVnL+9hXKeaQTQk5Ocqdj9wpcWO+Ys7Oo68i/sFzv4tgMjIjSsM0hCQWASIsF/hD7+mT6VzSJywZwSdbOYeoquCCetIbeQYoEHoRjTps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463364; c=relaxed/simple;
	bh=uidsajpnHClLEkAiLNhBa6/fh5KY6fAZSdAAOcKeCE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBVWGsr2baTItdKiVLoc+KuoYYB6YR6A+DV2oX+jotD2kmPU/7nkGxNgw0Wnaw/hXzz+nZ2M2L7KUGgVC7fdTSNIQP2BITpHeR9o/W0FmtdwS90HrnduFoDYAD7MkFv5+z5IlAVC0IZfae4ogw97l/YocxbFSagFNal36WLZW3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5+9mwAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5+9mwAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBC0C433F1;
	Tue, 20 Feb 2024 21:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463363;
	bh=uidsajpnHClLEkAiLNhBa6/fh5KY6fAZSdAAOcKeCE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5+9mwATUt7WD+no0IwZdit3cfyhr+M4gAZq7q0qkuRrVmglb3vfNBjCwR/QlQRlQ
	 yWxR2TrJ1AQ5HkMFTy35njrii2TgVnwpWqYchS9bVl0AIa0/h0fF8arJI20owRUTVl
	 M5qwBaWVbko+NxtLA3SD7MiVzSy4Msya2xt9vnIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/331] wifi: iwlwifi: Fix some error codes
Date: Tue, 20 Feb 2024 21:52:16 +0100
Message-ID: <20240220205638.223706891@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c6ebb5b67641994de8bc486b33457fe0b681d6fe ]

This saves the error as PTR_ERR(wifi_pkg).  The problem is that
"wifi_pkg" is a valid pointer, not an error pointer.  Set the error code
to -EINVAL instead.

Fixes: 2a8084147bff ("iwlwifi: acpi: support reading and storing WRDS revision 1 and 2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://msgid.link/9620bb77-2d7c-4d76-b255-ad824ebf8e35@moroto.mountain
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index b26f90e52256..6f1919234f3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -618,7 +618,7 @@ int iwl_sar_get_wrds_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 2) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -634,7 +634,7 @@ int iwl_sar_get_wrds_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 1) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -650,7 +650,7 @@ int iwl_sar_get_wrds_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 0) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -707,7 +707,7 @@ int iwl_sar_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 2) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -723,7 +723,7 @@ int iwl_sar_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 1) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -739,7 +739,7 @@ int iwl_sar_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 0) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
-- 
2.43.0



