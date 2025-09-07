Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4FA1DF246;
	Sun,  7 Sep 2025 20:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277535; cv=none; b=oul9aAfYgeiI1LeO4oXgFjH9GwSK16t772kgjhSM0RuZcgc0c5jwz8g5cP9h/bxwyDZgvodTRVFR9NNMsm3HaEmB5xnFij/nsNCNBfpfEtIEMtpx4+MwbTpL2XWj7dtBq9CMi0hS3Z/6DpdLPB3RYi7OmiFV3K3hLQ5RxWWZ6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277535; c=relaxed/simple;
	bh=GIpveB3KPbGfePf2dPmQ0Hr6LNvsxBOIQXlcQ+70vvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7nDkep+QtR+pA9rV0V8NLr1MQe9l2y5SV6x5cnH+U5lVL5+xXtCVNBGLsncqX7oj7wJ3FMNjWqPDUe2UMvW5RhGeaTH0onnc1IwbzfzVV/GlqKTDuJR3MmpjqdftULb87LFlykqVJB6CprdOfZp/0RQeYc6PN+EXtdEs5Z5j0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNp9WRhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNp9WRhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51580C4CEF0;
	Sun,  7 Sep 2025 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277535;
	bh=GIpveB3KPbGfePf2dPmQ0Hr6LNvsxBOIQXlcQ+70vvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNp9WRhAoy1Wobq9VZMJk2hfnVFznEYJp3gK2N3sfV/zdiNZTU1cJV6V2CsefMXA5
	 zItfFKSo+FMkNtdArnY3zTmW/+R9UEsiovMLChLRuS2o9Io7IQXt2l8RLHerUMmLu+
	 zIi3MMsfHxI+90h3MD93lXv8gstFXPXu/EBFXyfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 045/183] wifi: iwlwifi: uefi: check DSM item validity
Date: Sun,  7 Sep 2025 21:57:52 +0200
Message-ID: <20250907195616.847870221@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1d33694462fa7da451846c39d653585b61375992 ]

The first array index is a bitmap indicating which of the
other values are valid. Check that bitmap before returning
a value.

Fixes: fc7214c3c986 ("wifi: iwlwifi: read DSM functions from UEFI")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220085
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250828095500.59ec52ff865e.I9e11f497a029eb38f481b2c90c43c0935285216d@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 48126ec6b94bf..99a17b9323e9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -747,6 +747,12 @@ int iwl_uefi_get_dsm(struct iwl_fw_runtime *fwrt, enum iwl_dsm_funcs func,
 		goto out;
 	}
 
+	if (!(data->functions[DSM_FUNC_QUERY] & BIT(func))) {
+		IWL_DEBUG_RADIO(fwrt, "DSM func %d not in 0x%x\n",
+				func, data->functions[DSM_FUNC_QUERY]);
+		goto out;
+	}
+
 	*value = data->functions[func];
 
 	IWL_DEBUG_RADIO(fwrt,
-- 
2.50.1



