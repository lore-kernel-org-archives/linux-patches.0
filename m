Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A306345ECC;
	Wed, 30 Sep 2026 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782791; cv=none; b=mc79OUrW0wsqr6K8u8W/Xbe+jVkAx9uqGPnB9M+Ut0s5KW5mzsku6S/sXZ8ZnrfmfX0LMdjjPTpxS33iDqVTq6UC5OKcklE9MaWMU5fwubc1E8X7oC+Hhb77m4AH3JziTpYVP2ciD+2YX4AG2nXChGxqYjUEBRf/H+QUmVdeaVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782791; c=relaxed/simple;
	bh=XzjCmkLbCuwDsco/aiz0nMWxVAHx9Zj7RcaaxYyK0mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBf/iQq0bw4c6pGOcbEKCCkWthHCMz8edeN2q9KB63Xhn2xFxoFZQ5PHFIT2lNctOnL5qp95JpHKnmLB9jJfMFx/ZS+AQX43/omY8w7+/yWbllz5jxlIr/4i2/v1uk5YWGkj5w+vpBcCLKdJx2GRI8E047zn2KExLh3JGuLJztE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfFyCkbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfFyCkbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C001F000FF;
	Wed, 30 Sep 2026 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782786;
	bh=IhGBiqjzILs2351rbGFx8lEF8JVsEm8dN2kOLlBamoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfFyCkbljV/kpfLzSLigjgXjmEX2raBOtMVoS69BRzqv5hrFwnT3HC2Bg8MVpP8Ja
	 GTrOKav+m6kHtehvS28ueE/Earu1MW4EQ5LvFHqHa9JEQwdpVX1c3HKzm9RxXY6ilY
	 54ZbPF+TXErjy/NNI5f+RYDeEQS8ERhy6i3VsZhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/595] wifi: iwlwifi: bound aligned TLV advance in FW parser
Date: Wed, 30 Sep 2026 17:21:03 +0200
Message-ID: <20260930152351.396638128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 47eea2c2a739e..4334ac2f9762e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -627,6 +627,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	u32 build, paging_mem_size;
 	int num_of_cpus;
 	bool usniffer_req = false;
+	size_t aligned_tlv_len;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -675,8 +676,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
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



