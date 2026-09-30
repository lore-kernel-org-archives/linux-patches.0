Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DD32E7386;
	Wed, 30 Sep 2026 18:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794703; cv=none; b=r+tT8KIeoGmlUeamD7uO+KCgACNGZ8w/PtfgdzVOUOoL/jhakNXj5KAWqxDCCVUwY6PKTatfKN2z+JsAgE2qn2+5edsgj+hte7qwaPGcKy81z5qa2w2sfS+CkOOJb4U4izdF/ass/EOC0Vkk/P8nCGBoSxBAJi4GkJeQkwF7vSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794703; c=relaxed/simple;
	bh=+eVtkf9YIV0c+o14TAHNpkbikSBC8bBARFPN/FmPF4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ18zU28kGQU2bcapJh+S1fpujdKJ8q+tNWG+hfZI2k+5HXkJNkccP3R5qROEBAheNOyLIwYtNLSSWJdHNRNfaCXoCXl8dzH3/KWsI4gX0yJlYp9KavVBL5JNCKpNT/itvtJYAxQg5kOKPuE0vfqSfK23hG04bYM6ImZSapq5aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XODl4Q18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XODl4Q18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1522F1F00898;
	Wed, 30 Sep 2026 18:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794702;
	bh=2nod8bqMjFHWGjhaaCvfq8WlKoIXmYHZM/rl1gY420A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XODl4Q18CWV+AA6ThgmNhhtHDEjKgKp1SDlpkrHflmuMZLslpZfl+zOMyotD7qIbf
	 zve3fjYEYvaT9XgUAF7Hvh7lvmMLAZ7lUlUXw9kxzl70F2zXLklDpTofsA0mFToN3B
	 VjJBKZdKgSa0Nb+3TGyI+mIKBTrhP8NVwvJ0OLTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0304/1193] wifi: iwlwifi: mvm: validate sta_id in BA window status notif
Date: Wed, 30 Sep 2026 17:16:28 +0200
Message-ID: <20260930152440.905211299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 6aa77efaea9efea92e3090c35ad348fd759a3cf3 ]

BA_WINDOW_STATUS_NOTIFICATION_ID extracts a 5-bit sta_id from the
firmware notification and uses it to index fw_id_to_mac_id[] without
bounds checking. Validate sta_id before array access to prevent
out-of-bounds indexing.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.2e97f337f3cb.Ic3f0f404082ccdea13809a3c0b70e0f5417e1037@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 542c192698a4b..8beedd2e4def5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -1059,6 +1059,11 @@ void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 		/* get the station */
 		sta_id = (ratid & BA_WINDOW_STATUS_STA_ID_MSK)
 			 >> BA_WINDOW_STATUS_STA_ID_POS;
+		if (IWL_FW_CHECK(mvm,
+				 sta_id >= mvm->fw->ucode_capa.num_stations,
+				 "Invalid sta id (%d) in BA window status notification\n",
+				 sta_id))
+			continue;
 		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 		if (IS_ERR_OR_NULL(sta))
 			continue;
-- 
2.53.0



