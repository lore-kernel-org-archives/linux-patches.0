Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5DD34AB17;
	Tue, 11 Nov 2025 01:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825348; cv=none; b=GqM1kL4UkAnxbP21HNnQ00oiv94mjInQ3OmEYh4NE1BFZ13pcUWsl4OpqTOJPNAbC4i1ROGK5mj7LYIF6qnHcpZ8BgfjPI6aeDvJahaQvnVifAmYgNIJ1UCjnMrxrpWdLgrU+azaOqtI8/Z2W8WqxxLz/VD6Fk3m2yuWcCz7L/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825348; c=relaxed/simple;
	bh=yG+4QglGZly4MlQxYvMKUR0MLTYciggiEISa+S233f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgiQc+E5rrCLZA2aIkm0B5hc86YL9NMhJwVyUCMa4C4x1HqXapJU+JkwmGd4IPUdKwsBIAVlRFfjLWJJUBdJgkMuywXP71g48oxH1G/CDW7N8JkPGPQb+tbqyqxrltGAKGBDEpPyi5zVG2tJw789/16dyHs3fu1YcLPhnRg5aSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bz79IJNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bz79IJNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581DFC19422;
	Tue, 11 Nov 2025 01:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825347;
	bh=yG+4QglGZly4MlQxYvMKUR0MLTYciggiEISa+S233f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bz79IJNsYTwdLWDA3Z8vIb94E7UrBdHUCyg88C6l73KsHOZl5u5ndOHadgq4I3qVL
	 VhfydA7T3ZZOhKHk0SHYgY8fqCqWPm7ceW/AHtgYsUcbmmniL+XaN0WjYBjRn+elBQ
	 zbisXd2eA9Xwc1UH6o8fAy7d8xq2acG9XBLuHOuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Luiz Duarte <gustavold@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 765/849] netconsole: Acquire su_mutex before navigating configs hierarchy
Date: Tue, 11 Nov 2025 09:45:35 +0900
Message-ID: <20251111004554.926967084@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/netconsole.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index e3722de08ea9f..3ff1dfc3d26b2 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -928,6 +928,7 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 	if (count > MAX_EXTRADATA_VALUE_LEN)
 		return -EMSGSIZE;
 
+	mutex_lock(&netconsole_subsys.su_mutex);
 	mutex_lock(&dynamic_netconsole_mutex);
 
 	ret = strscpy(udm->value, buf, sizeof(udm->value));
@@ -941,6 +942,7 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 	ret = count;
 out_unlock:
 	mutex_unlock(&dynamic_netconsole_mutex);
+	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
 }
 
@@ -966,6 +968,7 @@ static ssize_t sysdata_msgid_enabled_store(struct config_item *item,
 	if (ret)
 		return ret;
 
+	mutex_lock(&netconsole_subsys.su_mutex);
 	mutex_lock(&dynamic_netconsole_mutex);
 	curr = !!(nt->sysdata_fields & SYSDATA_MSGID);
 	if (msgid_enabled == curr)
@@ -986,6 +989,7 @@ static ssize_t sysdata_msgid_enabled_store(struct config_item *item,
 	ret = strnlen(buf, count);
 unlock:
 	mutex_unlock(&dynamic_netconsole_mutex);
+	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
 }
 
@@ -1000,6 +1004,7 @@ static ssize_t sysdata_release_enabled_store(struct config_item *item,
 	if (ret)
 		return ret;
 
+	mutex_lock(&netconsole_subsys.su_mutex);
 	mutex_lock(&dynamic_netconsole_mutex);
 	curr = !!(nt->sysdata_fields & SYSDATA_RELEASE);
 	if (release_enabled == curr)
@@ -1020,6 +1025,7 @@ static ssize_t sysdata_release_enabled_store(struct config_item *item,
 	ret = strnlen(buf, count);
 unlock:
 	mutex_unlock(&dynamic_netconsole_mutex);
+	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
 }
 
@@ -1034,6 +1040,7 @@ static ssize_t sysdata_taskname_enabled_store(struct config_item *item,
 	if (ret)
 		return ret;
 
+	mutex_lock(&netconsole_subsys.su_mutex);
 	mutex_lock(&dynamic_netconsole_mutex);
 	curr = !!(nt->sysdata_fields & SYSDATA_TASKNAME);
 	if (taskname_enabled == curr)
@@ -1054,6 +1061,7 @@ static ssize_t sysdata_taskname_enabled_store(struct config_item *item,
 	ret = strnlen(buf, count);
 unlock:
 	mutex_unlock(&dynamic_netconsole_mutex);
+	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
 }
 
@@ -1069,6 +1077,7 @@ static ssize_t sysdata_cpu_nr_enabled_store(struct config_item *item,
 	if (ret)
 		return ret;
 
+	mutex_lock(&netconsole_subsys.su_mutex);
 	mutex_lock(&dynamic_netconsole_mutex);
 	curr = !!(nt->sysdata_fields & SYSDATA_CPU_NR);
 	if (cpu_nr_enabled == curr)
@@ -1097,6 +1106,7 @@ static ssize_t sysdata_cpu_nr_enabled_store(struct config_item *item,
 	ret = strnlen(buf, count);
 unlock:
 	mutex_unlock(&dynamic_netconsole_mutex);
+	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
 }
 
-- 
2.51.0



