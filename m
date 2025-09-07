Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EA017BB21;
	Sun,  7 Sep 2025 20:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276953; cv=none; b=vEYRG4t1n8LHvbYWX0oxP1p34pwchk8YQKkdieeC4H302C2PFOZxrNeYzQV6p10d/Fo84Nj3qNUmjausOmDl5d4CPjUDYOFcENAtwBzbYvKq9lXv2MLumbyDyBbKMz8crE/M87JucNCcYErZj6V81UOyLpe0HWUKz1ZqB1SSbv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276953; c=relaxed/simple;
	bh=hTECp/hoSmq+G1ahONfRrQxLeiXTXfNkfAEV+vRD5y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcXfv6pvt0FR5tTLkIGHaEOCWNLRnNl8cM/4HJHaf5JGNyh1xRp9TxEpwxhVHIuLjs45TEUZK/ulM7cYgqV2amh3jKAVPUlD97io08Sc2xEh8FejQzIrQqK9BOLafmtmYbpWJhvdLrgcL9b2KO3fYx6yZfIN9ZcNeuT63zzXI4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNZHhnJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNZHhnJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223BAC4CEF0;
	Sun,  7 Sep 2025 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276953;
	bh=hTECp/hoSmq+G1ahONfRrQxLeiXTXfNkfAEV+vRD5y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNZHhnJyJd1IVWUtt2oH1aAwOR3rCEXbCsKTNUR0EL5gA+9d8Fz81nG9jXnJO9HT/
	 oNziEDqRu0lXZq6YCt9PLFzgobxK+t8iCnAo6yjQZZV52y52NfN7TCBE42oR5LmG/Z
	 vW6J438JJG+DmvL6zfQFCmmysWnHU/gyTEZF/y5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/175] wifi: iwlwifi: uefi: check DSM item validity
Date: Sun,  7 Sep 2025 21:57:16 +0200
Message-ID: <20250907195615.828538552@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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
index 86d6286a15378..e5fbb5fcc4abc 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -741,6 +741,12 @@ int iwl_uefi_get_dsm(struct iwl_fw_runtime *fwrt, enum iwl_dsm_funcs func,
 		goto out;
 	}
 
+	if (!(data->functions[DSM_FUNC_QUERY] & BIT(func))) {
+		IWL_DEBUG_RADIO(fwrt, "DSM func %d not in 0x%x\n",
+				func, data->functions[DSM_FUNC_QUERY]);
+		goto out;
+	}
+
 	*value = data->functions[func];
 	ret = 0;
 out:
-- 
2.50.1



