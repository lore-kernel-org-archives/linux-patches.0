Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342633B2D1A;
	Wed, 30 Sep 2026 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791183; cv=none; b=CVwU54WnoDnmFgrDHLg3tqcNctHzaOnIncwHcTI1hR0sxsSvUkJu5l6jqJ/LkIfREXinQXN4Ad4YYKJbIAgavx4/ggbRPIgJCrroUZ+nNllWdEq0aoDAJh1IOq88Ss099/+yg/XtODfK0G6u5j4UQ0T+K6rFEgW0XHKrC+m2Fuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791183; c=relaxed/simple;
	bh=gb8aSJxlp3/RM4xDMEYxCXoV/RmMBXZr8hawvxiqcaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGT7Guortop2gn+2lDGIiecuScq3FhjYz9sqa+moEAMCquL6Hv1yeshgShwzZeTgVb4cWSpJovtUKj7a+U1z5AD+U1wuHWs1+uC4nBHTdQGdc7i/xQqO4njAH/csX0X2hyZYoQgxX9kVQ+l2KUexmYd4Js1TTFhXXMQIVTfsEbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IV7Qf1E1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV7Qf1E1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9981F000FF;
	Wed, 30 Sep 2026 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791182;
	bh=lBd8NKrEmqzdbYeUuYk7PxyQjzV3yHyR01n3ZlQHMl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IV7Qf1E1lVEt25m881MnphnjO7lYNefjSG+uUN3Ae1X1tqWmx6z/gmmFbRkQfne97
	 Jmb4j2uu8Z1E/9NXMdPpv7tyiS4q/ebryAXA533kYXoxa6nNBnR0weQH0k3eBK5pxM
	 mc2lXNt5lV71KmDq7O9gCzEoagbfXvgPMtBTJL2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/752] wifi: iwlwifi: bound aligned TLV advance in FW parser
Date: Wed, 30 Sep 2026 17:21:22 +0200
Message-ID: <20260930152402.827747772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 144aa1825286e..5ab792a8e4cf9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -571,6 +571,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	u32 build, paging_mem_size;
 	int num_of_cpus;
 	bool usniffer_req = false;
+	size_t aligned_tlv_len;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -619,8 +620,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
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



