Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2502D3AFB07;
	Sat, 17 Oct 2026 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258075; cv=none; b=FCQh6d2vK1ZyFZ49wjP4u7n5969wpryVbVsO73hcypnXd472H9IcdFKTmzj5v2MCpHnX3JzirTUslmWDtKdDwUDy4D3+4C1Zb5S8JGoFzp/RjgqQaWqpI/LNHPhc4Cdm5RuCVTVW8HNneqOcJL3k2nOFy/n5hSBlH85d/juInzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258075; c=relaxed/simple;
	bh=iqSIBgx7zqYHun1oZOiaYGnyF+JPP87hc5bbAqt/N/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po8zJB+7QpB8ckhbELAHAXREQx93d7QnBmRP+hl9johAteWYpeBnhwFSRW1QS7hgrU6s09ZiesiNIpxhQfQ0Bmn7PZsF/mf974ELfsGTrfNaQ5jY7dm8sgYyc9pR5lJ/ovH+p1d7ocQYg/TYQvpoP0pNK/Gv8nbd01xDDNg2UoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTT3rkdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTT3rkdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11241F000C4;
	Sat, 17 Oct 2026 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258072;
	bh=bfwSkoZQwLgYaIp3UeCYNCeIhINQIpPxgqFd3t5aU1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTT3rkdqznH51cUZPVRqgKMjRfdBTc4qTQJ6+P2dtbDK6zH/OB20+/yG6F4Y544jw
	 gVODwHnSGiWfV7zuE0mx6IrnoEcHD8kLqUfJraWcq1oJ6wL6P13Qnk8DhANunPb3Sn
	 pNdN2fBPp2DYXYVxT75Qh4ADBgysBgIF9F+pboaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0764/1674] wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()
Date: Sat, 17 Oct 2026 17:50:36 +0200
Message-ID: <20261017160450.711752894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cf80c02a9fdb6c5bc8508beb6a0f6a1294fc32f6 ]

Preserve the error code if iwl_setup_deferred_work() fails.  The current
code returns ERR_PTR(0) (which is NULL) on this path.  I believe the
missing error code potentially leads to a use after free involving
debugfs.

Fixes: 90a0d9f33996 ("iwlwifi: Add missing check for alloc_ordered_workqueue")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/a7a1cd2c-ce01-461a-9afd-dbe535f8df01@sabinyo.mountain
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 1d6b4a0313a45..447870f610e9c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1470,7 +1470,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/********************
 	 * 6. Setup services
 	 ********************/
-	if (iwl_setup_deferred_work(priv))
+	err = iwl_setup_deferred_work(priv);
+	if (err)
 		goto out_uninit_drv;
 
 	iwl_setup_rx_handlers(priv);
-- 
2.53.0



