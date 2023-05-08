Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1098168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38813C433EF;
	Mon,  8 May 2023 11:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544488;
	bh=nLdePqh2bTqCnlpaPt1P2wcp/nv/2C4fsrBJyidy/Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ig+stVdiiPx3Jh1RdxNiG3ZWDnVm7PwPaJRrTz34p7PiN50j2K5fxowoW7zgQvHi+
	 D3JdCeP5FJShcFH/AikREtaaoAGUL27XYUQ3+rc3kshbCPZnVglwJo1wZxKAPO2HbZ
	 dF6gb7KugRlt1TbUicIX2g83fUgEfyFvzGvMcEMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 427/694] wifi: iwlwifi: fw: move memset before early return
Date: Mon,  8 May 2023 11:44:22 +0200
Message-Id: <20230508094447.202789839@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

[ Upstream commit 8ce437dd5b2e4adef13aa4ecce07392f9966b1ab ]

Clang static analysis reports this representative issue
dbg.c:1455:6: warning: Branch condition evaluates to
a garbage value
  if (!rxf_data.size)
       ^~~~~~~~~~~~~~

This check depends on iwl_ini_get_rxf_data() to clear
rxf_data but the function can return early without
doing the clear.  So move the memset before the early
return.

Fixes: cc9b6012d34b ("iwlwifi: yoyo: use hweight_long instead of bit manipulating")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230414130637.872a7175f1ff.I33802a77a91998276992b088fbe25f61c87c33ac@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index bde6f0764a538..027360e63b926 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1388,13 +1388,13 @@ static void iwl_ini_get_rxf_data(struct iwl_fw_runtime *fwrt,
 	if (!data)
 		return;
 
+	memset(data, 0, sizeof(*data));
+
 	/* make sure only one bit is set in only one fid */
 	if (WARN_ONCE(hweight_long(fid1) + hweight_long(fid2) != 1,
 		      "fid1=%x, fid2=%x\n", fid1, fid2))
 		return;
 
-	memset(data, 0, sizeof(*data));
-
 	if (fid1) {
 		fifo_idx = ffs(fid1) - 1;
 		if (WARN_ONCE(fifo_idx >= MAX_NUM_LMAC, "fifo_idx=%d\n",
-- 
2.39.2



