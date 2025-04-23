Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEB727FD7A;
	Wed, 23 Apr 2025 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419819; cv=none; b=XkpfpVDxcIfG50/dRplSksS7EzCaLisDjdsO5LtP8ELOoqxB3Wt+rCgKzdQ77lA5wMKKuHSueq1eSyQmnsRjXpBr7u95P+T386rHpLh2iRPbc0SDc/sHDx26qbdpno25WhHLqyVUfghoJvMEgZyk5ExuqsHTvFTJVMjsSYRACA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419819; c=relaxed/simple;
	bh=ZpwS87rFwsTAG+2fn+5/tGaa9DK3m37uTl9uP3kEUTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijfL/PFRDSJcfM89sg5Z57vRvzpSHmfn/pU7bJkDsbNgeHL2WvF/0k6OQm0/CWWl+U5zDOOpz+w7dzcGMpTCkta1chwiUVhBYYnP5TUCZcufRVN7JtNqVQAJdec/vrIl8PJS3nGdNIFVI+T0tFuaCze+uuypCI60CWiSItBxYfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inKMKsGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inKMKsGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7005CC4CEE2;
	Wed, 23 Apr 2025 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419818;
	bh=ZpwS87rFwsTAG+2fn+5/tGaa9DK3m37uTl9uP3kEUTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inKMKsGneVCSIGhDgw8flpNBraTKCV2t71hW1cU05mMWkDNWm6a4FYenaXQaImjvy
	 Z0pCaNx3/u/7fzkjbB1gS8862CxpqTn+9HtZeTAFWP7vsLATAx4KlNAJXiw6vNvgd5
	 4XpvJVyl86wvN/Lpm6UJoCcKCZXMLhuRu96bSXU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 031/241] wifi: iwlwifi: pcie: set state to no-FW before reset handshake
Date: Wed, 23 Apr 2025 16:41:35 +0200
Message-ID: <20250423142621.790032153@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5f05c14e7c198415abe936514a6905f8b545b63b ]

The reset handshake attempts to kill the firmware, and it'll go
into a pretty much dead state once we do that. However, if it
times out, then we'll attempt to dump the firmware to be able
to see why it didn't respond. During this dump, we cannot treat
it as if it was still running, since we just tried to kill it,
otherwise dumping will attempt to send a DBGC stop command. As
this command will time out, we'll go into a reset loop.

For now, fix this by setting the trans->state to say firmware
isn't running before doing the reset handshake. In the longer
term, we should clean up the way this state is handled.

It's not entirely clear but it seems likely that this issue was
introduced by my rework of the error handling, prior to that it
would've been synchronous at that point and (I think) not have
attempted to reset since it was already doing down.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219967
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219968
Fixes: 7391b2a4f7db ("wifi: iwlwifi: rework firmware error handling")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250411104054.63aa4f56894d.Ife70cfe997db03f0d07fdef2b164695739a05a63@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 793514a1852a3..e37fa5ae97f64 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -147,8 +147,14 @@ static void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 		return;
 
 	if (trans->state >= IWL_TRANS_FW_STARTED &&
-	    trans_pcie->fw_reset_handshake)
+	    trans_pcie->fw_reset_handshake) {
+		/*
+		 * Reset handshake can dump firmware on timeout, but that
+		 * should assume that the firmware is already dead.
+		 */
+		trans->state = IWL_TRANS_NO_FW;
 		iwl_trans_pcie_fw_reset_handshake(trans);
+	}
 
 	trans_pcie->is_down = true;
 
-- 
2.39.5



