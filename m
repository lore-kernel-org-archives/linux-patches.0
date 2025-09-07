Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2EC20E00B;
	Sun,  7 Sep 2025 20:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277710; cv=none; b=vEK65AcPfpTsz2YRmxKAr9ol9B85/KZFJglLR08yywknEnTIhjv9ZoV5dibgXj2C9geEJNopUGlC9Ic43lm9gOQg+uMZxxuDsB0H4IfxNNAyjemcURcOobbK/2g/s0EKWPIseg2tjDI1b8uSDD4CRCl05+KF0nXwmo5dyoCRyK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277710; c=relaxed/simple;
	bh=8VTPDvEbNX+m8K/0uj3fZyouJ6KKJoNQVKh0+tUx8X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoGHrn92+EqHzJuTaXRPya5UC96rVkSITJF0MXtW2KE81Dsu/S7CA+7+Tm8Uz4TlHk2zA/jlLD08MCwykP6fffgj0U6slDi0ESiobej67FOSKmP6ekyURW7yM+G6TBYifFILZXVnbrh32zl946yjq2wNxsEwt9zpYWXWnoQ0kac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ets2I5CQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ets2I5CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81A0C4CEF0;
	Sun,  7 Sep 2025 20:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277710;
	bh=8VTPDvEbNX+m8K/0uj3fZyouJ6KKJoNQVKh0+tUx8X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ets2I5CQ1DODNnhzT9zJiuZM75P6oAj7NjLpFqyjibXN8GQmL0aI+g3KwegBW8448
	 FXSPgz5outk6GxKpm2eR8j1zdwEx7u77iskKyeAZe6k/ypoKDcOXZJF72EwBgxKbk6
	 yvdCXd9Q8DQfwg/tCUCE5JuJmGzN8c38GLfUp8W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.16 098/183] ACPI/IORT: Fix memory leak in iort_rmr_alloc_sids()
Date: Sun,  7 Sep 2025 21:58:45 +0200
Message-ID: <20250907195618.112604970@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


