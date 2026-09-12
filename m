Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD18357CFA;
	Sat, 12 Sep 2026 11:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211425; cv=none; b=bx27ByL94KUJy/DJZ47YyFZXZjI5uI0FAhtPXqj/mwHULBGNp0Nh0boiyWOq5ffnHJm1lFGsm1rq2tnF5PvBZ4Q0CuZFVPGY7BQC4lZCmCoIlvF1McihPkynv4X2R3h9wDgIMoSUyK+qTLsNWG9g6fdcf5uIz7HAWGA044yy0oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211425; c=relaxed/simple;
	bh=lhcNRSLuDsiYYDYg1x5vwyJynabd4AVfIPF39l/XSOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okG15lpNo2CB3qCLd6/JH99ji/9lIBPRxrlygm07FeFnD28vWGVyrFbfJ8kDF+jLhBZg3wFDh/53F7CBbOZDXS69b1iR03BUExv74bSVHX7Hq30ovL6oyvr0jMdPLFmU4fvw4u+gW+NTi1RoNjB43RBX9TT0g0y6u6drFC0Q/zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbll5XwD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbll5XwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AC81F000FF;
	Sat, 12 Sep 2026 11:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211423;
	bh=CS36a/8Kqu8SBg6q1Jc+47SEGLHIpeQXZ0a15ACep8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbll5XwDNOY+FnfE14j6oA0rRp/Z0CB95EestnLU1sOcaVgv3wglhsD6szdMChKt5
	 35FacPjyen2/eBxIqoYzkP6KQTuBi3KkWFGh0cElQWIThxM6ZuyrY9fdQM6NlLvTgf
	 v9RzcRrNiz4gyo/VijfoWzEjP6zcqnyZrWmj4Od4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1227/1518] smb: server: fix leak of ksmbd_ipc_login_request_ext() returned buffer
Date: Sat, 12 Sep 2026 08:56:36 +0200
Message-ID: <20260912065651.259409927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3f8258954901b..e85d7b0ded30e 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -436,6 +436,7 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 		resp_ext = ksmbd_ipc_login_request_ext(resp->login_response.account);
 
 	user = ksmbd_alloc_user(&resp->login_response, resp_ext);
+	kvfree(resp_ext);
 	if (!user) {
 		ksmbd_debug(AUTH, "login failure\n");
 		retval = -ENOMEM;
diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index d051ac3bc831c..53db14e91bfd8 100644
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



