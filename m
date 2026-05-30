Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C217219303;
	Sat, 30 May 2026 18:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165604; cv=none; b=Fgbvzvil2Dpc+7wYPlNKH5rrKBQL2lLDXW2Kv1I/xeqIgvkzIgLgI7bZTM9/OKIazgs5ESTrWk0f7NjiENtoj6wFuNQ4erd1RMQr3ttsDWFQ0+uznSIu6vIpJh3/2HDU8XJAdx5SSuq9SaC9VwWNyRoU3wEIPTEBMLJuzcFNBUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165604; c=relaxed/simple;
	bh=LTU7jlDjBt3cRkSAlb0u0f10KZooxMRHzX0tNTCDDnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqMEieq4Juxww2/VkjzhTCzD3gQu7urApMPI4V6FXcxlApDT+HvmsCdYDlclM1AbJBfaU4QPIUfm6D1vIpBs3B1GXjo17tD1oY/ekHIdq9lkE88wdMT1QK2kwvZMnj21vn4AaSMo3IT4+x1jo8SY8XyblFO4/tct4SIKWMXT8oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9rGYBGB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9rGYBGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0B01F00893;
	Sat, 30 May 2026 18:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165603;
	bh=UAZf/+QlYRqu6C7jdYSttAM9UIdqgqGspu61cgfsu4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9rGYBGBPa1bpFy9jYye6O5cZIxD1V8Ov+jE8rTeqTFXIlgfIhWyFMV3O0fWwW1r3
	 OnXKm5jFWxSMKxTrudXlbzvrJMCFLj0cVAMtI2jqBZUOT4E65p1cCnOxNbovLeBPAG
	 rITmauCYJUhNr9UnpVLtaBJ1jnAUazpKOMZ6WY6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/589] cifs: Fix connections leak when tlink setup failed
Date: Sat, 30 May 2026 18:00:07 +0200
Message-ID: <20260530160228.080867626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 1dcdf5f5b2137185cbdd5385f29949ab3da4f00c upstream.

If the tlink setup failed, lost to put the connections, then
the module refcnt leak since the cifsd kthread not exit.

Also leak the fscache info, and for next mount with fsc, it will
print the follow errors:
  CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)

Let's check the result of tlink setup, and do some cleanup.

Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ kovalev: bp to fix CVE-2022-49822; adapted to use direct xid/ses/tcon
  variables instead of mnt_ctx struct fields due to the older kernel not
  having the corresponding cifs_mount() refactoring (see upstream commit
  c88f7dcd6d64); additionally NULL out mntdata after dfs_cache_add_vol()
  transfers its ownership to vol_list, otherwise the new error path from
  mount_setup_tlink() failure would double-free it via kfree(mntdata) in
  the error: label ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 769c7759601db..3ce86a88fad4a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4770,6 +4770,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	rc = dfs_cache_add_vol(mntdata, vol, cifs_sb->origin_fullpath);
 	if (rc)
 		goto error;
+	/* mntdata is now owned by vol_list */
+	mntdata = NULL;
 	/*
 	 * After reconnecting to a different server, unique ids won't
 	 * match anymore, so we disable serverino. This prevents
@@ -4786,9 +4788,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	vol->prepath = NULL;
 
 out:
-	free_xid(xid);
 	cifs_try_adding_channels(ses);
-	return mount_setup_tlink(cifs_sb, ses, tcon);
+	rc = mount_setup_tlink(cifs_sb, ses, tcon);
+	if (rc)
+		goto error;
+
+	free_xid(xid);
+	return rc;
 
 error:
 	kfree(ref_path);
@@ -4820,9 +4826,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 			goto error;
 	}
 
-	free_xid(xid);
+	rc = mount_setup_tlink(cifs_sb, ses, tcon);
+	if (rc)
+		goto error;
 
-	return mount_setup_tlink(cifs_sb, ses, tcon);
+	free_xid(xid);
+	return rc;
 
 error:
 	mount_put_conns(cifs_sb, xid, server, ses, tcon);
-- 
2.53.0



