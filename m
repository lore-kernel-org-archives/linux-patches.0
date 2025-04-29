Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E98243364;
	Tue, 29 Apr 2025 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949141; cv=none; b=Af57DYFeM70QXIVWcnESSaFBGxhGo/Lur2jIk1FN2Vxx7IcnfzDzdrszUmw237IKXEnxrjtYfDP3C4J4x6ddDWE08sfni/iT+tpMxFpfgAv39ORnDC613f7FdbQDHPJv03R4s8h9zq7OFDO1UK0ONncGM/8+ysTFrSnXGF8Yv9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949141; c=relaxed/simple;
	bh=uDQ0F3Dair9U8TST7jnRXOnk4wJ1QYBpWtP95A/5aDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7yw2Y2jYhdLclpUo9JNkGdTE5JWHDHjYjPPEy4Oo0pxpFuGqq9zgZExiFY8ka5kvO6siYk5g2jiFZgtyxOR63196Qfs6w3zsSmcK2Q3/OsEN+JpzYejDewS/uMVsOR2lhKrYlyrFp7RodWDVmqTb9Jen9ebTdvpicwRq4vlYkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5M8Lf8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5M8Lf8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0D6C4CEE3;
	Tue, 29 Apr 2025 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949140;
	bh=uDQ0F3Dair9U8TST7jnRXOnk4wJ1QYBpWtP95A/5aDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5M8Lf8c+1OmmqOeZnlVJSShErw61Soz0P8Xh5OoZD+VZ/EzxYcj23PlHIQ2EMeJl
	 dD0QrZv0hTE+k/jB2ZlME7cVlAXHbPLF8ZyW8E/XKI5Tg5UMh9KF4oB6wuou3J77zA
	 0RltnxR4CBbeWuln8i94Oi7uHzubdCGcg86TqLKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 226/373] smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()
Date: Tue, 29 Apr 2025 18:41:43 +0200
Message-ID: <20250429161132.444308683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/oplock.c  |    2 +-
 fs/ksmbd/smb2pdu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1498,7 +1498,7 @@ void create_lease_buf(u8 *rbuf, struct l
  * @open_req:	buffer containing smb2 file open(create) request
  * @is_dir:	whether leasing file is directory
  *
- * Return:  oplock state, -ENOENT if create lease context not found
+ * Return: allocated lease context object on success, otherwise NULL
  */
 struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 {
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3230,7 +3230,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
-		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
+		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			/*
 			 * Compare parent lease using parent key. If there is no
 			 * a lease that has same parent key, Send lease break


