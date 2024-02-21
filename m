Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67EC78B50;
	Wed, 21 Feb 2024 13:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522151; cv=none; b=rgg8gk2R/kjmoW8W+UqmSBF0jXF1fBherk/GSVRhyCX3L215DQLvGoKss/gQfJcKA57X7N4twq54rqpgdp34bhEURc+kxmVgTon0VTQ0KXZG/m3DabnU3Vlue9pL80COIiEII9ajQtOtCEc068UeZpcRWZBzCoFkzghk5EZILUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522151; c=relaxed/simple;
	bh=gEL7zdWIt0zjI8k4xFn25Rk0xzLoLl+TKqNVu4UFy4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEgPRglGcUhdhSOrhqreRlhY9z87zaNaVVfEgCth/UpuBdXBN72raFTa1Uk94HAsHHbf0vf/KtPaGzo9vEm1BSZPkrYoC3OLIBAx8gvjwiw3iHy3e1aF9e442QZJ0QAcK9LWBOryunz+ict81AvngRqTvT7pZtZXDTyG55aUQqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHiHnIq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHiHnIq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E61C433C7;
	Wed, 21 Feb 2024 13:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522151;
	bh=gEL7zdWIt0zjI8k4xFn25Rk0xzLoLl+TKqNVu4UFy4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHiHnIq0gKkVNfugy0DEvrrFugqj+COkxQv5pxzQ4T9KF4BJGEY9Z5glHzN24yRhF
	 a3eFSStXgwjEumSoQgri+5CaXXtHR+NbwcQCRtupqXoSNKnGzw2moN4/gYQKZrAvq6
	 uXAB2d7n9SL5rSSSitSJ53z5PvNe7fDAm2eOQ7mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 084/476] wifi: iwlwifi: fix a memory corruption
Date: Wed, 21 Feb 2024 14:02:15 +0100
Message-ID: <20240221130011.084283708@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -836,7 +836,7 @@ static int iwl_dbg_tlv_override_trig_nod
 		node_trig = (void *)node_tlv->data;
 	}
 
-	memcpy(node_trig->data + offset, trig->data, trig_data_len);
+	memcpy((u8 *)node_trig->data + offset, trig->data, trig_data_len);
 	node_tlv->length = cpu_to_le32(size);
 
 	if (policy & IWL_FW_INI_APPLY_POLICY_OVERRIDE_CFG) {


