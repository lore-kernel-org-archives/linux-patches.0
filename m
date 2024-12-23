Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447221B4140;
	Mon, 23 Dec 2024 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970514; cv=none; b=tIQ8OCEVFdEGb/LSM1yIUYmH+eb33CyTrMve17zMcHuEviUzkeObJWq+uCED+Uz3fdOD5T+lnZBT/phEOnIVF1ldyMIq8rmjouF3j95TPbw/6oNvxZZg6CFCAyI3M9rM8kJsKTJ0P0zVrn1EI3F/7aqA8DYtIj1VZCV1JYxMF68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970514; c=relaxed/simple;
	bh=75WE1c2zJRnbXn4re1N3YxuC0iTF5GS4OfBj+QSY8pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNNRqJgyMPUmJamsSj1DuGlPODCbozvXPchpN8V5Iph4hZ7Wyv0MlTG3kzXnNPllw9lInBkB0n7nbxAWe9S0dg5EVXgoRQtSdUyk6D1HuU/aZvSzPznt1IH/PLNoCZ1rnLVEQ50GHl4TWxTUbgQfVhvKaPxlVOnjsRhXfXW0KBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xz7FKgSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xz7FKgSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92899C4CED3;
	Mon, 23 Dec 2024 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970514;
	bh=75WE1c2zJRnbXn4re1N3YxuC0iTF5GS4OfBj+QSY8pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xz7FKgSGRjRiSL6K0XR/PGzZpV7bsa+RpkXNdrpoo6Zgjme75fdWqNZZxXrvCyXd2
	 wyhgTFtRrp366QGVHqUQX/R1RuLqCUJbDmpaZVzMHsI2jcwyg0CrnNwQCv0/Lvy7Lh
	 LXxa8M55uvg5BIcmf1PwOiS6quN/SnkKwsNnGyuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 106/116] of: Fix refcount leakage for OF node returned by __of_get_dma_parent()
Date: Mon, 23 Dec 2024 16:59:36 +0100
Message-ID: <20241223155403.672840601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 5d009e024056ded20c5bb1583146b833b23bbd5a upstream.

__of_get_dma_parent() returns OF device node @args.np, but the node's
refcount is increased twice, by both of_parse_phandle_with_args() and
of_node_get(), so causes refcount leakage for the node.

Fix by directly returning the node got by of_parse_phandle_with_args().

Fixes: f83a6e5dea6c ("of: address: Add support for the parent DMA bus")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241206-of_core_fix-v1-4-dc28ed56bec3@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -653,7 +653,7 @@ struct device_node *__of_get_dma_parent(
 	if (ret < 0)
 		return of_get_parent(np);
 
-	return of_node_get(args.np);
+	return args.np;
 }
 #endif
 


