Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC461DE4FA;
	Tue,  8 Oct 2024 12:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391834; cv=none; b=rZgQnT5xAMXj0vRGnA7PZP28uwo3hWxn/OG87ykmL4JfJqQFIFs25DFX778fu4ewcDAeoPHik/ppJ5VN/kILTwA2OwvIx5ww8JCV9woBKxR5pNeqaehbcKwm1RF+jtXNtnUcpEICRNxplCZkn5SatF4KEfcm1k6v9U0egbIBycA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391834; c=relaxed/simple;
	bh=NqequjglBlNml8Dd1qLLnmnNN7BkSxnr6Fvsy3iUQXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNAfj47/2PO2/gzpR4L7qc902nTUoIR2wJa6ATGxkXfk/MqyHyFeVDphRw83DPD2idUD5TRZowFqhHTjszFs1MkkCpI5EJ24z9YjM1U3xPoqZt3TpKjQ0jNcYe8uRJhsC3IxLYGGNYQXZmCd+MWVy/aGYqq0X5r2I4tlQgH73/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYmyNBAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYmyNBAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04966C4CEC7;
	Tue,  8 Oct 2024 12:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391834;
	bh=NqequjglBlNml8Dd1qLLnmnNN7BkSxnr6Fvsy3iUQXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYmyNBAFErigm2phW2WqNOnpAVduOQEpVH1v5SFe6WOeVzeLBCd7yyzvCRpc4J0Hx
	 P+4gNFdig86txzgEDNXSQakTlJyIgda5YP1p+wsU0JlaOkfi1k2y+yQdZ1Dp4RxmW+
	 xZrKa8YnTd+U8eiB8m4jRjhBrYY4QcKczrW4Y5As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 235/558] drm/amdgpu: add list empty check to avoid null pointer issue
Date: Tue,  8 Oct 2024 14:04:25 +0200
Message-ID: <20241008115711.592054898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 4416377ae1fdc41a90b665943152ccd7ff61d3c5 ]

Add list empty check to avoid null pointer issues in some corner cases.
- list_for_each_entry_safe()

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index 19158cc30f31f..43f3e72fb247a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -80,6 +80,9 @@ static void aca_banks_release(struct aca_banks *banks)
 {
 	struct aca_bank_node *node, *tmp;
 
+	if (list_empty(&banks->list))
+		return;
+
 	list_for_each_entry_safe(node, tmp, &banks->list, node) {
 		list_del(&node->node);
 		kvfree(node);
@@ -562,9 +565,13 @@ static void aca_error_fini(struct aca_error *aerr)
 	struct aca_bank_error *bank_error, *tmp;
 
 	mutex_lock(&aerr->lock);
+	if (list_empty(&aerr->list))
+		goto out_unlock;
+
 	list_for_each_entry_safe(bank_error, tmp, &aerr->list, node)
 		aca_bank_error_remove(aerr, bank_error);
 
+out_unlock:
 	mutex_destroy(&aerr->lock);
 }
 
@@ -680,6 +687,9 @@ static void aca_manager_fini(struct aca_handle_manager *mgr)
 {
 	struct aca_handle *handle, *tmp;
 
+	if (list_empty(&mgr->list))
+		return;
+
 	list_for_each_entry_safe(handle, tmp, &mgr->list, node)
 		amdgpu_aca_remove_handle(handle);
 }
-- 
2.43.0



