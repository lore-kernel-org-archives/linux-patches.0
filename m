Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9C1A592
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoWXZOUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F6BC433C8;
	Mon,  9 Oct 2023 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857237;
	bh=Mozk1Mkd7jmKck3IZ1qOP30vxv9hdk+4sLmB6JX12HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoWXZOUQqww68viuDGUtaMyCE7123h255XmESHQ6Wpmz2NyaZ9koMYyLOLV64IQvo
	 +107p4wlAVZVG/TdYB8PjZquZWT3kqIkiag7+G1jsjUi+7M5WXb24bx+hIpG2NiHfC
	 uiJ7QX3tCDyHFt4PbMKPmFkn6dP95I8Kf8o8mkQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.5 142/163] of: dynamic: Fix potential memory leak in of_changeset_action()
Date: Mon,  9 Oct 2023 15:01:46 +0200
Message-ID: <20231009130127.963252606@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 55e95bfccf6db8d26a66c46e1de50d53c59a6774 upstream.

Smatch complains that the error path where "action" is invalid leaks
the "ce" allocation:
    drivers/of/dynamic.c:935 of_changeset_action()
    warn: possible memory leak of 'ce'

Fix this by doing the validation before the allocation.

Note that there is not any actual problem with upstream kernels. All
callers of of_changeset_action() are static inlines with fixed action
values.

Fixes: 914d9d831e61 ("of: dynamic: Refactor action prints to not use "%pOF" inside devtree_lock")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202309011059.EOdr4im9-lkp@intel.com/
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/7dfaf999-30ad-491c-9615-fb1138db121c@moroto.mountain
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/dynamic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -927,13 +927,13 @@ int of_changeset_action(struct of_change
 {
 	struct of_changeset_entry *ce;
 
+	if (WARN_ON(action >= ARRAY_SIZE(action_names)))
+		return -EINVAL;
+
 	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
 	if (!ce)
 		return -ENOMEM;
 
-	if (WARN_ON(action >= ARRAY_SIZE(action_names)))
-		return -EINVAL;
-
 	/* get a reference to the node */
 	ce->action = action;
 	ce->np = of_node_get(np);


