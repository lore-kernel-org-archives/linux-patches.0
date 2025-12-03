Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0801E31A077;
	Wed,  3 Dec 2025 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779973; cv=none; b=lU5bXq/qKkPqo0wKO3HYLwP7jGawK7HHTG1PfnBwnsg2zpcNPBeItJpk+vnhK/q1h9srZNX8nNC02UPsBqoqwuFGrAtWzqsTJ1+pRSCEMwWr76b7TuvlwLIUP1xGKtt/AjGsWo10YI4uxmNV9cpUI7+z5C4oIoji2jZ/LuzsLwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779973; c=relaxed/simple;
	bh=cQsQ4pdj2UYj4/AzU9PrQhJgYLYhTT4653IpQBgFIGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS0X/GIFegYQMlmts5KKrd7QwSdxh2SzF5vy1spb1CygNpCSUzOyXnXc3TC96fQQrkdIsbIOKOTlrGkhxJ40mReU+P+ALVif+Q4+Dv/TYqLp5s26yU7Ltvy9tTfyWSGkSlTZInCAMN4G3WhuAEJ+uLhdoGftwbzQUKwNuQai6yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WC+9S9PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WC+9S9PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF35C4CEF5;
	Wed,  3 Dec 2025 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779972;
	bh=cQsQ4pdj2UYj4/AzU9PrQhJgYLYhTT4653IpQBgFIGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WC+9S9PJ3MoZmiWmWRh2UtLgwhQ03GBXMWtRw2cNmVtllnDWXACnvTGWMTchDizD8
	 83TBCTD7Nc3eUb5s1gj9mGwwL8ASdqkckr4XDW/BUEmSOMJRFSx5mlndM1OE2N0IIm
	 2p6bWxOpc7UBjAZ3yaIJrVnQ3G4se9aYe/m664E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 416/568] iommufd: Dont overflow during division for dirty tracking
Date: Wed,  3 Dec 2025 16:26:58 +0100
Message-ID: <20251203152455.930939575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@ziepe.ca>

[ Upstream commit cb30dfa75d55eced379a42fd67bd5fb7ec38555e ]

If pgshift is 63 then BITS_PER_TYPE(*bitmap->bitmap) * pgsize will overflow
to 0 and this triggers divide by 0.

In this case the index should just be 0, so reorganize things to divide
by shift and avoid hitting any overflows.

Link: https://patch.msgid.link/r/0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=093a8a8b859472e6c257
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ drivers/iommu/iommufd/iova_bitmap.c => drivers/vfio/iova_bitmap.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/iova_bitmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -126,9 +126,8 @@ struct iova_bitmap {
 static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
 						 unsigned long iova)
 {
-	unsigned long pgsize = 1UL << bitmap->mapped.pgshift;
-
-	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
+	return (iova >> bitmap->mapped.pgshift) /
+	       BITS_PER_TYPE(*bitmap->bitmap);
 }
 
 /*


