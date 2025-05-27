Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55934367;
	Tue, 27 May 2025 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366087; cv=none; b=W8t5f8n5icVngadpkNVH9laHhomw4b02K3nbipjntHtnntxkbUMEpM33OU17Gb+7/kxBWxZhxmirEZxxp6dbDYsnCh4v9LUkCLCjH9U5APscW1psNu+hD4KmwyemEKDPS5+4Ne865FZySh7RD2XE/3ZI/13GgU8kd69b1vT4nWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366087; c=relaxed/simple;
	bh=Pjx/vkPtjE64/zvUzqbUDv57p6O0bXii9atCqONSmL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKP+TzGk4NTO1LLAOTxMQ5l9OHniqJuvhDXC4FKO4imhAptXkKG6zhcmDohj9t3u1pay4tfx5yz/j6eZ/8XnXnX3f+J/NyEIvNqdI1Dvatm6IX6gRFGx669TvZ6NLroYIQXfE6LzD/6SkbMeSzfI6JAd1EVASKWFz5aOh/X/KFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV0KZTuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV0KZTuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02C5C4CEE9;
	Tue, 27 May 2025 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366087;
	bh=Pjx/vkPtjE64/zvUzqbUDv57p6O0bXii9atCqONSmL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV0KZTujCSM0YPplHQzIgXG4eAQ8uibmXh/Xdo0MCFGYLtMN+2GASvGkBaJzBkC5S
	 1bD5yXFx0+rv3S4utUfkt4kdTCkFuDXVrgKXbyd9k0Uy9zzGsj5RWX3P/fMQ0aMfrg
	 qbujw0FuG6jteUQF/a+u+i9E0sRh7kkyP5KWgqMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 587/626] pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()
Date: Tue, 27 May 2025 18:28:00 +0200
Message-ID: <20250527162508.833069286@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 0f5757667ec0aaf2456c3b76fcf0c6c3ea3591fe upstream.

The error checking for of_count_phandle_with_args() does not handle
negative error codes correctly.  The problem is that "index" is a u32 so
in the condition "if (index >= num_domains)" negative error codes stored
in "num_domains" are type promoted to very high positive values and
"index" is always going to be valid.

Test for negative error codes first and then test if "index" is valid.

Fixes: 3ccf3f0cd197 ("PM / Domains: Enable genpd_dev_pm_attach_by_id|name() for single PM domain")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/aBxPQ8AI8N5v-7rL@stanley.mountain
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -3043,7 +3043,7 @@ struct device *genpd_dev_pm_attach_by_id
 	/* Verify that the index is within a valid range. */
 	num_domains = of_count_phandle_with_args(dev->of_node, "power-domains",
 						 "#power-domain-cells");
-	if (index >= num_domains)
+	if (num_domains < 0 || index >= num_domains)
 		return NULL;
 
 	/* Allocate and register device on the genpd bus. */


