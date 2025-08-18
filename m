Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E3C261B9B;
	Mon, 18 Aug 2025 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525285; cv=none; b=cBZDiQTyxOo2jL8AL+BRzzzAUdn07tYkQ6cKDTRO7V7UX3S2rthgkRh0YIRXR6O2uVR+TF/eT7vQ/dRKJQrPDxFFAQmG21IimZRApcKUpZWfRqoxmogcGcYpXZGFaBfzWOyvaTZJIFRPlQsw77t4DE18pZx/eit8dFAous4Ln1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525285; c=relaxed/simple;
	bh=nlEMfP9cUhgbAbcaaLTEvk4kp97eiQkvSv/t/8dee3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0ihmtYxRMQwjeb6jK1rUDGIR9fSsBijoEV25d/v8VMO+bmwehEHR0zKpkPtPNL6gpST+udsOYaZ/2GsdiHqgs4NH8vBPhCI8EOBbFT5B58m1fmHcgsxnIFu0ONZt2+OpfxbfxvxZffPgahh1RGounp8H1XE3YppR48FqlwN4II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/WXw47h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/WXw47h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6511EC4CEF1;
	Mon, 18 Aug 2025 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525284;
	bh=nlEMfP9cUhgbAbcaaLTEvk4kp97eiQkvSv/t/8dee3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/WXw47hTY9k0vsiGD6KUMvvoRt3ux7ROlyqBLUC3SiJIPfDDb7WF3A0zx6IxFTnA
	 pQhDEPQeXfuAAvIW0J9JMujy5woz+u6Pn+DPCXJYcs3ChDv8eU8lR8KVMSpeuu2esa
	 e+S15BgAc3HwQeRJEtc7sCUe96xlJkv24sdyhMnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 216/570] wifi: iwlwifi: mld: avoid outdated reorder buffer head_sn
Date: Mon, 18 Aug 2025 14:43:23 +0200
Message-ID: <20250818124514.121460322@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 666357bf3e57c6a68be128825775aee14f9a24f7 ]

If no frames are received on a queue for a while, the reorder buffer
head_sn may be an old one. When the next frame that is received on
that queue and buffered is a subframe of an AMSDU but not the last
subframe, it will not update the buffer's head_sn. When the frame
release notification arrives, it will not release the buffered frame
because it will look like the notification's NSSN is lower than the
buffer's head_sn (because of a wraparound).
Fix it by updating the head_sn when the first frame is buffered.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250723094230.e1f62a9a603c.I7b57a481122074b1f40d39cd31db2e5262668eb2@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/agg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
index 6b349270481d..3bf36f8f6874 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -305,10 +305,15 @@ iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
 	 * already ahead and it will be dropped.
 	 * If the last sub-frame is not on this queue - we will get frame
 	 * release notification with up to date NSSN.
+	 * If this is the first frame that is stored in the buffer, the head_sn
+	 * may be outdated. Update it based on the last NSSN to make sure it
+	 * will be released when the frame release notification arrives.
 	 */
 	if (!amsdu || last_subframe)
 		iwl_mld_reorder_release_frames(mld, sta, napi, baid_data,
 					       buffer, nssn);
+	else if (buffer->num_stored == 1)
+		buffer->head_sn = nssn;
 
 	return IWL_MLD_BUFFERED_SKB;
 }
-- 
2.39.5



