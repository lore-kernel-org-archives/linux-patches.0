Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AD93CAE61;
	Wed, 20 May 2026 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296966; cv=none; b=kpL3KXTt888QDqK8ODocYD5lGCkcONLxq95R5lw5Verk9rRPo85/Cg6MBnDqQjkX8M6UKzeCqKBWwgTpFh1TrqtGwAPJf6ssQwbafYwvVfuOgwPWjfa/6a21hCp8+1SCb7MqNAnENfdL2oUD5fcyalh8RL9wQhVmGAS5jlQYk5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296966; c=relaxed/simple;
	bh=cIB5cUvEJLeIeFjJ7j3KNdXgrlpr5LfkfcULTVyqFXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt5xZYI5rku/EHiQDX8XQ5K9f541M+bI0efRI3nE5E5dCCk22unZBzshUhN84kIOs09Wm3W/kvRnlDv8YHXyYvEUgaZIXfjpBP6r1nD59cFeaFTiC1Xf4cgnbRvnU4IEqMyrWBe0/Bw84q9LaDLSmuc8+cNdQlkyA2urO0PbiQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciVD1pdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciVD1pdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5865C1F000E9;
	Wed, 20 May 2026 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296964;
	bh=6+BTsCFAbgwTUXoEdWpPD018p1rkz2Gf1VbI7JYoY6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciVD1pdAU/xqbgUIRHtz9Mb43Q+T61CB5bcuvGPSaZscDceLoopn8ADSBPIA/psqf
	 NRmcs2ZRW+OjJkss2sCwEcP+mmF3DO4OfNZz6Of1zbMPRsXERWZRiVyjbqN9zK1IUy
	 RdUbNqAZG/toan+nT0IcC+s3CmiDUZIdwL8sjoXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0997/1146] netconsole: restore userdatum value on update_userdata() failure
Date: Wed, 20 May 2026 18:20:47 +0200
Message-ID: <20260520162210.795673366@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 869cd6490fafe09c89a15d01610e8a03932d79f0 ]

userdatum_value_store() updates udm->value first and only then calls
update_userdata() to rebuild the on-the-wire payload. If
update_userdata() fails (e.g. -ENOMEM from kmalloc), the function
returns the error to userspace, but udm->value already holds the new
string while the live nt->userdata buffer still reflects the old one.

The next successful write to any sibling userdatum on the same target
will call update_userdata() again, which walks every entry and packs
the now-stale udm->value into the payload. The failed write is thus
silently activated later, with no indication to userspace that the
value it tried to set was rejected.

Snapshot the previous value before overwriting udm->value and restore
it if update_userdata() fails so the visible state and the active
payload stay consistent.

Fixes: eb83801af2dc ("netconsole: Dynamic allocation of userdata buffer")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260427-netconsole_ai_fixes-v2-4-59965f29d9cc@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index b3b36e3ddd03d..57dd6821a8aa9 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1079,6 +1079,7 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 				     size_t count)
 {
 	struct userdatum *udm = to_userdatum(item);
+	char old_value[MAX_EXTRADATA_VALUE_LEN];
 	struct netconsole_target *nt;
 	struct userdata *ud;
 	ssize_t ret;
@@ -1088,6 +1089,8 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 
 	mutex_lock(&netconsole_subsys.su_mutex);
 	dynamic_netconsole_mutex_lock();
+	/* Snapshot for rollback if update_userdata() fails below */
+	strscpy(old_value, udm->value, sizeof(old_value));
 	/* count is bounded above, so strscpy() cannot truncate here */
 	strscpy(udm->value, buf, sizeof(udm->value));
 	trim_newline(udm->value, sizeof(udm->value));
@@ -1095,8 +1098,11 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 	ud = to_userdata(item->ci_parent);
 	nt = userdata_to_target(ud);
 	ret = update_userdata(nt);
-	if (ret < 0)
+	if (ret < 0) {
+		/* Restore the previous value so it matches the live payload */
+		strscpy(udm->value, old_value, sizeof(udm->value));
 		goto out_unlock;
+	}
 	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
-- 
2.53.0



