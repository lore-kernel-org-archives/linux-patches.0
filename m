Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0F7B3F2;
	Wed, 21 Feb 2024 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523945; cv=none; b=H7kLQ0ifUXnaonPhPx8Noo1T08q7rtOE22kwIMbGSdU6CszzEhZ3Mdk7L5L9Wvpn4FHa373YrZQhgEy7Gswh888QuERkP9X8JNMatVZMrD3jg11q49eMrfy1I2UxHGLun3mEJVJNiXsgj27sAeAh2t6RrLM85RXzi1RrFJ94oGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523945; c=relaxed/simple;
	bh=roQdJZfXg56mO8iKU7A0kpZ7Npg4phomjcptZZPJtnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZS6NQs7hm4p1XZ+DOQI6G7feWN9v2e9K+gcwR2tgnoFCe4YxPKI8YH79JGE7foJIpFjg5XDmBWBx2Kq5nDn4YeJUGKKJsBQHVbAVi1xJm1eKj6p91si+S7bwIWLMmJAW+NQQM7jcUYiGaTDgoLhQG0WPGjgJYin9phDmLS5VwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kc6RGOT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kc6RGOT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32558C433F1;
	Wed, 21 Feb 2024 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523945;
	bh=roQdJZfXg56mO8iKU7A0kpZ7Npg4phomjcptZZPJtnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc6RGOT9xHMpCluVBXCUIW02iFFID7EofpeuVhncCq23ONnb7QlX8ihcqkI2UVRrO
	 Q1U30jfKE79oz+FpO9qP1MeY6lzEgDpuduKJVA5/D3yWTv1tWHBbw5S8h381IKOfCn
	 DXMQpTBCYbm0J+XAeNra0RuvhKwxcfJuG2NJ6whY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 069/379] wifi: iwlwifi: fix a memory corruption
Date: Wed, 21 Feb 2024 14:04:08 +0100
Message-ID: <20240221125956.958303391@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit cf4a0d840ecc72fcf16198d5e9c505ab7d5a5e4d upstream.

iwl_fw_ini_trigger_tlv::data is a pointer to a __le32, which means that
if we copy to iwl_fw_ini_trigger_tlv::data + offset while offset is in
bytes, we'll write past the buffer.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218233
Fixes: cf29c5b66b9f ("iwlwifi: dbg_ini: implement time point handling")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240111150610.2d2b8b870194.I14ed76505a5cf87304e0c9cc05cc0ae85ed3bf91@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -876,7 +876,7 @@ static int iwl_dbg_tlv_override_trig_nod
 		node_trig = (void *)node_tlv->data;
 	}
 
-	memcpy(node_trig->data + offset, trig->data, trig_data_len);
+	memcpy((u8 *)node_trig->data + offset, trig->data, trig_data_len);
 	node_tlv->length = cpu_to_le32(size);
 
 	if (policy & IWL_FW_INI_APPLY_POLICY_OVERRIDE_CFG) {


