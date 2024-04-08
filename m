Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2072E62C;
	Mon,  8 Apr 2024 13:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581818; cv=none; b=eZa/98am5kdwf0cF2fRZXc4dFB1yI2H3xKQd9HdlXByzX06EhoY1GNqdYgk63I1daRpi8gKrvDkzePhRbEC1QzSqrqq3UlJv6GcJiC8z5i1L4yEBSm7UAbN2PcOB/MTHLQgGWOHLuZadjLxUhy+00ZvRuqAXDXVdMxdi3Wm3fIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581818; c=relaxed/simple;
	bh=PXWPZ6pgjotkacdYdWwH8t6jRWLNqQHLss2EHi/Oqd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5qCy906ZeUE5wiHlUwJNOliUrDP8hzDz6TzCszI1HTqS3+XLHdgiuHJ99Coe4VXyW9uPfAUvn3leqhiWJ5QimCx+tzFYOLacEMQMK8sQnMn/50eWnCfLrW4WEU0B7WW+mkrCSJ+fNYke7OU/vQlV2yHybnyDdRMJajQkQosyyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sk7WY1st; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sk7WY1st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE9C433C7;
	Mon,  8 Apr 2024 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581817;
	bh=PXWPZ6pgjotkacdYdWwH8t6jRWLNqQHLss2EHi/Oqd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sk7WY1stteuJMXgGIur/UsU9026HQnxZj+84N3LYnNpJHV2HT0jCZrHEiOStvtzUo
	 Wohu5eOkBHRs5sm804V9TSXksW0n2oVMHddp1Rc+Z6a4fsPbq8NVAnzSjrW3Tk1Cid
	 BUrh9Iy/gTPfPi0oj9DEijhqa3CxRc7EutBatt5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 011/273] wifi: iwlwifi: mvm: pick the version of SESSION_PROTECTION_NOTIF
Date: Mon,  8 Apr 2024 14:54:46 +0200
Message-ID: <20240408125309.637455685@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit bbe806c294c9c4cd1221140d96e5f367673e393a ]

When we want to know whether we should look for the mac_id or the
link_id in struct iwl_mvm_session_prot_notif, we should look at the
version of SESSION_PROTECTION_NOTIF.

This causes WARNINGs:

WARNING: CPU: 0 PID: 11403 at drivers/net/wireless/intel/iwlwifi/mvm/time-event.c:959 iwl_mvm_rx_session_protect_notif+0x333/0x340 [iwlmvm]
RIP: 0010:iwl_mvm_rx_session_protect_notif+0x333/0x340 [iwlmvm]
Code: 00 49 c7 84 24 48 07 00 00 00 00 00 00 41 c6 84 24 78 07 00 00 ff 4c 89 f7 e8 e9 71 54 d9 e9 7d fd ff ff 0f 0b e9 23 fe ff ff <0f> 0b e9 1c fe ff ff 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffb4bb00003d40 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff9ae63a361000 RCX: ffff9ae4a98b60d4
RDX: ffff9ae4588499c0 RSI: 0000000000000305 RDI: ffff9ae4a98b6358
RBP: ffffb4bb00003d68 R08: 0000000000000003 R09: 0000000000000010
R10: ffffb4bb00003d00 R11: 000000000000000f R12: ffff9ae441399050
R13: ffff9ae4761329e8 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff9ae7af400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fb75680018 CR3: 00000003dae32006 CR4: 0000000000f70ef0
PKRU: 55555554
Call Trace:
 <IRQ>
 ? show_regs+0x69/0x80
 ? __warn+0x8d/0x150
 ? iwl_mvm_rx_session_protect_notif+0x333/0x340 [iwlmvm]
 ? report_bug+0x196/0x1c0
 ? handle_bug+0x45/0x80
 ? exc_invalid_op+0x1c/0xb0
 ? asm_exc_invalid_op+0x1f/0x30
 ? iwl_mvm_rx_session_protect_notif+0x333/0x340 [iwlmvm]
 iwl_mvm_rx_common+0x115/0x340 [iwlmvm]
 iwl_mvm_rx_mq+0xa6/0x100 [iwlmvm]
 iwl_pcie_rx_handle+0x263/0xa10 [iwlwifi]
 iwl_pcie_napi_poll_msix+0x32/0xd0 [iwlwifi]

Fixes: 085d33c53012 ("wifi: iwlwifi: support link id in SESSION_PROTECTION_NOTIF")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240311081938.39d5618f7b9d.I564d863e53c6cbcb49141467932ecb6a9840b320@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index da00ef6e4fbcf..3d96a824dbd65 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -898,9 +898,8 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm_session_prot_notif *notif = (void *)pkt->data;
 	unsigned int ver =
-		iwl_fw_lookup_cmd_ver(mvm->fw,
-				      WIDE_ID(MAC_CONF_GROUP,
-					      SESSION_PROTECTION_CMD), 2);
+		iwl_fw_lookup_notif_ver(mvm->fw, MAC_CONF_GROUP,
+					SESSION_PROTECTION_NOTIF, 2);
 	int id = le32_to_cpu(notif->mac_link_id);
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_vif *mvmvif;
-- 
2.43.0



