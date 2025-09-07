Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C1915C158;
	Sun,  7 Sep 2025 20:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277121; cv=none; b=YDtA22Qe0r/xtFSURIPNVsxLCI5uhsTmIlBGr0dVyNSe1h+6OUtn2WJPRIZwfXoPr03JnrFKfuFIxrcRT3FRoKktIeEHsrBtlZDwCr3IpyAp/eSuXYhdkRJ/DCmE/I/mRGV7UX9bEO6sGwZGyjpUI5HxMdYohrK/hVCPrVpPAww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277121; c=relaxed/simple;
	bh=gg8XX91kMUME/8/GF2V409B9Y2Bz3J1W3PshP5Ndzw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifTEJbdGIP15itmfhSLB7MpByIl9q+Qa+s27dVnoEr0BTJlpcC2ccP4JqD5EEXXWtBBHeG7uEhrSO5zNcJqd+eQt7WQWy92pOC19Ri4q36ISFALzVZl4gq0sv1s8QsyZiQXmxMJoxmgnGFefpwlQ2QPnv/O5PEa04SzxLPJC9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zAHVSA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zAHVSA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD141C4CEF0;
	Sun,  7 Sep 2025 20:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277121;
	bh=gg8XX91kMUME/8/GF2V409B9Y2Bz3J1W3PshP5Ndzw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zAHVSA5nOHIIqu8yR3kQpE6g95GoeJZYCMXIz3vURi3X2bCEqo/zQRxGHcKmBxoj
	 u0KQvhThQ6dTp2NkV9pn1T3gCltnyHleBJczo/zR5mOl46LKW2A/ADyM2Wz82eQAiv
	 ri9s6CN2sEUTBaOAfujkCAW29tMwTwVxYsDK87Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 093/175] ACPI/IORT: Fix memory leak in iort_rmr_alloc_sids()
Date: Sun,  7 Sep 2025 21:58:08 +0200
Message-ID: <20250907195617.044013405@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit f3ef7110924b897f4b79db9f7ac75d319ec09c4a upstream.

If krealloc_array() fails in iort_rmr_alloc_sids(), the function returns
NULL but does not free the original 'sids' allocation. This results in a
memory leak since the caller overwrites the original pointer with the
NULL return value.

Fixes: 491cf4a6735a ("ACPI/IORT: Add support to retrieve IORT RMR reserved regions")
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/20250828112243.61460-1-linmq006@gmail.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/iort.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -937,8 +937,10 @@ static u32 *iort_rmr_alloc_sids(u32 *sid
 
 	new_sids = krealloc_array(sids, count + new_count,
 				  sizeof(*new_sids), GFP_KERNEL);
-	if (!new_sids)
+	if (!new_sids) {
+		kfree(sids);
 		return NULL;
+	}
 
 	for (i = count; i < total_count; i++)
 		new_sids[i] = id_start++;


