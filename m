Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652D879C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F7DC433D2;
	Thu, 12 Jan 2023 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533211;
	bh=wOdGSvYnCqEXJpo1q1pq+SngT5sUyrt7vkwNwaBY95Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBc8GkDGYw/nScoYxVcYxpdPW2j0LS/liuPn3tGQQ1yCwx78VqrP5+iJc9tF0kKgd
	 iR7gSPIRlYDbI444iqtb9qKvgkbE2lke1McWoyFxbscoeJbbnJkpvCUhfg7hLv9WG5
	 lrByxmHwVd0PWf+CE9VAGGACZ5PrfaPzuto6Io40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/783] usb: roles: fix of node refcount leak in usb_role_switch_is_parent()
Date: Thu, 12 Jan 2023 14:51:31 +0100
Message-Id: <20230112135541.708649969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1ab30c610630da5391a373cddb8a065bf4c4bc01 ]

I got the following report while doing device(mt6370-tcpc) load
test with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/pmic@34

The 'parent' returned by fwnode_get_parent() with refcount incremented.
it needs be put after using.

Fixes: 6fadd72943b8 ("usb: roles: get usb-role-switch from parent")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221122111226.251588-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/roles/class.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/roles/class.c b/drivers/usb/roles/class.c
index 33b637d0d8d9..5cc20275335d 100644
--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -106,10 +106,13 @@ usb_role_switch_is_parent(struct fwnode_handle *fwnode)
 	struct fwnode_handle *parent = fwnode_get_parent(fwnode);
 	struct device *dev;
 
-	if (!parent || !fwnode_property_present(parent, "usb-role-switch"))
+	if (!fwnode_property_present(parent, "usb-role-switch")) {
+		fwnode_handle_put(parent);
 		return NULL;
+	}
 
 	dev = class_find_device_by_fwnode(role_class, parent);
+	fwnode_handle_put(parent);
 	return dev ? to_role_switch(dev) : ERR_PTR(-EPROBE_DEFER);
 }
 
-- 
2.35.1



