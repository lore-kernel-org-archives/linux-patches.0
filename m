Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511AA57C9F;
	Wed, 23 Apr 2025 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422325; cv=none; b=VYT45DUxccj3BCRo27DHYTi+dP0EaGo1jhPgc/Fy4lrMhe8j+jjaOssfsyxfCJAwhcPZXF0rYjZhahnuOWfxgJkiTb8jHJcQirLBiOO4T3h1grN6bq2QQO415xT/P9XJ0Hw2WEyV76VAlPb9eooIzpgM8qrTRVuwv6XIGuA3k3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422325; c=relaxed/simple;
	bh=Y1IdUxBw8gsAkI8R/XmfGtau0syQdpL0k0w6HYRjJrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us0s8exwhliaNlcmF320kaVjNrDpJFSv9qZPLY+vxnHwfZo+lKkO+D5aTCkRCiW9WykwvBld1gcFssry8JfnUr0EPIpOyyqCdFzFoXQ9OyzeFD0krcvcXiBQPROclg2jRQpMY2kJ/Ec7fb2FDbsQKWsLMEetwNRF+wAnDREMXiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k059ddC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k059ddC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F1BC4CEE3;
	Wed, 23 Apr 2025 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422325;
	bh=Y1IdUxBw8gsAkI8R/XmfGtau0syQdpL0k0w6HYRjJrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1k059ddCKzqGtVNKClX71Y2lZyPESc5XE0b6ZeNhBkvTvPRcwXTCFY9HESn4bg7ik
	 nDJ9zUdT1NFORG/2C+VQfKAWtEv6alrYv1t4t93pyI0anog1cerzQ3L9RhuWPfrkrQ
	 dqY7m07q5CoSwZDyag8EfinDxXzIbrTi079McIwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 277/291] smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()
Date: Wed, 23 Apr 2025 16:44:26 +0200
Message-ID: <20250423142635.751661125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

commit 4e8771a3666c8f216eefd6bd2fd50121c6c437db upstream.

null-ptr-deref will occur when (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
and parse_lease_state() return NULL.

Fix this by check if 'lease_ctx_info' is NULL.

Additionally, remove the redundant parentheses in
parse_durable_handle_context().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Drop the parentheses clean-up since the parentheses was introduced by
  c8efcc786146 ("ksmbd: add support for durable handles v1/v2") in v6.9
  Minor context change fixed ]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c  |    2 +-
 fs/smb/server/smb2pdu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1515,7 +1515,7 @@ void create_lease_buf(u8 *rbuf, struct l
  * @open_req:	buffer containing smb2 file open(create) request
  * @is_dir:	whether leasing file is directory
  *
- * Return:  oplock state, -ENOENT if create lease context not found
+ * Return: allocated lease context object on success, otherwise NULL
  */
 struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 {
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3243,7 +3243,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
-		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
+		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			/*
 			 * Compare parent lease using parent key. If there is no
 			 * a lease that has same parent key, Send lease break


