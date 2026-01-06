Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F5F350D70;
	Tue,  6 Jan 2026 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720139; cv=none; b=gEUECnRqrrNuUKK2U86WeAZWZJH74yRqWvVlhZs5zqOXC3V2nh9TajBQ/CnImVXnNY0V+bb3LcCz9mhn4LoagGPZUpL21gfV7at5QBEjKgReRvBh6XoJH/aWQeQBVXTlbvjf0k/z2TfKvA5e3o4bp8C3M+5w5XAJZZlOv53dtQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720139; c=relaxed/simple;
	bh=x+sFpt3H/QVbKJEn0RMcXBbcg3BNFokP4v2kRLyvV0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D38ArKXAqfAmV3ofJjoVDgDjXkDODSWR7TIAQCdXBfQ9n8jdLLuhRtYCvStTtX20LhYnHJ/M6CKqcLfmMgOa1lMSz/CXyeNC5ZU48uktAxbplHAlGr49ErBLk0cquK7J+luYP1UyqtjkMhKr50Wlxe0iVeab6FEjwjgLHxRqSNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km/Oq7Mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km/Oq7Mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C180C116C6;
	Tue,  6 Jan 2026 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720139;
	bh=x+sFpt3H/QVbKJEn0RMcXBbcg3BNFokP4v2kRLyvV0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=km/Oq7MmUPXJ9sRuG8YRB8gMQI9eAB9VbEdr1EpO3J6SmrzX65/s2KG24x2VheskB
	 gVuDFbcEvjEKSCbBwXjAoEyc9WhmdQfbYYz/VDOSC7x1fGo1zKHkzRAgsr93f74YeA
	 STLpHc/aud6uCRBebgW/ctKuLDmZLggrB7NVs3BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Justin Tee <justintee8345@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/567] nvme-fabrics: add ENOKEY to no retry criteria for authentication failures
Date: Tue,  6 Jan 2026 17:58:48 +0100
Message-ID: <20260106170456.724053490@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Justin Tee <justintee8345@gmail.com>

[ Upstream commit 13989207ee29c40501e719512e8dc90768325895 ]

With authentication, in addition to EKEYREJECTED there is also no point in
retrying reconnects when status is ENOKEY.  Thus, add -ENOKEY as another
criteria to determine when to stop retries.

Cc: Daniel Wagner <wagi@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Closes: https://lore.kernel.org/linux-nvme/20250829-nvme-fc-sync-v3-0-d69c87e63aee@kernel.org/
Signed-off-by: Justin Tee <justintee8345@gmail.com>
Tested-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 432efcbf9e2f..2e47c56b2d4b 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -591,7 +591,7 @@ bool nvmf_should_reconnect(struct nvme_ctrl *ctrl, int status)
 	if (status > 0 && (status & NVME_STATUS_DNR))
 		return false;
 
-	if (status == -EKEYREJECTED)
+	if (status == -EKEYREJECTED || status == -ENOKEY)
 		return false;
 
 	if (ctrl->opts->max_reconnects == -1 ||
-- 
2.51.0



