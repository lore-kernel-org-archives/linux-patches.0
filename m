Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB851D5CE0;
	Fri, 17 Oct 2025 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714184; cv=none; b=SRKgwRqJTK6BdMuekl5rJtTZuB6HzIuvv3Qc6UzpLX54g7x5vUjGqJOvDojDmk74Oe+XM1QLZczhy1mufpAneAsVfCPc759si/FC/zIqHLCzaU4ZYcyLVCDezbDCe1KMZuoj0Asg00w0S1SIHXURN8SrtyRFxfHenROpvqT8cAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714184; c=relaxed/simple;
	bh=jkQnQLqC9lBrrKnHylJ7OmwcTDjm0wLdxr2y78mnXzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSg8Wf6hwKY7dPt76yCRFOO/rWiln1BeHzHT8qkTCkRzLdilrert3i4iI7Pnc1vHdA+EDXPtv+cprNvqYcJwmeRV05qRf5/6MccuuigwF4kD+Uz265TIIuR4lvh1y78MGjuivA9Ii25L/e8A4t5+NY4p6xy4LNEeVFcMfggvRBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QDm6RM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QDm6RM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC138C4CEE7;
	Fri, 17 Oct 2025 15:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714184;
	bh=jkQnQLqC9lBrrKnHylJ7OmwcTDjm0wLdxr2y78mnXzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QDm6RM9DKNXVewfsCQ2KXFQv17mxLRREZvpgx1DH7eRD66vWM6MA03hcyQ/ZTw5c
	 Mub4PmuE7kibbJzTSEXKNN0ibiA9XbswaDrg6EK2W6cFuzNfOUii2nEva3OS4LnxWy
	 9duoeJLnxJGKhujDSXFZKm9KLSNlHwY54UHMEOwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/277] ice: ice_adapter: release xa entry on adapter allocation failure
Date: Fri, 17 Oct 2025 16:51:03 +0200
Message-ID: <20251017145149.191065190@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2db687f3469dbc5c59bc53d55acafd75d530b497 ]

When ice_adapter_new() fails, the reserved XArray entry created by
xa_insert() is not released. This causes subsequent insertions at
the same index to return -EBUSY, potentially leading to
NULL pointer dereferences.

Reorder the operations as suggested by Przemek Kitszel:
1. Check if adapter already exists (xa_load)
2. Reserve the XArray slot (xa_reserve)
3. Allocate the adapter (ice_adapter_new)
4. Store the adapter (xa_store)

Fixes: 0f0023c649c7 ("ice: do not init struct ice_adapter more times than needed")
Suggested-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Suggested-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251001115336.1707-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adapter.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adapter.c b/drivers/net/ethernet/intel/ice/ice_adapter.c
index 10285995c9edd..cc4798026182e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.c
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.c
@@ -98,19 +98,21 @@ struct ice_adapter *ice_adapter_get(struct pci_dev *pdev)
 
 	index = ice_adapter_xa_index(pdev);
 	scoped_guard(mutex, &ice_adapters_mutex) {
-		err = xa_insert(&ice_adapters, index, NULL, GFP_KERNEL);
-		if (err == -EBUSY) {
-			adapter = xa_load(&ice_adapters, index);
+		adapter = xa_load(&ice_adapters, index);
+		if (adapter) {
 			refcount_inc(&adapter->refcount);
 			WARN_ON_ONCE(adapter->index != ice_adapter_index(pdev));
 			return adapter;
 		}
+		err = xa_reserve(&ice_adapters, index, GFP_KERNEL);
 		if (err)
 			return ERR_PTR(err);
 
 		adapter = ice_adapter_new(pdev);
-		if (!adapter)
+		if (!adapter) {
+			xa_release(&ice_adapters, index);
 			return ERR_PTR(-ENOMEM);
+		}
 		xa_store(&ice_adapters, index, adapter, GFP_KERNEL);
 	}
 	return adapter;
-- 
2.51.0



