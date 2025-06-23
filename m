Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0311E87B;
	Mon, 23 Jun 2025 22:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716360; cv=none; b=O+xufbdC11h3ENieklUBJGDPLxTX99gaBIWIaCjMv9LfL1iR6Iq3e0fMYWWHpqSN5J5kM3QDpC6G59oE0miTUaUHff8cnRx6G9LhKftAqlxrx6vkGbxPiU9/2yTYhH+IEBzlP6kXexEL0LCkU+JeJtYBbX32L1kdxAVz9Ubsfxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716360; c=relaxed/simple;
	bh=q0c0vgEM0/I8rBTgE8M0XDVuOSJYDfu6TFmK0D0iKVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PszWOpNpjBkt/0xvZAestL7jfEVXbj4xC3bg5PCYNTHf3cUUUzkA97SxkCJ+NI/mjTOVEaa940bMxDj9cRNc6Uptx73HrJ+cUOlYMxCa1SxBGlBdJOGWEoqEz8cs9V8WZYGvlD48v46c0rtbwEx87DkU5Kws6N1s0pKflrqijRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilftOjXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilftOjXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9801C4CEEA;
	Mon, 23 Jun 2025 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716360;
	bh=q0c0vgEM0/I8rBTgE8M0XDVuOSJYDfu6TFmK0D0iKVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilftOjXWEp7/gi0sA7n9tNkdcxVArWGaRP/f6hMMnj8u/l2nX+AXrNUwX8eKefO8Z
	 L95tWRtgGFLEchlFs7EsZTZH3RDgLoq2ptScOPsKXnag04x07SBjbszLC1Y1snJvP+
	 pSrhI0UFEIcC3NdRf8YoZwayJDM30te1hxq7iueE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/414] iommu/amd: Ensure GA log notifier callbacks finish running before module unload
Date: Mon, 23 Jun 2025 15:06:23 +0200
Message-ID: <20250623130648.199096607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 94c721ea03c7078163f41dbaa101ac721ddac329 ]

Synchronize RCU when unregistering KVM's GA log notifier to ensure all
in-flight interrupt handlers complete before KVM-the module is unloaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250315031048.2374109-1-seanjc@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4428a9557f295..23e78a034da8f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -861,6 +861,14 @@ int amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
 {
 	iommu_ga_log_notifier = notifier;
 
+	/*
+	 * Ensure all in-flight IRQ handlers run to completion before returning
+	 * to the caller, e.g. to ensure module code isn't unloaded while it's
+	 * being executed in the IRQ handler.
+	 */
+	if (!notifier)
+		synchronize_rcu();
+
 	return 0;
 }
 EXPORT_SYMBOL(amd_iommu_register_ga_log_notifier);
-- 
2.39.5



