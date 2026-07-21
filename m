Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23C446AA75;
	Tue, 21 Jul 2026 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648070; cv=none; b=g/XvuY4JaOSWZjwfihNDXK8cq/wSjgM8ZhvA0SSkx5ZisK3jkKwJVG/MKdYIR26TkpW2JJolVMA3J+72LJWMnQuCULOVu2U+WaNgfIsIdh9jizzvePbLT+b9zrvZeha5Ya6ueEJ6oDhb81tKR3p3yYezohqLWh1L71tH3i1tFw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648070; c=relaxed/simple;
	bh=+csFapjREtovMwP/4CdZ3ouhU2unOqBm9T/OKhF/8xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUr9mtAyyvNpIuC1FVYqM0W+o/zUBVz7NBO3R1Rsf5Lm5rPrqG5rocU0s4NqQmte5TTBFLcTFQ22HQhC3nbaXXj+cNFu1f6OMXFKPb2BdnzM0s7Vwm5dlqn0cJDOZHJPmq8dEoVqHvF11VVAGNjJH9g7ISglBRMRGO35PUqShO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+4cvrrO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+4cvrrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C921F00A3A;
	Tue, 21 Jul 2026 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648068;
	bh=XGEGPDYmb9B8h11i7QZNLpn884vHLOf4qyhvy9AIp2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+4cvrrO61g7j+UhIfjAKrAukWTYOOQUL9MJ65Ef5EoP/X065FFAeAHZslJE0vSsi
	 FAgS2bANZy0YLTOC+RQcXbWCrVDadGFUVxp23gjSxuz2vh3wsxxKx0lcYPOdsD46st
	 egk7JsU5vZRo/FvHIKGU8nKqaBQE9Yva/o/HLqZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0060/2077] accel/amdxdna: Guard management mailbox channel cleanup against NULL pointer
Date: Tue, 21 Jul 2026 16:55:33 +0200
Message-ID: <20260721152554.109074871@linuxfoundation.org>
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

From: Max Zhen <max.zhen@amd.com>

[ Upstream commit 506255d46bdb93a281cf39e72abbca124f5c7a1b ]

The management mailbox channel cleanup helpers can be called from
error handling paths when mgmt_chann has already been destroyed.

Add NULL checks to xdna_mailbox_free_channel() and
xdna_mailbox_stop_channel() so the cleanup path safely returns instead
of dereferencing a NULL mailbox channel pointer.

Fixes: b87f920b9344 ("accel/amdxdna: Support hardware mailbox")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260416201106.1046072-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_mailbox.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index d3639a2ea23951..13c20bb3890c93 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -485,6 +485,9 @@ struct mailbox_channel *xdna_mailbox_alloc_channel(struct mailbox *mb)
 
 void xdna_mailbox_free_channel(struct mailbox_channel *mb_chann)
 {
+	if (!mb_chann)
+		return;
+
 	destroy_workqueue(mb_chann->work_q);
 	kfree(mb_chann);
 }
@@ -531,6 +534,9 @@ void xdna_mailbox_stop_channel(struct mailbox_channel *mb_chann)
 	struct mailbox_msg *mb_msg;
 	unsigned long msg_id;
 
+	if (!mb_chann)
+		return;
+
 	/* Disable an irq and wait. This might sleep. */
 	free_irq(mb_chann->msix_irq, mb_chann);
 
-- 
2.53.0



