Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075DD151CE9;
	Tue, 20 Feb 2024 21:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464500; cv=none; b=Qjtkb7kdhKtH8xz9BufsJnzqvLd17KAhWT7BKdAoEVOhJF5MIg0x1LVA/adbsaqL3tkEdnZOS/ln0WTqyFvHjlpYmUn3pMPrQZRg1XGFFhWuCKoOGM00oOz+8YMTDPOvjbfe5apVoToPfOO6VknyBtp85YaPjp+tKdHHrDbz5Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464500; c=relaxed/simple;
	bh=isL9zXjUIVsNdQhVGi9t1smdcacPjjiE0zJC+e42yfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFykx3yMVZZ3VCM3QY7gMNW6Mq0twV6+xd/oWhSgxoKV+vz4Q5wehLz+NfsLUBgFinVs5U8inIlPtXivbEUgZ4G+Tpuy3noE7NFjtqr2/8ivpxtmaLtCqTzLESaFKQ4u6WkdE47uB00XEpWaYKDFVvePKttR+U9M9iMq+nDy4FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0KmCown; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0KmCown"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C72C433C7;
	Tue, 20 Feb 2024 21:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464499;
	bh=isL9zXjUIVsNdQhVGi9t1smdcacPjjiE0zJC+e42yfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0KmCownN8B8hVsK90ABHaDbtDvRNYFCQ63VYJ6AIW2k+xro/3pPydVWaL23UwPUP
	 O/cDIBHFJ0SsSrAfN7LMllr/fQFmURRz7BGSQznb8GFocmHaIUIFZxkwiemz4rxc9H
	 q9vns1ip7ROpEd6jsW+MhqQf+lQJaNsLvL6ljzF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 027/309] wifi: iwlwifi: Fix some error codes
Date: Tue, 20 Feb 2024 21:53:06 +0100
Message-ID: <20240220205634.031667315@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b96f30d11644..d73d561709d3 100644
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



