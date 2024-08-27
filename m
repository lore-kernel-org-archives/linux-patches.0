Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B691C6F56;
	Tue, 27 Aug 2024 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771938; cv=none; b=hs6yc7N3dvgyHs0gMvcNIi1rp6JshYs4Et+6AL88TxaR7SQHTizU0YDXQaUIfFRYB+/wKQY2j35l1N/effPKO0Ti/LmueUSAeg1ZFOhxjuEt73LPCE3pHejFoor+XsTsZveNwBSDlqtyf5By1iaRlGI8C09dp92O8MKVCdfKwCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771938; c=relaxed/simple;
	bh=5slZFjGhRXMSSsCFp4DL1mQedM7CoiudR4V9xb08Wao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwL0U4FyhCe1zrG1VpcuKtbMhBa/uAkQFQI/VM4rzO5+7PhhTl+stTQO1nGWkWGJK6I8CEBXVNWVvKONvSSH3idgy1N8A1UpqQUq99nQ397z6tZjcojFMI7bwNmssCzftgGtGjIOmxB6lDrdULOZYV8B3MA5gBeS1MCfc9jNQ88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abFn3fxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abFn3fxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDE7C61067;
	Tue, 27 Aug 2024 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771938;
	bh=5slZFjGhRXMSSsCFp4DL1mQedM7CoiudR4V9xb08Wao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abFn3fxsITKbaGnCvnUtoAArFjpIa4SRFnZ/w4DHLp9u9jkbym6pvIctzpLVAmfdC
	 LFJ3nqz2IGhcykFwHdE0BycPaq/MaesWIZLcRYh0m3nzscFaN7BoiJkIJlgaZkAwJp
	 HIqbB1ded/I+WOhnRUHAOj/TwO/1mNS9ABhz1aKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	syzbot+cb1d16facb3cc90de5fb@syzkaller.appspotmail.com,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/321] 9P FS: Fix wild-memory-access write in v9fs_get_acl
Date: Tue, 27 Aug 2024 16:35:43 +0200
Message-ID: <20240827143839.559662044@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit 707823e7f22f3864ddc7d85e8e9b614afe4f1b16 ]

KASAN reported the following issue:
[   36.825817][ T5923] BUG: KASAN: wild-memory-access in v9fs_get_acl+0x1a4/0x390
[   36.827479][ T5923] Write of size 4 at addr 9fffeb37f97f1c00 by task syz-executor798/5923
[   36.829303][ T5923]
[   36.829846][ T5923] CPU: 0 PID: 5923 Comm: syz-executor798 Not tainted 6.2.0-syzkaller-18302-g596b6b709632 #0
[   36.832110][ T5923] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
[   36.834464][ T5923] Call trace:
[   36.835196][ T5923]  dump_backtrace+0x1c8/0x1f4
[   36.836229][ T5923]  show_stack+0x2c/0x3c
[   36.837100][ T5923]  dump_stack_lvl+0xd0/0x124
[   36.838103][ T5923]  print_report+0xe4/0x4c0
[   36.839068][ T5923]  kasan_report+0xd4/0x130
[   36.840052][ T5923]  kasan_check_range+0x264/0x2a4
[   36.841199][ T5923]  __kasan_check_write+0x2c/0x3c
[   36.842216][ T5923]  v9fs_get_acl+0x1a4/0x390
[   36.843232][ T5923]  v9fs_mount+0x77c/0xa5c
[   36.844163][ T5923]  legacy_get_tree+0xd4/0x16c
[   36.845173][ T5923]  vfs_get_tree+0x90/0x274
[   36.846137][ T5923]  do_new_mount+0x25c/0x8c8
[   36.847066][ T5923]  path_mount+0x590/0xe58
[   36.848147][ T5923]  __arm64_sys_mount+0x45c/0x594
[   36.849273][ T5923]  invoke_syscall+0x98/0x2c0
[   36.850421][ T5923]  el0_svc_common+0x138/0x258
[   36.851397][ T5923]  do_el0_svc+0x64/0x198
[   36.852398][ T5923]  el0_svc+0x58/0x168
[   36.853224][ T5923]  el0t_64_sync_handler+0x84/0xf0
[   36.854293][ T5923]  el0t_64_sync+0x190/0x194

Calling '__v9fs_get_acl' method in 'v9fs_get_acl' creates the
following chain of function calls:

__v9fs_get_acl
	v9fs_fid_get_acl
		v9fs_fid_xattr_get
			p9_client_xattrwalk

Function p9_client_xattrwalk accepts a pointer to u64-typed
variable attr_size and puts some u64 value into it. However,
after the executing the p9_client_xattrwalk, in some circumstances
we assign the value of u64-typed variable 'attr_size' to the
variable 'retval', which we will return. However, the type of
'retval' is ssize_t, and if the value of attr_size is larger
than SSIZE_MAX, we will face the signed type overflow. If the
overflow occurs, the result of v9fs_fid_xattr_get may be
negative, but not classified as an error. When we try to allocate
an acl with 'broken' size we receive an error, but don't process
it. When we try to free this acl, we face the 'wild-memory-access'
error (because it wasn't allocated).

This patch will add new condition to the 'v9fs_fid_xattr_get'
function, so it will return an EOVERFLOW error if the 'attr_size'
is larger than SSIZE_MAX.

In this version of the patch I simplified the condition.

In previous (v2) version of the patch I removed explicit type conversion
and added separate condition to check the possible overflow and return
an error (in v1 version I've just modified the existing condition).

Tested via syzkaller.

Suggested-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Reported-by: syzbot+cb1d16facb3cc90de5fb@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=fbbef66d9e4d096242f3617de5d14d12705b4659
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/xattr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index 3b9aa61de8c2d..2aac0e8c4835e 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -34,10 +34,12 @@ ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
 		return retval;
 	}
 	if (attr_size > buffer_size) {
-		if (!buffer_size) /* request to get the attr_size */
-			retval = attr_size;
-		else
+		if (buffer_size)
 			retval = -ERANGE;
+		else if (attr_size > SSIZE_MAX)
+			retval = -EOVERFLOW;
+		else /* request to get the attr_size */
+			retval = attr_size;
 	} else {
 		iov_iter_truncate(&to, attr_size);
 		retval = p9_client_read(attr_fid, 0, &to, &err);
-- 
2.43.0



