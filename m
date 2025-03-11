Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491218632E;
	Tue, 11 Mar 2025 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705720; cv=none; b=rmHhKTWNNQg89JRq0jT/UwdWuX6j97Ok43PFHaPQ4NT1cnz7AINk2lfQ7TPCk9n9xC+TdhHHyEfmqDn/Go8sPEkf6QVrO8YWQGHZA7MxqraCkK9feo2AstDH/sDU2Zj2/jFv1mq8N2458m4GBaCSDydw6DgJMNQ7BcWNmcZtRnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705720; c=relaxed/simple;
	bh=uhs++PFekYF+DztFg2bATpgOrTHUzYAiJQudLWNun+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8a4LmPsL8TbLiR5jShQBYiiYbbfmZCFtMYLu3/62X9d9laQWNIU5LFBaDXAK8oYmTdxnyWTAQF6lwMg65ai59+CkYXQAl4fw99NRU88jJ5P0EUu75dnfymHJfngnTAUfUlJPQ0TfGIBUikfEk/M7mAq1wXVEhi+R2TbvLC0F+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCl6HhGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCl6HhGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B57C4CEE9;
	Tue, 11 Mar 2025 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705720;
	bh=uhs++PFekYF+DztFg2bATpgOrTHUzYAiJQudLWNun+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCl6HhGWqpMd0tL3PZypIipeVd6m052XrXkl0koNzAE8WCPJRrLTqTD2g3YtpXCk7
	 qoNpKCl8ZO9yiZM4IlKXI4zyk8Ehrp9leJE9bydli1M9etV4fNPGw2HKq1WP96JlzZ
	 cc5nX6OWjtsG7AIvp7aNcyrLchsVwHWAc6ZTzR7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 132/328] of: reserved-memory: Fix using wrong number of cells to get property alignment
Date: Tue, 11 Mar 2025 15:58:22 +0100
Message-ID: <20250311145720.153110619@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 267b21d0bef8e67dbe6c591c9991444e58237ec9 upstream.

According to DT spec, size of property 'alignment' is based on parent
node’s #size-cells property.

But __reserved_mem_alloc_size() wrongly uses @dt_root_addr_cells to get
the property obviously.

Fix by using @dt_root_size_cells instead of @dt_root_addr_cells.

Fixes: 3f0c82066448 ("drivers: of: add initialization code for dynamic reserved memory")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-9-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_reserved_mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -96,12 +96,12 @@ static int __init __reserved_mem_alloc_s
 
 	prop = of_get_flat_dt_prop(node, "alignment", &len);
 	if (prop) {
-		if (len != dt_root_addr_cells * sizeof(__be32)) {
+		if (len != dt_root_size_cells * sizeof(__be32)) {
 			pr_err("invalid alignment property in '%s' node.\n",
 				uname);
 			return -EINVAL;
 		}
-		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
+		align = dt_mem_next_cell(dt_root_size_cells, &prop);
 	}
 
 	/* Need adjust the alignment to satisfy the CMA requirement */


