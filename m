Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46DE50EC01;
	Wed, 30 Sep 2026 16:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784771; cv=none; b=TxdzBFzWF8K0TaJq0KcNoD32LJoQVUUyXOCww9gpeb3kLf9s8ihiJEHDuH2+vId4Lj9eZUKDZfA5zZVL5b/t+ECKH5wlA4Dlx3pZPKJlqQG/71YVD7HcHEtM8fZq9sI+ug9vEOa3u3wDHmMl88ANQ1zKnBT8yTvZcIG5s3ob3VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784771; c=relaxed/simple;
	bh=2KOeRR92TgcmRZEphjn9oTVBQGgzovCw8uTEBklYrj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5BCIbwLrds5w7yFX0z9IUisjs5Z1i//NAMRFyhyEN1Px1Q/Pi7y2/XBeDkxkweXwes2J/SbyPj2nekBHwC3LiMfFhLmmSPCWuT+YUR4Lt6T5lepxpXFdFZNW9Vw6inf43AH+oCDpSRuSUI5EyIdcLSWMf1Iri7wd65CKxRxV/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+sW9EBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+sW9EBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89501F00898;
	Wed, 30 Sep 2026 16:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784768;
	bh=eAoTpa84zlM52pYBMbkskb0A7299jNZtIeYzd/LkRiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+sW9EBj2TdQZDsPlaLwVsNhWuMuKxTH+tQMR7axBqvg0hVCPYXwvSufrxmhdCVPW
	 x41FXGpmxwDPGMP+LrCiuEDezfCpe0zBhYofKnE2Qt2ea9UFu8QYvGv/b3bYuQv6TJ
	 /FVasj2Gt1wAw+NQdol8cV+HZByUuPWRqfyAbjSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 272/982] wifi: iwlwifi: bound aligned TLV advance in FW parser
Date: Wed, 30 Sep 2026 17:16:48 +0200
Message-ID: <20260930152422.643592829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit acad742714bdc70e7fd7f234323807c596828213 ]

Validate ALIGN(tlv_len, 4) against remaining parser length before
consuming bytes from the firmware image.

This avoids length underflow on malformed TLVs.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717173215.393c286488f9.Ia39144dc3ca334325ee4eacb7420901e2446fc23@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 789393aa68cd8..7524b85baa712 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -644,6 +644,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	u32 build, paging_mem_size;
 	int num_of_cpus;
 	bool usniffer_req = false;
+	size_t aligned_tlv_len;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -692,8 +693,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				len, tlv_len);
 			return -EINVAL;
 		}
-		len -= ALIGN(tlv_len, 4);
-		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+
+		aligned_tlv_len = ALIGN(tlv_len, 4);
+		if (len < aligned_tlv_len) {
+			IWL_ERR(drv, "invalid aligned TLV len: %zd/%zu\n",
+				len, aligned_tlv_len);
+			return -EINVAL;
+		}
+
+		len -= aligned_tlv_len;
+		data += sizeof(*tlv) + aligned_tlv_len;
 
 		switch (tlv_type) {
 		case IWL_UCODE_TLV_INST:
-- 
2.53.0



