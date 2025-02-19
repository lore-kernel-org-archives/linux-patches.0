Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0770D1DEFCD;
	Wed, 19 Feb 2025 09:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956769; cv=none; b=XBeDnDk0J3dRJURjAIep2iUZ9RDDGO/OWskUn8cWO9E51CoEk3LvQ/WxYKVRARgoJn5yST4TzPcfhvdUA8SROgJHJ8BjzQ+8VPT9sWg07092cZ+yLNQwYtIxh8+FUm4g8ZBHyCosDeKOpfRHePmbMZhsI5gWbBt/14JkRmCsulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956769; c=relaxed/simple;
	bh=9/kCkK+rv6IZCBVwJTBtQC2qsBk7I90E1UBDd7WztoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD+pr1aduBs/wV/RYmAIJ3DwYAJJG1DaHYMVIyvHuXNDv9VVhKPFP53kzjkaHtzXIngApjnMppVkjD72V2MebzzmoKMrdAxxRd9TjBni5WuNkhSbQOJypjN3vQS0MAI3UsomDaH/PHm3GFlgz2imoFlKzjkLky9xi+Jk7/pNgjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bw7lrdah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bw7lrdah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BF5C4CED1;
	Wed, 19 Feb 2025 09:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956768;
	bh=9/kCkK+rv6IZCBVwJTBtQC2qsBk7I90E1UBDd7WztoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bw7lrdahDRQaLRl1szpXyK4Ejf8P1tVZd6LXE0c2LA9so0PU4iEgDySQVzSyCEcwy
	 qKO8dwsGd4xvrsshNMvgDcq65RX8vvFL3jfd6N06lmllR3KLXUgT9HYDKG7PRCnNp1
	 VzRsq7QlwX9nc/Rv3cOY6FCiyg0fO9NPvx2JM7kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 294/578] wifi: iwlwifi: avoid memory leak
Date: Wed, 19 Feb 2025 09:24:58 +0100
Message-ID: <20250219082704.577598690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c96dfd7fd3dc8..84980f6a0d603 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -123,7 +123,7 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
 				    size_t expected_size)
 {
 	union acpi_object *obj;
-	int ret = 0;
+	int ret;
 
 	obj = iwl_acpi_get_dsm_object(dev, rev, func, NULL, guid);
 	if (IS_ERR(obj)) {
@@ -138,8 +138,10 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
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
@@ -160,8 +162,9 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
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



