Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD5B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A781C433D2;
	Wed, 28 Dec 2022 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240242;
	bh=yacKS3xLkL3TkEsyxN0pfZJ8ccVhPh6cZmLhT2H7NHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAMMdpSYoBCvQvkexJMpIu39GGGdTtJKeigxOKNxZOi6W8eAYm58CSJOkOugIcRSF
	 wHcMxg8lFLMnuQ/djP7g9lyt9k0UVX2U062bDSQBInUbmDWc44n1vehDfhCiMn2Yev
	 2oYu1qbXF1/5CHOOUGztZ8JkG1XgZmMVDEXqrH/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/731] of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()
Date: Wed, 28 Dec 2022 15:37:14 +0100
Message-Id: <20221228144306.051087822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit ee9d7a0e754568180a2f8ebc4aad226278a9116f ]

When kmalloc() fail to allocate memory in kasprintf(), fn_1 or fn_2 will
be NULL, and strcmp() will cause null pointer dereference.

Fixes: 2fe0e8769df9 ("of: overlay: check prevents multiple fragments touching same property")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20221211023337.592266-1-ruanjinjie@huawei.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index d1187123c4fc..424682372417 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -547,7 +547,7 @@ static int find_dup_cset_node_entry(struct overlay_changeset *ovcs,
 
 		fn_1 = kasprintf(GFP_KERNEL, "%pOF", ce_1->np);
 		fn_2 = kasprintf(GFP_KERNEL, "%pOF", ce_2->np);
-		node_path_match = !strcmp(fn_1, fn_2);
+		node_path_match = !fn_1 || !fn_2 || !strcmp(fn_1, fn_2);
 		kfree(fn_1);
 		kfree(fn_2);
 		if (node_path_match) {
@@ -582,7 +582,7 @@ static int find_dup_cset_prop(struct overlay_changeset *ovcs,
 
 		fn_1 = kasprintf(GFP_KERNEL, "%pOF", ce_1->np);
 		fn_2 = kasprintf(GFP_KERNEL, "%pOF", ce_2->np);
-		node_path_match = !strcmp(fn_1, fn_2);
+		node_path_match = !fn_1 || !fn_2 || !strcmp(fn_1, fn_2);
 		kfree(fn_1);
 		kfree(fn_2);
 		if (node_path_match &&
-- 
2.35.1



