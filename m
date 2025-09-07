Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA6B14BFA2;
	Sun,  7 Sep 2025 20:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276240; cv=none; b=rccDKxIxFTN2bbEnguBE6+qIuFljmnwovyGrvoxFVzWUwAzV6gKbRJTCNbhpcAhPBQHaQBOsUkPbtCCxRiYBjbpjyr+Bzp7/cgsGsOKWKujt1WpHubhkLJcUfaR4uFFf011ERRJVsphvReIJGa5nreVSFqakInqneNUDXw3BX1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276240; c=relaxed/simple;
	bh=MrNRKx7A9/LlGitjz3mM78uoqL/vemAccwiA0iRUkkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akWkThhJAb+KfRSGKzMZj5i1XdXoMQrgCjjBFbJ5tI0hLkqC1g7KOpODtk+DblHLpB9w2lI0MwhoF1yygMXodx293WP4aega07lYmhDbu9ZgfLaNdAojOWBqgf1CxKLN7vslbTxt3Q84Um4lwgBQxHM1kpqt6zKe7W27yQ8AP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opNNQSua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opNNQSua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51634C4CEF0;
	Sun,  7 Sep 2025 20:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276240;
	bh=MrNRKx7A9/LlGitjz3mM78uoqL/vemAccwiA0iRUkkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opNNQSuaG9f+7MwxDtGVq4joCsUjSRYlGZC8HlAhOcr/5QDrfdTtwz0mV8K34zf+R
	 VecrKqdPWwFTEN3Br8fwEfUFzJ3y0OBz4Ye18sAxB5UUWoo0QH7f9WUJOGyrmlB9mG
	 wbeB6ObytT3Nu29TzkVVPz4NcwWY7Fx/EQtEdXGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 041/104] ACPI/IORT: Fix memory leak in iort_rmr_alloc_sids()
Date: Sun,  7 Sep 2025 21:57:58 +0200
Message-ID: <20250907195608.763386260@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -928,8 +928,10 @@ static u32 *iort_rmr_alloc_sids(u32 *sid
 
 	new_sids = krealloc_array(sids, count + new_count,
 				  sizeof(*new_sids), GFP_KERNEL);
-	if (!new_sids)
+	if (!new_sids) {
+		kfree(sids);
 		return NULL;
+	}
 
 	for (i = count; i < total_count; i++)
 		new_sids[i] = id_start++;


