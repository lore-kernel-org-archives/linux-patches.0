Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA64394785;
	Sat, 17 Oct 2026 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253547; cv=none; b=VhLBOBFGaxc0bjHchMDqhtOC2ZHuSKT6ZGC02TiDoAQ6zK5cdv4N11K2oJGEUS1wjIfWfdd4QLtbCCMUlfTwhj4DXMWEQZgyRhaCBVotel5V5xPe09oP+JFsXzgwehDqFgB57mPhsUscAiY2LcE0t1M9gkePURADic0n33n2ykU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253547; c=relaxed/simple;
	bh=xVccQccLrNm61LYbephQdrsHO995/9UfaF/6fSYJnZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtFxAwCC6uuyOFCELZMsEQlBfwMrT/WjysxySAjEgtwH4hguEDX4vP1pjkPtQBMyOFZIUC98oWOwV1wUqz3a83KzevRQPcrMjFSTMd8pLmi+9i6Gb+TgZ8Tl2pVHivFw7yjXg7x9tf+BqcXv68Gg4eSWm0gxbz2PJNNpja2D9FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDk6LC2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDk6LC2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DA81F000C4;
	Sat, 17 Oct 2026 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253546;
	bh=m6d8IP/jLX5lmHPUZlz4sPL7u9KiWEHKvKlwxHSMxjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDk6LC2+2WmpCqqCAwHTMzibTzFajWxwCynMU0DbAvznQyYPekSboax7MHJ54YTOl
	 efCV6nq0LSIng2W3u3783ommLMMNUSKoEiNy7qK3o0W+w3QzRRhN/IDbxh6J5gEqr4
	 LjFapFf4eNOMuBr0ipj6RuRUBScEiEj0uMdnyROA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Luiz Duarte <gustavold@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/869] netconsole: Acquire su_mutex before navigating configs hierarchy
Date: Sat, 17 Oct 2026 17:49:53 +0200
Message-ID: <20261017160040.936542341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gustavo Luiz Duarte <gustavold@gmail.com>

[ Upstream commit d7d2fcf7ae31471b4e08b7e448b8fd0ec2e06a1b ]

There is a race between operations that iterate over the userdata
cg_children list and concurrent add/remove of userdata items through
configfs. The update_userdata() function iterates over the
nt->userdata_group.cg_children list, and count_extradata_entries() also
iterates over this same list to count nodes.

Quoting from Documentation/filesystems/configfs.rst:
> A subsystem can navigate the cg_children list and the ci_parent pointer
> to see the tree created by the subsystem.  This can race with configfs'
> management of the hierarchy, so configfs uses the subsystem mutex to
> protect modifications.  Whenever a subsystem wants to navigate the
> hierarchy, it must do so under the protection of the subsystem
> mutex.

Without proper locking, if a userdata item is added or removed
concurrently while these functions are iterating, the list can be
accessed in an inconsistent state. For example, the list_for_each() loop
can reach a node that is being removed from the list by list_del_init()
which sets the nodes' .next pointer to point to itself, so the loop will
never end (or reach the WARN_ON_ONCE in update_userdata() ).

Fix this by holding the configfs subsystem mutex (su_mutex) during all
operations that iterate over cg_children.
This includes:
- userdatum_value_store() which calls update_userdata() to iterate over
  cg_children
- All sysdata_*_enabled_store() functions which call
  count_extradata_entries() to iterate over cg_children

The su_mutex must be acquired before dynamic_netconsole_mutex to avoid
potential lock ordering issues, as configfs operations may already hold
su_mutex when calling into our code.

Fixes: df03f830d099 ("net: netconsole: cache userdata formatted string in netconsole_target")
Signed-off-by: Gustavo Luiz Duarte <gustavold@gmail.com>
Link: https://patch.msgid.link/20251029-netconsole-fix-warn-v1-1-0d0dd4622f48@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 0c47713b6adbc..68df8a9e1ecc8 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -748,6 +748,7 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 	if (count > MAX_USERDATA_VALUE_LENGTH)
 		return -EMSGSIZE;
 
+	mutex_lock(&netconsole_subsys.su_mutex);
 	mutex_lock(&dynamic_netconsole_mutex);
 
 	ret = strscpy(udm->value, buf, sizeof(udm->value));
@@ -761,6 +762,7 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 	ret = count;
 out_unlock:
 	mutex_unlock(&dynamic_netconsole_mutex);
+	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
 }
 
-- 
2.53.0



