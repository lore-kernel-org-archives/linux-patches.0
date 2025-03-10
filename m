Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7D223535F;
	Mon, 10 Mar 2025 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627483; cv=none; b=UibwwcPKVIyIVkHS8Fcq3JaaZMpsEMOAuX8vg0OYdQqpBgm6NkJ+ttWIJDi0NXvXOC+PkRkaaOrjTNmcSrCjEg+5OZ3dc4LTEyTQ1pw6XwIqeLAX6Fsrted1on73/5cQ3R8iUEx8t6ewo2eKe3+LOGMkKCNlgDVtFyMrYUciunY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627483; c=relaxed/simple;
	bh=/wSuN+ucWwBpZLXQOpcIjI9HXZ0K9re4tc5Nb/CDoQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6Zn7PUiDHjdwyb7XKEyAKgAAAUK4OezpM8D7C5BfJwxtQHYR0hROprrik+wsDHqo0+Sn3Dtt6NF0IfHdFddJYt+zS1xcNYjs3JWy3CWDogdrfxROBPLvZTMc7gMQZ4KHKsAcClqrvc1IhkcRX8oHXn6TpKgHCz1NRxDAI5v8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXtD+eRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXtD+eRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48746C4CEE5;
	Mon, 10 Mar 2025 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627483;
	bh=/wSuN+ucWwBpZLXQOpcIjI9HXZ0K9re4tc5Nb/CDoQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXtD+eRgRFAnnzidj37ZwiU+0fuJnSIcF4vKmGB3vjLZHhKVLQIkilwz4HiVyghh9
	 xcGiRcII33u+u+h+G9knXxEUV52odAwPfZySsgTNxdFlyxnuK9XZowFcR4LZiIv9wd
	 pEX4BlYd8RDIRFHITFsI1IWwk7sNbgMU0r5D+2n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/269] wifi: iwlwifi: limit printed string from FW file
Date: Mon, 10 Mar 2025 18:04:56 +0100
Message-ID: <20250310170503.416121130@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

[ Upstream commit e0dc2c1bef722cbf16ae557690861e5f91208129 ]

There's no guarantee here that the file is always with a
NUL-termination, so reading the string may read beyond the
end of the TLV. If that's the last TLV in the file, it can
perhaps even read beyond the end of the file buffer.

Fix that by limiting the print format to the size of the
buffer we have.

Fixes: aee1b6385e29 ("iwlwifi: support fseq tlv and print fseq version")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.cb5f9d0c2f5d.Idec695d53c6c2234aade306f7647b576c7e3d928@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index c620911a11933..754e01688900d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1197,7 +1197,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 			if (tlv_len != sizeof(*fseq_ver))
 				goto invalid_tlv_len;
-			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %s\n",
+			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %.32s\n",
 				 fseq_ver->version);
 			}
 			break;
-- 
2.39.5



