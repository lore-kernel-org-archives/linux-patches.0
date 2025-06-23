Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1C61E5B71;
	Mon, 23 Jun 2025 21:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713994; cv=none; b=BlDfgP1wQgHLFAnBFgvQ+Y+VGZ2hYr1ugFAVI4N11k96TrjXMnK2AB/s2SOY5cg36Jy7eKrWnbSyQslPFz3KpBRZB2lPn/fWQW72BaXTNskqb14G/iP4/Naf43292mHnagjPdqgDKSff4OD5qZaa6D6ofDEjfKBB+aYzymvvXtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713994; c=relaxed/simple;
	bh=IX5b/56yxLxgfqIDSOpx5toxc7XYwUBxvfGz+ziNfxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiuLrI0N54u6m5gYQFIIF6sBvpKCW47m+KK6XPxt4jNfxvACfWuKPad+yQ5SaM8KsN1vPWCPUiAgjmUsTFXoibgN07nazHJm0sVYmIi6Z9Pg+ih21BQt5dA0PUbMG+eV+ewI3TE2AbhtpBabWMrxFSJzdUc+J+18GRvWgZYYOiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhj2BxGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhj2BxGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86EAC4CEEA;
	Mon, 23 Jun 2025 21:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713994;
	bh=IX5b/56yxLxgfqIDSOpx5toxc7XYwUBxvfGz+ziNfxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhj2BxGk0SRWeNDFo+gI80FoqLWzG8vLetvnfth03wt1FiR2oT4ofgHFFk1/ujlVD
	 ht1KnHCGKspbEX7pIjQ7oW4hOYOk8JXGixfX6Enc9I+K2QLr3tumxnUIWHqzung7SE
	 nd98CDBWje4vcPSG3kJcmLILvroIbnXk8EAwa4Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.6 107/290] uio_hv_generic: Use correct size for interrupt and monitor pages
Date: Mon, 23 Jun 2025 15:06:08 +0200
Message-ID: <20250623130630.170043531@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit c951ab8fd3589cf6991ed4111d2130816f2e3ac2 upstream.

Interrupt and monitor pages should be in Hyper-V page size (4k bytes).
This can be different from the system page size.

This size is read and used by the user-mode program to determine the
mapped data region. An example of such user-mode program is the VMBus
driver in DPDK.

Cc: stable@vger.kernel.org
Fixes: 95096f2fbd10 ("uio-hv-generic: new userspace i/o driver for VMBus")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1746492997-4599-3-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1746492997-4599-3-git-send-email-longli@linuxonhyperv.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -288,13 +288,13 @@ hv_uio_probe(struct hv_device *dev,
 	pdata->info.mem[INT_PAGE_MAP].name = "int_page";
 	pdata->info.mem[INT_PAGE_MAP].addr
 		= (uintptr_t)vmbus_connection.int_page;
-	pdata->info.mem[INT_PAGE_MAP].size = PAGE_SIZE;
+	pdata->info.mem[INT_PAGE_MAP].size = HV_HYP_PAGE_SIZE;
 	pdata->info.mem[INT_PAGE_MAP].memtype = UIO_MEM_LOGICAL;
 
 	pdata->info.mem[MON_PAGE_MAP].name = "monitor_page";
 	pdata->info.mem[MON_PAGE_MAP].addr
 		= (uintptr_t)vmbus_connection.monitor_pages[1];
-	pdata->info.mem[MON_PAGE_MAP].size = PAGE_SIZE;
+	pdata->info.mem[MON_PAGE_MAP].size = HV_HYP_PAGE_SIZE;
 	pdata->info.mem[MON_PAGE_MAP].memtype = UIO_MEM_LOGICAL;
 
 	pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);


