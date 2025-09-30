Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63022236EB;
	Tue, 30 Sep 2025 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244862; cv=none; b=d2XxDeekx1CNBr4VzLthPtracL2kkufRTseHVxD7KsZjhjNouoa2UVS9ljeYOtSnGVaZynDh1vynC8ZQW6NOLylg2952usZhqnmWaO2BHHJMIgHdnxLMt4vVT6USDtGV1Yz716JSZcUHLN2WFEO0TtGNaGbDsiwfUKyZnjEYRRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244862; c=relaxed/simple;
	bh=oJwWbzi/oZ/CBPbQItD1a52EOXjuHpIp8JK1eSRXNCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3ILqfB3pkF+F8R/elRoZadhBk23LzFbou+LlnDTQvhDhunMERVPUxPLjGzIKIC3tNX8oE8CtFkbuOZ8M3ZBDsno71LY6e9YSoXkeNODgoZe/l/hsu82OGrAKru8u4L7Zq5lTEvXuoAGMMg8lz/Exdq/OvduWSib7jgULM8uk/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTGq3D7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTGq3D7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD27C4CEF0;
	Tue, 30 Sep 2025 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244862;
	bh=oJwWbzi/oZ/CBPbQItD1a52EOXjuHpIp8JK1eSRXNCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTGq3D7LCge5naJHZykCChsbKV3f73pLCRrZ7vzydl+AdPRJYkRzFHMIG5Yd7V9bE
	 sr4NkTF7Lw44VFLD7pTEwHKzQQqxpVImW6beXggRm4hmCe3rkq0vEJogCh7mIkpoDJ
	 q+dZRohTPYbhfFSYDgWmUMPa5esF1RIkTpyQwqlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.16 137/143] wifi: iwlwifi: fix byte count table for old devices
Date: Tue, 30 Sep 2025 16:47:41 +0200
Message-ID: <20250930143836.694968860@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 586e3cb33ba6890054b95aa0ade0a165890efabd upstream.

For devices handled by iwldvm, bc_table_dword was never set, but I missed
that during the removal thereof. Change the logic to not treat the byte
count table as dwords for devices older than 9000 series to fix that.

Fixes: 6570ea227826 ("wifi: iwlwifi: remove bc_table_dword transport config")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250828095500.eccd7d3939f1.Ibaffa06d0b3aa5f35a9451d94af34de208b8a2bc@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2093,7 +2093,8 @@ static void iwl_txq_gen1_update_byte_cnt
 		break;
 	}
 
-	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
+	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_9000 &&
+	    trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
 		len = DIV_ROUND_UP(len, 4);
 
 	if (WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX))


