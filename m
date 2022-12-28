Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F31875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C38C433F0;
	Wed, 28 Dec 2022 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243688;
	bh=VsuPFUIap1KyUr6iFwbtgk4TALLypXbcuFjLuAR3f4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCzDRRSU88J1nUoo6F6LBNBp+azrWxKUYOBdPLb1r5WV7RbFVLYSLC+niuwOLU+0Y
	 dTkLVfmDwBM75yEXQNYXJbTun8LfaeTyU7XK1YdL3UTmwsMYdOHXbu9Qx/7kG40ahy
	 4xI0HFSIgaCPnhVma/dPOrsT+gFWTgEHa7r0a0e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0534/1146] of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()
Date: Wed, 28 Dec 2022 15:34:33 +0100
Message-Id: <20221228144344.680343974@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index bd8ff4df723d..ed4e6c144a68 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -545,7 +545,7 @@ static int find_dup_cset_node_entry(struct overlay_changeset *ovcs,
 
 		fn_1 = kasprintf(GFP_KERNEL, "%pOF", ce_1->np);
 		fn_2 = kasprintf(GFP_KERNEL, "%pOF", ce_2->np);
-		node_path_match = !strcmp(fn_1, fn_2);
+		node_path_match = !fn_1 || !fn_2 || !strcmp(fn_1, fn_2);
 		kfree(fn_1);
 		kfree(fn_2);
 		if (node_path_match) {
@@ -580,7 +580,7 @@ static int find_dup_cset_prop(struct overlay_changeset *ovcs,
 
 		fn_1 = kasprintf(GFP_KERNEL, "%pOF", ce_1->np);
 		fn_2 = kasprintf(GFP_KERNEL, "%pOF", ce_2->np);
-		node_path_match = !strcmp(fn_1, fn_2);
+		node_path_match = !fn_1 || !fn_2 || !strcmp(fn_1, fn_2);
 		kfree(fn_1);
 		kfree(fn_2);
 		if (node_path_match &&
-- 
2.35.1



