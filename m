Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA23AF64D;
	Thu,  2 Jul 2026 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009531; cv=none; b=ukzlnHwTfVLVSXJGj+7xT825rWxAs7gthxGAK8wA4SaYWH70bF3euClBPCmv7gEbipeHFekEpHM4QU13YR+4Vwc1gxTk8fUl7PwlbDOAzQWo+cuZvOCCTO5J+MpTb28PxirjzXxCQp4s1GxgeMhIJQiXd0OwjZXIq3xgqMdra20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009531; c=relaxed/simple;
	bh=zJJA1EExlHPG9EX8rB8Xf8iQNsUZY0cm2Ok1xngCVwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvTD3liOZw62Rpf+55bgRQV/Br0TD41yfBrQDGx/t8XUL+KcLHIeOLZc3iJ72IoZRX7pE+5PGdNkr1xzqA6OGtXgbYXc2cQ9qz4AkKHeZW7zCUtOwA7g8JGCTPaTUe27UhIu3G/B/UXvLloi6WWPGzKKlH06CXMsh4u3Z72DsBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXDRq3iO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXDRq3iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80111F00A3D;
	Thu,  2 Jul 2026 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009526;
	bh=twJmT+Ln6DGAVfZuLhBM5ho5mgNAZX/nKf83ZFiTZm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXDRq3iOI+RKQ6uGQM6d8MgaDT7M0xcnUSyEGluMErKHP63GSSlx2jRiQqJbxz+BF
	 WtgEiZykKIQzb+Lv18wh8kxRTveQs6Z9tAC7Vj8MJ+tiLEaYkJA0JKCw/VxdVGnBWG
	 fP1jg44/GM/90DxzZ/7fpmse+ag/y9fuuw9R9oeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edwin Peer <edwin.peer@broadcom.com>,
	Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 84/96] bnxt_en: Modify bnxt_disable_int_sync() to be called more than once.
Date: Thu,  2 Jul 2026 18:20:16 +0200
Message-ID: <20260702155110.745104457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 38290e37297087f7ea3ef7904b8f185d77c42976 ]

In the event of a fatal firmware error, we want to disable IRQ early
in the recovery sequence.  This change will allow it to be called
safely again as part of the normal shutdown sequence.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d930276f2cdd ("bnxt_en: Fix NULL pointer dereference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4382,6 +4382,9 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
+	if (!bp->irq_tbl)
+		return;
+
 	atomic_inc(&bp->intr_sem);
 
 	bnxt_disable_int(bp);


