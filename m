Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C41A5BA
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+2KOEzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28ECC433C9;
	Mon,  9 Oct 2023 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858065;
	bh=hzMWnHRNw13u6jmE/XQkDrcLZucuig/x8S7A59PjNgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+2KOEzmMK/UJpl5wUisKqW+hVGtmkaCSjCmSjhfUD6IhR0z4HRRvPi8o7908lHLi
	 jUEfaLixTc7DGmnC7vAYmqbxG5VvJoNI6cp470g9Eiu9GBOSi74gbClFxWCAmX/Ty4
	 6zHy/MS0pcGQsoeoxWD/9nNoAvyVG3E+3MmMZZko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 65/75] of: dynamic: Fix potential memory leak in of_changeset_action()
Date: Mon,  9 Oct 2023 15:02:27 +0200
Message-ID: <20231009130113.533659904@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -901,13 +901,13 @@ int of_changeset_action(struct of_change
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


