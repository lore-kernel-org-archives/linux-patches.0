Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255F12C46E;
	Tue, 30 Apr 2024 11:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475380; cv=none; b=QLsHky2MTWXz9VwOxS+0Wt+ztEuuGJ2FLa4/3MlsOEmXT+Lj4JUZqvfjeEtKAKGGHkxk+Rnx0/zReGOTzRIGSCfTZSiFk1JHaAiUJqo5L3naTlIL0bdG+hemT97f/bWKhYgWR9QKaDGU1IGHjrU5pZWgMuQswQP376/wqJ70Z4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475380; c=relaxed/simple;
	bh=JIyI0t1FtICOkVKcSBp5adGzkIRb4dMFIpBWJaIfyXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1yAenPPGcvI2u54/1qcyJNlODVMb+UlK1glt8GxcnK5bEtiB9q2K6b/+9vIJjBcKSsey1SoEIpdkJBQU64rn3MPAQ6SnQSAXBmYReOvHNdpei4qzucHlUJsHDNtQDBwiwMSyHftVYlhPEg/yp0q7151Jx1NT69wSw2diKIZQ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnB+W7FZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnB+W7FZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CFEC2BBFC;
	Tue, 30 Apr 2024 11:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475379;
	bh=JIyI0t1FtICOkVKcSBp5adGzkIRb4dMFIpBWJaIfyXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnB+W7FZ6HDQMZ/tqiw5TzjC5n+4J+dVxQrhTLuAK9axBdusgB8TG+cAkp+3hVQ+l
	 aUxMB2tTfCUoH9gR7+r/zOOfMd64bHYA8EYxrE+2EwTS8OdWc9qSt6S5p4fNWk0zW8
	 eE5Kog28ezXhJTLpoucUVxpC9q/a2Np/6U6PqfTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/186] wifi: iwlwifi: mvm: return uid from iwl_mvm_build_scan_cmd
Date: Tue, 30 Apr 2024 12:38:11 +0200
Message-ID: <20240430103059.165770809@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit bada85a3f584763deadd201147778c3e791d279c ]

This function is supposed to return a uid on success, and an errno in
failure.
But it currently returns the return value of the specific cmd version
handler, which in turn returns 0 on success and errno otherwise.
This means that on success, iwl_mvm_build_scan_cmd will return 0
regardless if the actual uid.
Fix this by returning the uid if the handler succeeded.

Fixes: 687db6ff5b70 ("iwlwifi: scan: make new scan req versioning flow")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://msgid.link/20240415114847.5e2d602b3190.I4c4931021be74a67a869384c8f8ee7463e0c7857@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 3cbe2c0b8d6bc..03ec900a33433 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2819,7 +2819,8 @@ static int iwl_mvm_build_scan_cmd(struct iwl_mvm *mvm,
 		if (ver_handler->version != scan_ver)
 			continue;
 
-		return ver_handler->handler(mvm, vif, params, type, uid);
+		err = ver_handler->handler(mvm, vif, params, type, uid);
+		return err ? : uid;
 	}
 
 	err = iwl_mvm_scan_umac(mvm, vif, params, type, uid);
-- 
2.43.0



