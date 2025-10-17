Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFE6346A11;
	Fri, 17 Oct 2025 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715162; cv=none; b=SmZMx9Xln/5FFTIucc54VOtZYnpm4rdErbYareWjQtmXZ5vXVmQBoC812vr9zm+ZdWe7ObB0VzrqYTcQY4jJR+FJabdtQewA1GrSKGH/Dcux2GJubwudNrAJXyuB48cLXTOLCHDWpgkMrG7A1/+tjXvCls9sZ0juxRi0TorpoJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715162; c=relaxed/simple;
	bh=nEWVG1URKY+VvFx0KZQdN703roa3GVTZ2Akyq2bTKOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgWW4P4AHjGy/buxVcdkE5WfMW9z8tt3+zy07LA3U14zmOVKzmdW5jU9zkXKFWnsBEBhfJvW8b30LLhXBTXf5Ns6i+dFcuu7ea4IFzijp1l2hqQTT5KSm5nvBzO0b7ZVwAUcgj3P8uUntrGgDTe73RJNbxcxH0mvx8Ckrobiaaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTDKYYDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTDKYYDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A08C113D0;
	Fri, 17 Oct 2025 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715162;
	bh=nEWVG1URKY+VvFx0KZQdN703roa3GVTZ2Akyq2bTKOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTDKYYDhTHkTUpE0DQWQ8FHJdx3O4z2zBZjgDdlR9k724Ik2JfLdhGzhJkEEvEIUv
	 DXFOZQP+224U3y0eizSozPXrBsovfotC4IqFWv55pOMsRhOV0oIyt9dVb7krQuHQRb
	 Ba1MxtkSLKTEvg0NgXtCOggapU7ChxTqbH7rQaig=
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
Subject: [PATCH 6.17 092/371] ice: ice_adapter: release xa entry on adapter allocation failure
Date: Fri, 17 Oct 2025 16:51:07 +0200
Message-ID: <20251017145205.267352810@linuxfoundation.org>
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
index b53561c347082..0a8a48cd4bce6 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.c
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.c
@@ -99,19 +99,21 @@ struct ice_adapter *ice_adapter_get(struct pci_dev *pdev)
 
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



