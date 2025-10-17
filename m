Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FA7270568;
	Fri, 17 Oct 2025 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715809; cv=none; b=WpE++S2n4pK4Q83ujfYOm8WbCFsq+nkCc7uKb/+fVOBB4sOSvK3Z/0ksCd9rYO3N23mF65+8SeOPX/0u54gAco5AaEqe8AGQTCx0lUbsU9Zbt40fKY84YTDpd4Yt2Am5em+bnrysoU71ezMeJD2xNpEEE/PLOUsGqSyCSpFajMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715809; c=relaxed/simple;
	bh=Dwn2RLsp81F5LJ2JO10Ku8MEGCLe0NVukoEMY57PwtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQXsG7P9zVdqepbwbcRQleuqKM6tbsy6N4s1a0J8ik6unZm2wSX9GQxqFiITANkkGl5ZAaXjGnnPYZyLcGIuaU6T7ecOQbcPuaDAANn1vdxFoJYpWqhNAQHay1aq0L0SIDdPRCFWuKmLdyBk3QsXWrEp5tNsbMt+gwsWfHbN/L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBjyltvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBjyltvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFC3C4CEE7;
	Fri, 17 Oct 2025 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715808;
	bh=Dwn2RLsp81F5LJ2JO10Ku8MEGCLe0NVukoEMY57PwtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBjyltvt/u8mJStKP4Gm1Xtk6OYJ1SLDSJ01t6sBod6Zh3aN2slKnxRd5zCpivwL/
	 Lc0UZzoGmfWg14jIqUYuAnuowZRUzkncLOuotEwa9HOH0nlsQ+hjjo8uPWhqT+Oq2n
	 1t2RCN6Hi8DnmYF73PJG5C1xwwT+t92cwPPaaxOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.17 311/371] wifi: iwlwifi: Fix dentry reference leak in iwl_mld_add_link_debugfs
Date: Fri, 17 Oct 2025 16:54:46 +0200
Message-ID: <20251017145213.329465016@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit ff46e2e7034c78489fa7a6bc35f7c9dd8ab82905 upstream.

The debugfs_lookup() function increases the dentry reference count.
Add missing dput() call to release the reference when the "iwlmld"
directory already exists.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://patch.msgid.link/20250902040955.2362472-1-linmq006@gmail.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
index cc052b0aa53f..372204bf8452 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
@@ -1001,8 +1001,12 @@ void iwl_mld_add_link_debugfs(struct ieee80211_hw *hw,
 	 * If not, this is a per-link dir of a MLO vif, add in it the iwlmld
 	 * dir.
 	 */
-	if (!mld_link_dir)
+	if (!mld_link_dir) {
 		mld_link_dir = debugfs_create_dir("iwlmld", dir);
+	} else {
+		/* Release the reference from debugfs_lookup */
+		dput(mld_link_dir);
+	}
 }
 
 static ssize_t _iwl_dbgfs_fixed_rate_write(struct iwl_mld *mld, char *buf,
-- 
2.51.0



