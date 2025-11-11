Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48E255F28;
	Tue, 11 Nov 2025 01:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824897; cv=none; b=loH5AJ6lzaE1pyW+qUlJqxsBh5atHrKeKQmAwV0HVLcUUSkK+OhB7P/CPw81jl0YUkrpEhe8gKVTXKe9irpud5iQ8TBcRo8bFZq2bzAFgER6QQpX+tVwPBiiJcjRO38Nqv/PgTwBh8Gnq7XAD9ZhW+4Eakz7lyyrWnxY36hSvTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824897; c=relaxed/simple;
	bh=ENbfdeINzxN9W8wckLs9F1Igw/x0vPRqnkPJ8347i8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBeqYWQueFJwXP34QyVTmp4h0e9YK+aKQmiUt2rSEQNmDDUTpjaZR7zSHEQDQxjIQcaPqovEMP8xC/9Gw7RBNqmhZOpHBGftkAlEdLGmyE+m6K7TkAl3pvi9GzA6cDyZ+VCJaed5UDEjm3uQR3mziY7H7qzSztt0cb4C8xjgx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k9YM2qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k9YM2qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E501C4CEF5;
	Tue, 11 Nov 2025 01:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824897;
	bh=ENbfdeINzxN9W8wckLs9F1Igw/x0vPRqnkPJ8347i8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2k9YM2qp51m5x7sBnQ9FaCRgzi5roilZyGiMvq0RajUmm8bOmwuophsSnCxgQvIvf
	 5FpEPoScki+/autGvkEYfHEcpoWVL6teevpAiqy9ylCWmrOSDq9x/7vBWnfSCpYTPN
	 pLGCMHMUaCtBbBHPZjfzYZYk7dUfWUo+ViIR3rvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 546/565] iommufd: Dont overflow during division for dirty tracking
Date: Tue, 11 Nov 2025 09:46:42 +0900
Message-ID: <20251111004539.275320944@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit cb30dfa75d55eced379a42fd67bd5fb7ec38555e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/iova_bitmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -130,9 +130,8 @@ struct iova_bitmap {
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


