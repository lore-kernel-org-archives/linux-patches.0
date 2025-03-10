Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D760232792;
	Mon, 10 Mar 2025 17:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629290; cv=none; b=ZHd556J9VevT+k7aRrf8yx5y9PJA6OB5QuRefGTL81snF8SWW4G02bGVfoQWzje3YO7YR90q04zIBGQowCWdAw4eByymvbDF4SlgILuT+8rnL7E/R7Gv/f1P9mH7uKXWmwNesgOIq83DXxjWAyXhRYz5QVkCpFGfqhPiLlRMeYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629290; c=relaxed/simple;
	bh=FsbeXE5kb2/4ZRH9pOuMZTBavUPwi4cdqr9Qzo8f4JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IM+mhxBV0eyfw1kvTjrZvc7mmdwKQH2Tt46fcZHdh6HlmwhPrT6XwAHh74EZpp8O9E+I5j/UnBdUUepVvR5cPZ0dSOXOkRlStJqsYVFfYBKxn/QTXcFhPIsifyBgWR3yP/vXqICwghMTGoBvGHUBwmqoq6Y2tiB4c1q/jhaI/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBxL0cSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBxL0cSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93E6C4CEE5;
	Mon, 10 Mar 2025 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629290;
	bh=FsbeXE5kb2/4ZRH9pOuMZTBavUPwi4cdqr9Qzo8f4JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBxL0cSF7CUQSsp7ztYttBSt1+W53NFqOiLTjr9J/atSGcNHgmIYDUyIhvbIlugK2
	 0n3PHgtFXbn4cC5Eq28UkF6CuolTu4gWZrcZ2VYKA0ldZLz6a3VvzkUUmT5MVCBzWs
	 dK71FvK3qaGe+yq9TY1sYUcdpWnLIxkOqyEODpzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 216/620] wifi: iwlwifi: avoid memory leak
Date: Mon, 10 Mar 2025 18:01:02 +0100
Message-ID: <20250310170554.151822908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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
index 0b1c6bf729c3e..eefd42ea535cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -98,7 +98,7 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
 				    size_t expected_size)
 {
 	union acpi_object *obj;
-	int ret = 0;
+	int ret;
 
 	obj = iwl_acpi_get_dsm_object(dev, rev, func, NULL, guid);
 	if (IS_ERR(obj)) {
@@ -113,8 +113,10 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
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
@@ -135,8 +137,9 @@ static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
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



