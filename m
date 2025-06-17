Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54132FA622;
	Tue, 17 Jun 2025 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179086; cv=none; b=VCOepVkG25V3Jsye/iLKgaaFEpyfd4KNxcYN9tMoe/BVBGi+ivYe+tM9COHp9bR/xH76nZ4XTXcn/oOcy+DPau+Gp/L91aIdWHqL1/KXlFrWZGA+AirETIWrnH8wIWGziREtcOkFW6eLgiDBWzjBqmPmCiREu1EilycIv+nrGV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179086; c=relaxed/simple;
	bh=7sQueLPaupOUTpFm5QXWFKcT9qHfIE7FAcTDrJ/ezMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/cajZro4XvomRWH/OtCzJ+cUsHsuCL6UgF6AgBcLjWl1544ip8hSklCNaYLa4YXe+JEQT8B7QiPlU+IeiFKyg4/uhx+IZlJGAKNd3SA+1DZrDFknqNyfMP0iZyZ5l+fnlWHHsW0/9B2aPOAYA0iZc8DrgWbKrSNjSxZkVw4D6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5v5s7+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5v5s7+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C08C4CEE3;
	Tue, 17 Jun 2025 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179086;
	bh=7sQueLPaupOUTpFm5QXWFKcT9qHfIE7FAcTDrJ/ezMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5v5s7+BUQk3DkRlpjwLNTN9VWBNHb/Uwet01HKV6LCLDYgVVejQaUpYCLnfluwe3
	 qowtHDCVmax6/z7XYqk7rUYTTNM6C2KofywHLhxGA5TcNqNaF9WmOOzunrNp4xR2b/
	 dFwJdssWb3Cy9vLa0UZlNHHgdjcAA7kre+/Rc8vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 605/780] wifi: iwlwifi: mld: avoid panic on init failure
Date: Tue, 17 Jun 2025 17:25:13 +0200
Message-ID: <20250617152516.120811019@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 960c7e6d388034d219dafffa6da0a5c2ccd5ff30 ]

In case of an error during init, in_hw_restart will be set, but it will
never get cleared.
Instead, we will retry to init again, and then we will act like we are in a
restart when we are actually not.

This causes (among others) to a NULL pointer dereference when canceling
rx_omi::finished_work, that was not even initialized, because we thought
that we are in hw_restart.

Set in_hw_restart to true only if the fw is running, then we know that
FW was loaded successfully and we are not going to the retry loop.

Fixes: 7391b2a4f7db ("wifi: iwlwifi: rework firmware error handling")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250604061200.e0040e0a4b09.Iae469a0abe6bfa3c26d8a88c066bad75c2e8f121@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 73d2166a4c257..7a098942dc802 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -638,7 +638,8 @@ iwl_mld_nic_error(struct iwl_op_mode *op_mode,
 	 * It might not actually be true that we'll restart, but the
 	 * setting doesn't matter if we're going to be unbound either.
 	 */
-	if (type != IWL_ERR_TYPE_RESET_HS_TIMEOUT)
+	if (type != IWL_ERR_TYPE_RESET_HS_TIMEOUT &&
+	    mld->fw_status.running)
 		mld->fw_status.in_hw_restart = true;
 }
 
-- 
2.39.5



