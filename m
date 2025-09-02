Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC69305E02;
	Tue,  2 Sep 2025 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819419; cv=none; b=FekZYhKATSuksKnK89h9VUIOsNjLfl/EdVJ8yAKvN1L8foP0dYPPT85yFLpftPfvWVKK3iT47Fa/BCXnjlOeskO7QmKq2pyDJWJHJ7HNcfYa6XXw+Nu2zIIY63r9SL5hWXzguHxWfyBrNC4fIQkOnKfACWSikdCJkTwfDeaD5YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819419; c=relaxed/simple;
	bh=PX8QFQrXUfakfVoxoX/5F4Do+TYp1xJw8hEpIjD4JLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs4AW9o/qOU0tFVPMSQhxHuypFpEvJcd1C4LBs7qxwEhBHqQAdhXDx2iE7mXoxWfP5+KPXOOZxsVZL+wjAQ3od9qPwcFhMKjrLvuLXUgQ6UdFBiNa8+0MN3vJX002425enGPTvqOEQQdYnVWgUR7thVMTUuWS05UyVJ8ng2nRjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFgYK9Vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFgYK9Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE9EC4CEED;
	Tue,  2 Sep 2025 13:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819418;
	bh=PX8QFQrXUfakfVoxoX/5F4Do+TYp1xJw8hEpIjD4JLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFgYK9VbtW5BO55Ynyqmn2OT+CxPIOrWxcWZUdCjPFDPrUHj8Ck6T+e3/G9sZY0Hc
	 7J2czTUnRKcovLqWHPrPvLv63Du2gVxc+cacouqkDffyb4Fyqbj9NKohamsPI05BqL
	 umhxj5q0kya+5MELEKH82N6STzX900LKHDapkyoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 005/142] of: dynamic: Fix memleak when of_pci_add_properties() failed
Date: Tue,  2 Sep 2025 15:18:27 +0200
Message-ID: <20250902131948.363403439@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit c81f6ce16785cc07ae81f53deb07b662ed0bb3a5 ]

When of_pci_add_properties() failed, of_changeset_destroy() is called to
free the changeset. And of_changeset_destroy() puts device tree node in
each entry but does not free property in the entry. This leads to memory
leak in the failure case.

In of_changeset_add_prop_helper(), add the property to the device tree node
deadprops list. Thus, the property will also be freed along with device
tree node.

Fixes: b544fc2b8606 ("of: dynamic: Add interfaces for creating device node dynamically")
Reported-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Closes: https://lore.kernel.org/all/aJms+YT8TnpzpCY8@lpieralisi/
Tested-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250818152221.3685724-1-lizhi.hou@amd.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/dynamic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 0aba760f7577e..dd30b7d8b5e46 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -938,6 +938,9 @@ static int of_changeset_add_prop_helper(struct of_changeset *ocs,
 	if (ret)
 		__of_prop_free(new_pp);
 
+	new_pp->next = np->deadprops;
+	np->deadprops = new_pp;
+
 	return ret;
 }
 
-- 
2.50.1



