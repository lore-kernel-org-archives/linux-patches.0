Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE8327FD76;
	Tue,  6 Jan 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721911; cv=none; b=bj09RfUS4mSmJoaUCu/OKXiW9ydoEfTztCMcqZdavaYMYLHuTMZqHc+49lKlhy5Bx/n1qfqPq1Sf2ku+QECc184gp//3RUJoGLGb8GeOEIMcXFnJA204vqvPaVZ9b24q+nSM+5ZLKxqokW0dh38YZPhdGghAIdNegI7H6BHguQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721911; c=relaxed/simple;
	bh=tIaNnqo3B9LA6GciclTAb/oFmk5583TJESCSCjtHs9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIWOyFUxOw0nhYRWf8U4qoHayyTWlOXbGUNCiebWwqrG85OE+9dgJeDH2RcCcR9Qdx0F+HsTBa/dMl99mQbN1+xbUsxZJhWuxkOaQEXYjMhDqFUlKilC23l4xRJDbgyxpYeZ1FjS0ahML6E+ELncYD067GvpG7PYXb0/HYY5Hg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndSZOmrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndSZOmrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A971C116C6;
	Tue,  6 Jan 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721910;
	bh=tIaNnqo3B9LA6GciclTAb/oFmk5583TJESCSCjtHs9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndSZOmrQ84YRhQWWtufliL9+ujeXs27H/7pmGfnGncv7GDMfSS7LA11b39iHwbn9/
	 mAgqDRu0fudfi82/MXltu0yCc+ZOqg1YdwLl98yKniDBXScrkgosNVZbLZu2rbT5b2
	 GYjdUsxuHf5m5af5XbwWPa9VpFzYuGCYjQBW+Ej8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 108/312] iommu/amd: Fix pci_segment memleak in alloc_pci_segment()
Date: Tue,  6 Jan 2026 18:03:02 +0100
Message-ID: <20260106170551.744408958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

commit 75ba146c2674ba49ed8a222c67f9abfb4a4f2a4f upstream.

Fix a memory leak of struct amd_iommu_pci_segment in alloc_pci_segment()
when system memory (or contiguous memory) is insufficient.

Fixes: 04230c119930 ("iommu/amd: Introduce per PCI segment device table")
Fixes: eda797a27795 ("iommu/amd: Introduce per PCI segment rlookup table")
Fixes: 99fc4ac3d297 ("iommu/amd: Introduce per PCI segment alias_table")
Cc: stable@vger.kernel.org
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1731,13 +1731,22 @@ static struct amd_iommu_pci_seg *__init
 	list_add_tail(&pci_seg->list, &amd_iommu_pci_seg_list);
 
 	if (alloc_dev_table(pci_seg))
-		return NULL;
+		goto err_free_pci_seg;
 	if (alloc_alias_table(pci_seg))
-		return NULL;
+		goto err_free_dev_table;
 	if (alloc_rlookup_table(pci_seg))
-		return NULL;
+		goto err_free_alias_table;
 
 	return pci_seg;
+
+err_free_alias_table:
+	free_alias_table(pci_seg);
+err_free_dev_table:
+	free_dev_table(pci_seg);
+err_free_pci_seg:
+	list_del(&pci_seg->list);
+	kfree(pci_seg);
+	return NULL;
 }
 
 static struct amd_iommu_pci_seg *__init get_pci_segment(u16 id,


