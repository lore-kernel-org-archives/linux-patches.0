Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91E5335BA1;
	Mon, 18 Aug 2025 13:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523640; cv=none; b=o951Be8yK7gnfi8Hjjy53ZgT3aybAuUT35gv/zny+cSccImhcK1T/7Lk2Zqzsy4715EjVld9MyeeN8NxuLCaO3xwfPj/xSPmOcCbsx3JZ0G45gpKzBA2+Kc/kv6dQHboSWfism849k6daRkX/38HI3fRBAjiVxErgh4vTCKhC7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523640; c=relaxed/simple;
	bh=1RxYCdG/8BK5BFGEC4dMF/TEURT3zHdKacg4CBNN3mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJbMKQ+0/bjRfR22Mc3Bz8lhZP3Dt+9ZSu7zGsiacISNed3UIw9r3MoPxnqX1XFwz9Cr8F56A6xdEDpQjXwSnvpBDZANvKYIdF2ocEl9XKSSIfY4JAVPgwe24/7VQVcxQJ+2LKPu5wtIde2/Qh6SzZuu05ZLgoVeyOEAfkXxw2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4vXYK37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4vXYK37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61770C4CEEB;
	Mon, 18 Aug 2025 13:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523639;
	bh=1RxYCdG/8BK5BFGEC4dMF/TEURT3zHdKacg4CBNN3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4vXYK37gFEwnUOIeYGXRysxFJiRc9rX2K6b3ZEIXndALf4fpM1aOYKYONfFRs5C+
	 C/+beTe2PwqOUgFijReCY5ibxJkURYfbXcqUvVwOtIgcBuUw4qul+m/koyg5XYjKT5
	 2Mtw0qVDviloL5R0Gz+JVuBfYmjtE9JvX9A4AbkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 234/515] wifi: iwlwifi: mvm: set gtk id also in older FWs
Date: Mon, 18 Aug 2025 14:43:40 +0200
Message-ID: <20250818124507.386502328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 61be9803f322ab46f31ba944c6ef7de195891f64 ]

We use gtk[i].id, but it is not even set in older FW APIs
(iwl_wowlan_status_v6 and iwl_wowlan_status_v7).
Set it also in older FWs.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250710212632.e91e49590414.I27d2fdbed1c54aee59929fa11ec169f07e159406@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 3e8b7168af01..a30ef33525ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2387,6 +2387,7 @@ static void iwl_mvm_convert_gtk_v2(struct iwl_wowlan_status_data *status,
 
 	status->gtk[0].len = data->key_len;
 	status->gtk[0].flags = data->key_flags;
+	status->gtk[0].id = status->gtk[0].flags & IWL_WOWLAN_GTK_IDX_MASK;
 
 	memcpy(status->gtk[0].key, data->key, sizeof(data->key));
 
@@ -2737,6 +2738,7 @@ iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm, u8 sta_id)
 		 * currently used key.
 		 */
 		status->gtk[0].flags = v6->gtk.key_index | BIT(7);
+		status->gtk[0].id = v6->gtk.key_index;
 	} else if (notif_ver == 7) {
 		struct iwl_wowlan_status_v7 *v7 = (void *)cmd.resp_pkt->data;
 
-- 
2.39.5



