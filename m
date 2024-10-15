Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11371D90CD;
	Tue, 15 Oct 2024 11:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992272; cv=none; b=SNn4OuO2TbqFvcrKjXivvPWWRtztgkS1AQUYja21SE9UDUfdhLZwCaWBVNXy2SrtO4C/q3mAclPlWxVhm2IgI7t65J0mBuRZOr1dughsR3Ghh42xzTcrziGMdp4CIFsnlu2Iyh76cqQaaRsBimBzpEIfrO9ZZPckPpNK2ApFLdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992272; c=relaxed/simple;
	bh=Q1h/Ta8saG7Ty6fvWn11V0CRyCuvGDbYg04MT4RGHYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4dEljcltbezXvrxlBr7J4vEZ6hkm/AjUxNY4lvEWZpCyHHgNulHPvA5UfujZkoElM9NsYWubgPBHuNr715Pzk3/Ian24VyW1pj/CsZ5Ui4gM91PJLsW98MySBZh0EhNAIpsj7oPWOfG8MjL0Gt4vD+qJX9g73RgcechJwH/zdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdzTNvV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdzTNvV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2006AC4CEC6;
	Tue, 15 Oct 2024 11:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992272;
	bh=Q1h/Ta8saG7Ty6fvWn11V0CRyCuvGDbYg04MT4RGHYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdzTNvV9RQEnDIKB3gyQG31Rsee8M6D+lba4lMKh0hP026+TFxKBTt75z0LbWuntR
	 RhWtTnOWVHjpP7+IB/R5kAG8eN5Q+h/n5S+gRS3/uZEC439n6RMbwlkg9ZyLn0cZ7r
	 mbgLFqRD0Kx9xiJx9bWzhWwRdy+cz7hr9yHKLxgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/691] wifi: iwlwifi: mvm: pause TCM when the firmware is stopped
Date: Tue, 15 Oct 2024 13:20:16 +0200
Message-ID: <20241015112443.053456610@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

[ Upstream commit 0668ebc8c2282ca1e7eb96092a347baefffb5fe7 ]

Not doing so will make us send a host command to the transport while the
firmware is not alive, which will trigger a WARNING.

bad state = 0
WARNING: CPU: 2 PID: 17434 at drivers/net/wireless/intel/iwlwifi/iwl-trans.c:115 iwl_trans_send_cmd+0x1cb/0x1e0 [iwlwifi]
RIP: 0010:iwl_trans_send_cmd+0x1cb/0x1e0 [iwlwifi]
Call Trace:
 <TASK>
 iwl_mvm_send_cmd+0x40/0xc0 [iwlmvm]
 iwl_mvm_config_scan+0x198/0x260 [iwlmvm]
 iwl_mvm_recalc_tcm+0x730/0x11d0 [iwlmvm]
 iwl_mvm_tcm_work+0x1d/0x30 [iwlmvm]
 process_one_work+0x29e/0x640
 worker_thread+0x2df/0x690
 ? rescuer_thread+0x540/0x540
 kthread+0x192/0x1e0
 ? set_kthread_struct+0x90/0x90
 ret_from_fork+0x22/0x30

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.5abe71ca1b6b.I97a968cb8be1f24f94652d9b110ecbf6af73f89e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0b0022dabc7bc..e2c244ceaf706 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1018,6 +1018,8 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 
+	iwl_mvm_pause_tcm(mvm, false);
+
 	iwl_fw_dbg_stop_sync(&mvm->fwrt);
 	iwl_trans_stop_device(mvm->trans);
 	iwl_free_fw_paging(&mvm->fwrt);
-- 
2.43.0



