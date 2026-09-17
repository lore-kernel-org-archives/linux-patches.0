Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B933A718C;
	Thu, 17 Sep 2026 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668559; cv=none; b=XPnerhwtY8L5MgmUh01bwQj8qyOJ0jQaSKprBFBLMLZL6qfnaPXCPEqKGEwJ+r2nHg6XMDCr4OK7zdt1DQVMwdQ0HLA5SJCW+Vv0suQaSuf68hmr5mjbIrusvzCvFPrAo+A7O3WitaBP6snWpoIWWNMjKemX6iaUdHJ5vTxxbD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668559; c=relaxed/simple;
	bh=QpmR8IWAJVjBQUk2L671kcz5W9nS3dcHAGVEOkji5pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJudb1xyT+Srg3vXTiOkwrhQKJcbwvqtBHpGqJNUprYflJ/0aFRCHK6npxCNxoSvBeNJmhgFbmgRxaCaUDzXGo3suFc3ewPpRamtr0R8B5qycDVQ6PuII3/j0DnxJg0LBJivwBI5y6IRMdE7MnBJi/zgixq+59X0mVvl/H3yalQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkVOIJ+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkVOIJ+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA641F000FF;
	Thu, 17 Sep 2026 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668558;
	bh=9/389ytECHXaSzSENo6Cu3eEZKtNx3QQKtOCOPrrzgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkVOIJ+qRSjEozq9Fqax6CkrM5mkkDa8iRKmOAZy+F+DexynU/3t6MKdPkWNzi7yR
	 xNI9wiyABQiOKaKj/sKWQrdVmdMeggzYT5O9B4mnxty04Yki+DtXSzxCFgFbRql/6i
	 RxmrtLS0EKu/nN3+u6DclIaXPPbc715N6I9QApGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0415/1102] wifi: iwlwifi: mvm: validate mac_link_id in session protect notif
Date: Thu, 17 Sep 2026 16:05:58 +0100
Message-ID: <20260917151550.085315151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 71245daf7d58a3c407c7e1422facce13ff6a584b ]

Check the mac_id before accessing the vif_id_to_mac array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.547ea470e686.I931445ae6f37bf0e1ef6f112c811712fc48af9c9@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 17b8ccc275693..c0b58e4a4cc1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -964,6 +964,11 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 	struct iwl_mvm_vif *mvmvif;
 	unsigned int notif_link_id;
 
+	if (IWL_FW_CHECK(mvm, id >= ARRAY_SIZE(mvm->vif_id_to_mac),
+			 "Invalid mac_link_id (%d) in session protect notif\n",
+			 id))
+		return;
+
 	rcu_read_lock();
 
 	if (ver <= 2) {
-- 
2.53.0



