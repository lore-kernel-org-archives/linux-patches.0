Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69E146AA80;
	Tue, 21 Jul 2026 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648364; cv=none; b=a4/uuUoovQiUEdkscXBfoOvrHef7/UnxLZVLROqXP35Bt5Z2wjwFjLBDJZuxa6a3QUJCiRsg5NnMJPfPMBKwQf12v5kyO0gurpVX1M43yZku8NpGgwamlZqIQElBYzkxDIBPCRVx5CbxVsuPVJJpc25RyAmhMZRvEOBWLtDtbRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648364; c=relaxed/simple;
	bh=0N6qUggegRDtX6B6RXaKUL3LC1clleSzobbGasmSBzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf1oooZrYKyzi9TAg4Pca3fl8STf3vvjma+AKvml10wjWni3gpurVsPifwAVGEp1ME4kKPVK94Z09b97Z9tbZ80/CCyLM21ySkfU0Y17KAynYZAu6TXOp9iGSBbxgggMEyQAEyafVyq1G0nGsg+8GGFXWoDJ0hQ2LVf5qgbLlUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3BduZgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3BduZgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF831F000E9;
	Tue, 21 Jul 2026 15:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648362;
	bh=rZqz0HGjq9sIpB8+SPUJuHyGkHRhrCDXxXkUYk77LSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3BduZgG0/ThQdvCdv8Xy5d2GOyKvb+Bj3tJjlH01VT+L1LuvgH7X6nGeAQwaXlT7
	 rXArxdxtJnT4EFd1ePPI8vPFAS+zFAPt2LMcZqpivAsAyeVZemMhRErXaOd6dXM5m5
	 ywUpXPMUk7mFcJqN6EBHeqXdU2zbiuPJCNd3/yUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0169/2077] accel/amdxdna: Fix clflush buffer size
Date: Tue, 21 Jul 2026 16:57:22 +0200
Message-ID: <20260721152556.677001646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit ada61841caede131cc626f6cd28a60904296f248 ]

The firmware is told the buffer is req.buf_size bytes. It may read/write
the entire region. If the CPU only flushes a subset, the remaining cache
lines could contain stale data, causing the device to see garbage.

Fixes: 6e87001fe19f ("accel/amdxdna: Adjust size for copy_to_user()")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260507040207.178111-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_message.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index 0a619e55902b58..30289680660646 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -390,7 +390,7 @@ int aie2_query_status(struct amdxdna_dev_hdl *ndev, char __user *buf,
 	req.num_cols = hweight32(aie_bitmap);
 	req.aie_bitmap = aie_bitmap;
 
-	drm_clflush_virt_range(buff_addr, size); /* device can access */
+	drm_clflush_virt_range(buff_addr, req.dump_buff_size); /* device can access */
 	ret = aie_send_mgmt_msg_wait(&ndev->aie, &msg);
 	if (ret) {
 		XDNA_ERR(xdna, "Error during NPU query, status %d", ret);
@@ -442,7 +442,7 @@ int aie2_query_telemetry(struct amdxdna_dev_hdl *ndev,
 	req.buf_size = buf_sz;
 	req.type = header->type;
 
-	drm_clflush_virt_range(addr, size); /* device can access */
+	drm_clflush_virt_range(addr, req.buf_size); /* device can access */
 	ret = aie_send_mgmt_msg_wait(&ndev->aie, &msg);
 	if (ret) {
 		XDNA_ERR(xdna, "Query telemetry failed, status %d", ret);
@@ -1186,7 +1186,7 @@ int aie2_query_app_health(struct amdxdna_dev_hdl *ndev, u32 context_id,
 	req.context_id = context_id;
 	req.buf_size = buf_size;
 
-	drm_clflush_virt_range(buf, sizeof(*report));
+	drm_clflush_virt_range(buf, req.buf_size);
 	ret = aie_send_mgmt_msg_wait(&ndev->aie, &msg);
 	if (ret) {
 		XDNA_ERR(xdna, "Get app health failed, ret %d status 0x%x", ret, resp.status);
-- 
2.53.0



