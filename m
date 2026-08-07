Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7845E3F4125;
	Fri,  7 Aug 2026 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115114; cv=none; b=WvK9228hyKBue9A6cHeDbISuUA7JZE5kOZKU15olvnk4zBszgCJkKBJxkm25dBzSLN+D/nscaVDVUEPwWQOB1YpyN5VzHBn/7P3LT7QrlPCl2H9AHc/UESAiBrRHzDxkHw1ICN896JhuiXtifdGPzi0FSB59YLOU2ihFfwj/1u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115114; c=relaxed/simple;
	bh=23/LGmvoIRrKCOl+Kxt4LW8Y6k5RCmV5/R6pJmDcm+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zki088sU69BSfOT1u3/R5F6qVgyOV6ZEUoR4sPWRzk/Ha5ba56Z8ahTl88aSEUvrB2pAYolAwqnYxeDmG7LtbMh/Ju2L9RdqW1z6a7dcXvLRTGapQGZq3qUkBwgYED5R6RXmp5OeAMImETy7Jsxjyg5AQyD0KyZQ61h1lqNUoCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMBe5+Bc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMBe5+Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D981F000E9;
	Fri,  7 Aug 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115113;
	bh=/2HKCoG2kH2807P0+sCUZ+VvwdGYhhk9HLzehXMuk4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HMBe5+BcMqQwZ0oD9ZntKQFLM7DbzIvqvd6ynalx+yACMElLkBmXOB001LJC3ShUn
	 AWdKZdX81e06aReDX4orjORVseJ8UcZc5I1TQTyyvzi7LpaQYnVcJrmCG0uGkseAB4
	 IAKtw8cwNgrhNa35O3HCeUgxq7zNhK76hXX5mPIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 162/396] iommufd: Fix wrong hwpt passed to iommufd_auto_response_faults on replace
Date: Fri,  7 Aug 2026 16:35:22 +0200
Message-ID: <20260807143427.799041110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit ba5c0f28a26e7d9be1e0997f8920dd638e2782fd upstream.

iommufd_hwpt_replace_device() calls:

	iommufd_auto_response_faults(hwpt, old_handle);

passing the *new* hwpt together with the handle of
the device's *old* domain. This should be a parameter mismatch:

1. Semantically, iommufd_auto_response_faults(x, handle) scans
   x->fault's deliver list and response xarray for groups matching
   "handle". A group is queued under the hwpt that was attached at
   fault-delivery time. old_handle is fetched *before* the domain switch,
   so its group lives on old->fault, not on the new hwpt->fault.

2. Historically, the first argument was "old". The routine was
   introduced by commit b7d8833677ba ("iommufd: Fault-capable hwpt
   attach/detach/replace") as __fault_domain_replace_dev() in
   fault.c, correctly calling iommufd_auto_response_faults(old, curr).
   Commit fb21b1568ada ("iommufd: Make attach_handle generic than
   fault specific") moved this into iommufd_hwpt_replace_device() in
   device.c and swapped it to "hwpt". This should be a refactor regression,
   not an intentional change.

Fix this by passing "old" instead.

Link: https://patch.msgid.link/r/9D652384339C69D5+20260710122952.885325-1-peiyang_he@smail.nju.edu.cn
Fixes: fb21b1568ada ("iommufd: Make attach_handle generic than fault specific")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -589,7 +589,7 @@ static int iommufd_hwpt_replace_device(s
 	if (rc)
 		goto out_free_handle;
 
-	iommufd_auto_response_faults(hwpt, old_handle);
+	iommufd_auto_response_faults(old, old_handle);
 	kfree(old_handle);
 
 	return 0;


