Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EA230C60F;
	Sat, 12 Sep 2026 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225680; cv=none; b=qjgl0erVpekZRPFNNhDkegt37oSq9o6cyd2C9FlLCLu3cJlUjKHXehaCXphJzwaXjknZSJv4AvdTM75PmxIonsjJw2zYZRCMrPuHiDWBEBtv0LutbqM124mzhuakuzJUN6NgDQufXQsb+2seiW3oyHWfqAeePpQtdpByb1CyWfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225680; c=relaxed/simple;
	bh=kUsVwH94ju+UwKO8/y8jZL3g8FaW7oQbPrvdUVXaHRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLir/WW6WHuHgXqudAMW0PH8QGfMQqZvcueJ7tjxzC84krm3AFHGBAEArw3AOMD5e9RpQC7qYSBOorl40/oygwOBrZXN3QP1+qGt2+378SdVzRCDzPGvw1Upvvp1bekrSs1Y8Kb44iJyxpjp6f0pBRvDMfCB0+dFt6Vt+EOpFqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l83OciiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l83OciiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3171F000FF;
	Sat, 12 Sep 2026 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225678;
	bh=fIqsUNayI5gqZJxS+1IrT/in5nUdQgawSuoNl82rDDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l83OciiEI/yl7WpX3Kz4nPKCrLs7x7H24Za4LPt4GzTzmySys5tKw3DUnGkmLek6R
	 wCZLzPhE1WY1IYm2IszvanwRuyROEL5+orFxaujwlyP8sTfMf4XQmfd5e5M0TvAkhM
	 RkqpVxkAfWWDOpsEUPVxAR8eGEyLOdnzRhtNsFF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1247/1424] smb: server: fix leak of ksmbd_ipc_login_request_ext() returned buffer
Date: Sat, 12 Sep 2026 09:01:19 +0200
Message-ID: <20260912065635.208413075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 1c3ebf832d010c08afe1359215d4121cb1ed2de5 ]

Free it unconditionally after ksmbd_alloc_user() calls.

kmemleak splat:
  unreferenced object 0xffff888103b83540 (size 192):
    comm "pool-0", pid 16970, jiffies 4377290937
    hex dump (first 32 bytes):
      00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace (crc 408ccc66):
      __kvmalloc_node_noprof+0x730/0x920
      handle_generic_event+0xec/0x1a0 [ksmbd]
      genl_family_rcv_msg_doit+0xe0/0x130
      genl_rcv_msg+0x181/0x290
      netlink_rcv_skb+0x4f/0x100
      genl_rcv+0x28/0x40
      netlink_unicast+0x1e6/0x2c0
      netlink_sendmsg+0x20a/0x450
      ____sys_sendmsg+0x2e8/0x310
      ___sys_sendmsg+0x78/0xc0
      __sys_sendmsg+0x63/0xc0
      do_syscall_64+0xa1/0x670
      entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c             | 1 +
 fs/smb/server/mgmt/user_config.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index bb8332caa9a71..e5b77d8754787 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -547,6 +547,7 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 		resp_ext = ksmbd_ipc_login_request_ext(resp->login_response.account);
 
 	user = ksmbd_alloc_user(&resp->login_response, resp_ext);
+	kvfree(resp_ext);
 	if (!user) {
 		ksmbd_debug(AUTH, "login failure\n");
 		retval = -ENOMEM;
diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index e9b3a8e049668..3d7c9b6b032e9 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -26,6 +26,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
 		resp_ext = ksmbd_ipc_login_request_ext(account);
 
 	user = ksmbd_alloc_user(resp, resp_ext);
+	kvfree(resp_ext);
 out:
 	kvfree(resp);
 	return user;
-- 
2.53.0



