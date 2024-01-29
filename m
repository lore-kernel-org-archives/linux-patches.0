Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722815AAA7;
	Mon, 29 Jan 2024 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548360; cv=none; b=flO/vQGX8w0rP+JShPm3CXjSV4/6RcfSzH/MmP2xqpKk/zA/FO/AU5M2GeslZcUSOtj9cHFp6lyrL56rtfAAYKW27gK20uk4zizkmWi3ACYk0jHX1bzF9sHTRTW8WPFzHvv3N4I8v3cm/j741OkMYAiG6EmYMcjDm1Rhp6Fl2Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548360; c=relaxed/simple;
	bh=CPY7RohklHgDe2LDx+Zb/1oELzxJKrtv8y3zwrrfPgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deFo9fExE+rFAXkhv09diH6KXs87PGQQtKXaqeaydGA7doNj+6hO+ANudwXIqmx4ZgvYcbwbzwxUI4rmZFGbbET/rjMq1i4PCCh2cK3Vh8zXl27OylpgM/+eYRkYCwVVMp50VTe3IPiL8K+8MseqMhzTs7C0jcFmmhEx8KIt85U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8Px9/gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8Px9/gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B01C433F1;
	Mon, 29 Jan 2024 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548359;
	bh=CPY7RohklHgDe2LDx+Zb/1oELzxJKrtv8y3zwrrfPgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8Px9/glklJU4mYGtEFIYkEfZ29PIX9QHaTo6njGufCdG/ji26Vigbh1Y6h+KM8KH
	 R/H9vt9S0DqwwRMGabl0rhC3i1kfqcE387iAMTw1X0qCiEO7z1x1bClV1aTIlfWhco
	 YYKGZb5xusPq+rwJDjoKuYByANB1LaUGzh+cfPW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 123/185] wifi: iwlwifi: fix a memory corruption
Date: Mon, 29 Jan 2024 09:05:23 -0800
Message-ID: <20240129170002.541173447@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1082,7 +1082,7 @@ static int iwl_dbg_tlv_override_trig_nod
 		node_trig = (void *)node_tlv->data;
 	}
 
-	memcpy(node_trig->data + offset, trig->data, trig_data_len);
+	memcpy((u8 *)node_trig->data + offset, trig->data, trig_data_len);
 	node_tlv->length = cpu_to_le32(size);
 
 	if (policy & IWL_FW_INI_APPLY_POLICY_OVERRIDE_CFG) {


