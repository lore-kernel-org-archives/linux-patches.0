Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C047D4C7F;
	Mon, 23 Jun 2025 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685123; cv=none; b=a8RRjg7zmqayfSxAWxnAFlmJZpP+neK1OqgLh131m5eElPx+hqDJ9HzUYIj9k8bXebH3KvkZbqmXEM2pINy3Lm4oVEBz0F1xDJA7po/4lu+K011zeKFecrltj8eVc4aMQfKr2P7OY+QnFxuzCsdnJ5u8by2loBkAtgPuRqoN/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685123; c=relaxed/simple;
	bh=KW8I/pQSGBvaifvhHgx4vYFlIxFgxBv9BsUw5kParSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5q4w21urmRw4Bcp9nnKV/3k+jq/wBr+KEClR/uEvIyaTF4fPhenaO/FMxLX3de3SKS81aJ3qtZl8f0ohJGTYkLsX81SaBMGTr45XzQGC/+fR79Li3oUmBVYJXGL9pRfqAksaJ7fcinphio4HMhPYOg8pw8HpdftvFXlEfmwKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETeJrPeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETeJrPeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EB8C4CEEA;
	Mon, 23 Jun 2025 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685123;
	bh=KW8I/pQSGBvaifvhHgx4vYFlIxFgxBv9BsUw5kParSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETeJrPeZggbXnBZreK14aYCJkiaExg0+wZU/Y/aY2RvgyvOROdYcnYGepg55Lq1+u
	 HdNrLn1A8KYomdDgyMnYZZD2xOFywhFIYyUFkm2sd+HkZaaqSaTjIvjpGW1PbpNBfp
	 gAc+J9+jrrcmRqpji4iSIyTd0RhWN22zJ69vrEp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gavin Shan <gshan@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/355] firmware: psci: Fix refcount leak in psci_dt_init
Date: Mon, 23 Jun 2025 15:03:49 +0200
Message-ID: <20250623130627.657033290@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7ff37d29fd5c27617b9767e1b8946d115cf93a1e ]

Fix a reference counter leak in psci_dt_init() where of_node_put(np) was
missing after of_find_matching_node_and_match() when np is unavailable.

Fixes: d09a0011ec0d ("drivers: psci: Allow PSCI node to be disabled")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250318151712.28763-1-linmq006@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/psci/psci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 00af99b6f97c1..2c435a8d35487 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -571,8 +571,10 @@ int __init psci_dt_init(void)
 
 	np = of_find_matching_node_and_match(NULL, psci_of_match, &matched_np);
 
-	if (!np || !of_device_is_available(np))
+	if (!np || !of_device_is_available(np)) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	init_fn = (psci_initcall_t)matched_np->data;
 	ret = init_fn(np);
-- 
2.39.5



