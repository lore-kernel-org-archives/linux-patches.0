Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B768C1C4EE6;
	Tue, 27 Aug 2024 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770066; cv=none; b=KSYqPoJkaW5Td3uH+Bu/dFGgYzSD3rdogvs7f+VDT7Vj72K9MeBXEoX0V1qUiXAMlTw+SgfwgT55Igv0EyDA8bVCjoshfktQrnUY811P3KaxknibJ1GIaXNX6BUow7XJvLh6Wf9nJP0FLaypMiJvEwGXtRpoZhEnE6q/8xEcITg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770066; c=relaxed/simple;
	bh=Bj1TaO+o2I/2EYlab2dQbuHC82VEErgFoJNuyipXrW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvJT/vcw5RT9DQVx5VoLD+S2vkaAi+DwMCME6BPtPUcbe3lrVskRs89kCFkSCEGh94p60+yeuHRuIHetgNpWZKL09lHeBICnzQYef3O7kOH+EW91T8aVIROamGRJagZm7gxLtr//4getekCifr17/1M0LYOaWCXjdw4MNWBtxPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyhHQ2as; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyhHQ2as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24799C61040;
	Tue, 27 Aug 2024 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770066;
	bh=Bj1TaO+o2I/2EYlab2dQbuHC82VEErgFoJNuyipXrW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyhHQ2as/mfTKxMpjnzJ6KsqHOC1YOUS1sngfhmODZOK2e0VZLkvqZW77m6eplgm8
	 guM97U4kICiOgpOaZlwRPaS03W0sEAzgMB5Z3cLaedx2M9jk9bENn21pRSLnjgOvO4
	 rqYn8X3JapjUTLVTgfu0i1ryHvRFKL5k5MhKa70k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Tayar <ttayar@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/341] accel/habanalabs: export dma-buf only if size/offset multiples of PAGE_SIZE
Date: Tue, 27 Aug 2024 16:35:47 +0200
Message-ID: <20240827143847.828564806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit 0b75cb5b240fddf181c284d415ee77ef61b418d6 ]

It is currently allowed for a user to export dma-buf with size and
offset that are not multiples of PAGE_SIZE.
The exported memory is mapped for the importer device, and there it will
be rounded to PAGE_SIZE, leading to actually exporting more than the
user intended to.
To make the user be aware of it, accept only size and offset which are
multiple of PAGE_SIZE.

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/memory.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 4fc72a07d2f59..5b7d9a351133f 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -1878,16 +1878,16 @@ static int export_dmabuf(struct hl_ctx *ctx,
 
 static int validate_export_params_common(struct hl_device *hdev, u64 device_addr, u64 size)
 {
-	if (!IS_ALIGNED(device_addr, PAGE_SIZE)) {
+	if (!PAGE_ALIGNED(device_addr)) {
 		dev_dbg(hdev->dev,
-			"exported device memory address 0x%llx should be aligned to 0x%lx\n",
+			"exported device memory address 0x%llx should be aligned to PAGE_SIZE 0x%lx\n",
 			device_addr, PAGE_SIZE);
 		return -EINVAL;
 	}
 
-	if (size < PAGE_SIZE) {
+	if (!size || !PAGE_ALIGNED(size)) {
 		dev_dbg(hdev->dev,
-			"exported device memory size %llu should be equal to or greater than %lu\n",
+			"exported device memory size %llu should be a multiple of PAGE_SIZE %lu\n",
 			size, PAGE_SIZE);
 		return -EINVAL;
 	}
@@ -1938,6 +1938,13 @@ static int validate_export_params(struct hl_device *hdev, u64 device_addr, u64 s
 	if (rc)
 		return rc;
 
+	if (!PAGE_ALIGNED(offset)) {
+		dev_dbg(hdev->dev,
+			"exported device memory offset %llu should be a multiple of PAGE_SIZE %lu\n",
+			offset, PAGE_SIZE);
+		return -EINVAL;
+	}
+
 	if ((offset + size) > phys_pg_pack->total_size) {
 		dev_dbg(hdev->dev, "offset %#llx and size %#llx exceed total map size %#llx\n",
 				offset, size, phys_pg_pack->total_size);
-- 
2.43.0



