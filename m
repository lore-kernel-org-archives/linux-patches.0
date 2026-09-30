Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F173B1ED7;
	Wed, 30 Sep 2026 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794749; cv=none; b=ey5Tu0G32/9YGSW5SZUYeiV3u2FJEXI+hNNucu9Rs6fKQKJE6E15DSTEfwK4sjWxpBdORA4AopvMFM5y3lU8m2WHHw32PNWJQWzGAfrDgWhrLwlVOqaMBqdnjSm5Racad6T0H4niB0u0NnDVLtAby6qUdrlvnspVLTI32YbNjL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794749; c=relaxed/simple;
	bh=YpJsZoaigK0hnHCOR99OJ1+SAOviKDcFCuEYdsyaAbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8E88rE5g7T1J3SB+isiPEQZp9iqKHMAmLKwSw1rtmlWBIaY9JVu6rii1aUD1vhPWALJ2aaVZ039Vs+EImILCCmEF3TOfENNoGDTuj5YntYfIx4LCDOeSN0ep58Hw7oIKwMB98qsQdpy2NPuoaE4dGCNPW1vnjFqw4+XqfYGr3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPQQHZ0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPQQHZ0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51961F00898;
	Wed, 30 Sep 2026 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794748;
	bh=Bcq5FEE/KrvRWxaq83TySkMk//W9CQ0DFr+I19KtqWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPQQHZ0LfMvW8Y/9jsEuWHnoZ1JeciQFKb8veWThNDBS2bMnvm/4vUCN7dMsVqJXs
	 9+YJZ+UDpxfVPx5yircOlGkCPoPMngk9r5VhlcRnUlc+W9VhXibQ95Z4vTjDNNZNy0
	 lpLPdaIQuk6yX7mF4tAagbtiCmr9BWdPvm3T4844=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0318/1193] wifi: iwlwifi: bound aligned TLV advance in FW parser
Date: Wed, 30 Sep 2026 17:16:42 +0200
Message-ID: <20260930152441.203709899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 42f7f95dac225..36e8d0e8c91bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -703,6 +703,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	u32 build, paging_mem_size;
 	int num_of_cpus;
 	bool usniffer_req = false;
+	size_t aligned_tlv_len;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -751,8 +752,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
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



