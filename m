Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C528F1F3BB0;
	Wed, 19 Feb 2025 08:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955588; cv=none; b=nRsDEZYtZQjEWA3/b/bhjoilrzF4VaVnQIpNKn1+Y379e58d8SyjM90aBEwuRUkGyggdnzEYvTMMx+Bq9tWqFtvZ6JO9YXEfwWZ8TGtmdR48hYNdSYuIQkPBWJ/nOYouy+aiRyuwZgEV+o9CwJm7qb8f42SpNMiVMUEtMRvWEwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955588; c=relaxed/simple;
	bh=hSHc7nLmvFxXVRU4RVfNS22mIVB7K2Nn7mQwN/883Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5oDdseq9ODcB6acoUPldBaQiu8K1viw32qD5Fvra7DG+AvXuAST4U3ai/sa+Y70qBOZmMHATEFS9asdSElohSW89zcy9WBNm5/F2JrMrOKLQ+kGfNBs5CkRY/NH6k2Dq+7GC//jb/TubBrBwWQhC0BJyXYmO4bNptQaNNjZVT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYn5HbTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYn5HbTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44842C4CEF9;
	Wed, 19 Feb 2025 08:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955588;
	bh=hSHc7nLmvFxXVRU4RVfNS22mIVB7K2Nn7mQwN/883Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYn5HbTL3ZIYr11AKQkcZ8NAtQ4ucZZOHn3yeabqEYruD6OhjkxL+po2VJbhHZioy
	 9HGQBoQnVGuyAs2vR8esi0nllZY9b/pFUX56A/BWZhqd9dsQMmsuvNzezOhCs60/sf
	 j4ah6WmYXh6MEFKypByQXybpro/Zy7LhcppOlPxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 052/152] drm/amdgpu: avoid buffer overflow attach in smu_sys_set_pp_table()
Date: Wed, 19 Feb 2025 09:27:45 +0100
Message-ID: <20250219082552.104328175@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Jiang Liu <gerry@linux.alibaba.com>

commit 1abb2648698bf10783d2236a6b4a7ca5e8021699 upstream.

It malicious user provides a small pptable through sysfs and then
a bigger pptable, it may cause buffer overflow attack in function
smu_sys_set_pp_table().

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -517,7 +517,8 @@ static int smu_sys_set_pp_table(void *ha
 		return -EIO;
 	}
 
-	if (!smu_table->hardcode_pptable) {
+	if (!smu_table->hardcode_pptable || smu_table->power_play_table_size < size) {
+		kfree(smu_table->hardcode_pptable);
 		smu_table->hardcode_pptable = kzalloc(size, GFP_KERNEL);
 		if (!smu_table->hardcode_pptable)
 			return -ENOMEM;


