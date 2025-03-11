Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EC07E110;
	Tue, 11 Mar 2025 15:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706330; cv=none; b=hKBn9eH4W3sHLZInWAbZDuxYc1TCQ2x59SUq+/atgX+CKx4IgV1cLC7IiQNl3YmAYCyBym5+TTDqxhsVoMmaAmyaJavqimbwd8E5NzjlxfsAK7JW91fIBMu6X6YicGW2BqMLQSGAh7lPIktTVmdA/mbXeQ5SVDaLwMjgqk/BI+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706330; c=relaxed/simple;
	bh=9Sp66qqSj87YJxVUaX1BNghqUtoBraaHgIFZKrjsIbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CC7//BDJlYrk0TX6lITTWWIAEXjV/Liw36Zl4fR/tmSfs2S8RDqQkhfB45Rft+3tInOKRPnziTFDqBbxwiP7QByZnqNxT8W3BpHTPDR78cDxYyMGX9aysdQLoRZ7Sk3JaDe0zG+0pC9mcrSwpP4Iv+cZ7d1k3WdzR1RaCM2affQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnatuViV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnatuViV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF52BC4CEE9;
	Tue, 11 Mar 2025 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706330;
	bh=9Sp66qqSj87YJxVUaX1BNghqUtoBraaHgIFZKrjsIbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnatuViVldHB9GIDXBWsCIaK+AsvrW244KFH86Udvz+j6axHfYHdw3+m1buiDI4Bh
	 4MeW6NF/18xgNjBN6STFS0EpcU15DgL5Hia2oUvDn2TIknqlUdwZqYam6z7IS+bNbd
	 +hpD5dz3TJftaZREv4U/g1PkoSQDAAV1yCLdtvGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/462] nvme: Add error check for xa_store in nvme_get_effects_log
Date: Tue, 11 Mar 2025 15:54:30 +0100
Message-ID: <20250311145758.525207463@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit ac32057acc7f3d7a238dafaa9b2aa2bc9750080e ]

The xa_store() may fail due to memory allocation failure because there
is no guarantee that the index csi is already used. This fix adds an
error check of the return value of xa_store() in nvme_get_effects_log().

Fixes: 1cf7a12e09aa ("nvme: use an xarray to lookup the Commands Supported and Effects log")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c739ac1761ba6..f988a5e3f0e15 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3043,7 +3043,7 @@ int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
 static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 				struct nvme_effects_log **log)
 {
-	struct nvme_effects_log	*cel = xa_load(&ctrl->cels, csi);
+	struct nvme_effects_log *old, *cel = xa_load(&ctrl->cels, csi);
 	int ret;
 
 	if (cel)
@@ -3060,7 +3060,11 @@ static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 		return ret;
 	}
 
-	xa_store(&ctrl->cels, csi, cel, GFP_KERNEL);
+	old = xa_store(&ctrl->cels, csi, cel, GFP_KERNEL);
+	if (xa_is_err(old)) {
+		kfree(cel);
+		return xa_err(old);
+	}
 out:
 	*log = cel;
 	return 0;
-- 
2.39.5



