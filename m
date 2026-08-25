Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701294457CD;
	Tue, 25 Aug 2026 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665042; cv=none; b=InTKgCxgyEKvB9k0c6gK9Jo4tMSD4mmWPNaHfcCUdwVQv86tQRoVHJ/Aq6qvLRPRmmFFQKpjM58etStkhcW8CNWo6Ty80JtkNHSHElj3RgTgxsR+hHrmU6FmUdf2F+4chzmFE+FwoK08kD8cSZqC7LNty/y9ulsusYA8C5WnU5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665042; c=relaxed/simple;
	bh=GZnsZh9WSjzqfMT/oa8xZmLX1zz6p1BzZ/LmvHO7YFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqlYHQZ6M86T6h6drmPiO4oQRB8j/Z2NTr8ScRaECjH24pSrgCNgdZIParBFIERMLJ61+6KJZyHe/1lq30UYZ/VfkMyegp1saBHWAMdaccpBkcaZvcR5Va3M7CW95M1SsNxbTjiLECZKA2ke4RnVpxAsq9EaolIIAOwerKBS2Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bpas+Tpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bpas+Tpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907251F000E9;
	Tue, 25 Aug 2026 13:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665041;
	bh=d1Ha7rMIaifAcHuQ9HXX5XLvvvQ1sE70z/uuXyNGtSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bpas+Tpbv41dFhF5lJsD0XgbFEWIJq/g+FXqT/ULpsvqjSqcLCn0T4uiajBoOUC0k
	 Ex91SxF5LY4pC4u0NFRpMuIDrhhFURt6g02qKZkD9zBJ4aN7fWd770gNJo2UUM17Gz
	 TOK3PpBXr3K2AliJHavYF674IFdt1KX6FKtwtEZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.1 051/101] mailbox: mchp-ipc-sbi: Add null check for devm_kasprintf()
Date: Tue, 25 Aug 2026 15:25:29 +0200
Message-ID: <20260825132544.011426394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit b37c4d0a2fd90c0c31223acd37f763eb8953ed1a upstream.

Add a check to see if devm_kasprintf() is not NULL in
mchp_ipc_get_cluster_aggr_irq(), returning -ENOMEM if the function
failed.

Assisted-by: gkh_clanker_t1000
CC: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/mailbox-mchp-ipc-sbi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mailbox/mailbox-mchp-ipc-sbi.c
+++ b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
@@ -378,6 +378,8 @@ static int mchp_ipc_get_cluster_aggr_irq
 	for_each_online_cpu(cpuid) {
 		hartid = cpuid_to_hartid_map(cpuid);
 		irq_name = devm_kasprintf(ipc->dev, GFP_KERNEL, "hart-%lu", hartid);
+		if (!irq_name)
+			return -ENOMEM;
 		ret = platform_get_irq_byname_optional(pdev, irq_name);
 		if (ret <= 0)
 			continue;


