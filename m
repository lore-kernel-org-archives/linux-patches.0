Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562E54D5B7;
	Wed, 21 Feb 2024 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523133; cv=none; b=dI6XlroE3lNJzPFr/sYSD1KWvv7p0RrbIdm9iONZAZUpccMSYnm7mhcZJeMJGPGTEz5XWOn8EaYjnSsnUhpUPp/nFTW7PK0YKvL1oy0YEYByC3ebJRkbfe6uYGnt0bLmClRT7u+xYw9Hm5ohNhqkIqDxsgoWMYUZNJ1PwvKmFYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523133; c=relaxed/simple;
	bh=/j2Mtl5Bkusi4FsorGss6I1BKtsMsOKCl8+P44ANTaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVtaZu4kP8Ty6nyvllUaS5qltiW+pXm8Q6GP5j4aGHv8BN2dYWP90P4ox99xtPFXkvpWJ+speb+MeJb2RMw4242iAmVLjqB8sYancBnsfQkOwXnQFIpnnYtJKi+R0zykmlScry/wdqEX/BO9/h9dZWwnLD+R4nDYIMWfaRq6QKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doihKC9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doihKC9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894F9C43394;
	Wed, 21 Feb 2024 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523133;
	bh=/j2Mtl5Bkusi4FsorGss6I1BKtsMsOKCl8+P44ANTaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doihKC9RUarPJqRMYcBv0sRY+JAAxbpWb/zlkE42OJYFMRL0O38hCohEX0e3rLU2m
	 a9AyOPvT4JRtdtKc9l9QKebJDlUjUIL9NK10O6jSyYzSkpMLqz2npoVpK4FRqPtAf4
	 OlYKUxIkU4zPzlj824fSbKZJL+61kPrCKDyWkUNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 349/476] wifi: iwlwifi: Fix some error codes
Date: Wed, 21 Feb 2024 14:06:40 +0100
Message-ID: <20240221130020.883405022@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9e00d1d7e146..f0e0d4ccbc09 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -527,7 +527,7 @@ int iwl_sar_get_wrds_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 2) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -543,7 +543,7 @@ int iwl_sar_get_wrds_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 1) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -559,7 +559,7 @@ int iwl_sar_get_wrds_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 0) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -614,7 +614,7 @@ int iwl_sar_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 2) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -630,7 +630,7 @@ int iwl_sar_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 1) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
@@ -646,7 +646,7 @@ int iwl_sar_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 					 &tbl_rev);
 	if (!IS_ERR(wifi_pkg)) {
 		if (tbl_rev != 0) {
-			ret = PTR_ERR(wifi_pkg);
+			ret = -EINVAL;
 			goto out_free;
 		}
 
-- 
2.43.0



