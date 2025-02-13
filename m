Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C8526B085;
	Thu, 13 Feb 2025 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459276; cv=none; b=MONKnV5wlaWkeMVeS3URrDYAC3QFQDO+90rkiirvNLHtSrgUdAeN5nZ9FQnn5sMiqHaAyK5ip+OK/KXvHPZd1yLml/NaluzIDBAEH1/dAtxLukFJ6c+mU2FTNcE/SnJjOU1Mpc86ok0tGG6oOee0p/N4gWhmRvbCRcZ0kTZnotE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459276; c=relaxed/simple;
	bh=2a0ND9jxVqB+b2x4wSRHFAhJd+/tYlNVuc4bXstLtNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mgWchpsLVxAr8RoZiByOKxc2OuIed14Zw0bS1oy8vdp7sACQz0VbItpeSTY7X9e7JCwkSjKb2rB0xnzC6z4rxhbjRcHhmshr7V/VHAWLvBKsSRU3SuSGsjpG5de5QAv72QE9KJCh4jboQAQIb8EF9OLLC+TH9g+/Q4E+1zAqdVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bK1GPApZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bK1GPApZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208CCC4CED1;
	Thu, 13 Feb 2025 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459276;
	bh=2a0ND9jxVqB+b2x4wSRHFAhJd+/tYlNVuc4bXstLtNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bK1GPApZWLt66BYQHCq1TH74Ar388NOUemAOCh+nWkB/9lFAlGuYGvjJOpk3AhLRE
	 G7HJU+tBw1BQLWynJ9tAWWo3g8Jxo3F/ef1Z5wJGFK+4WFBvS+J8fIdBy32WmU0aqX
	 PchmHVn4Q7W4M3jJREuoHXOlR9AX79ntYfaZgX8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.13 218/443] of: reserved-memory: Fix using wrong number of cells to get property alignment
Date: Thu, 13 Feb 2025 15:26:23 +0100
Message-ID: <20250213142449.026020758@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -410,12 +410,12 @@ static int __init __reserved_mem_alloc_s
 
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
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;


