Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF063C1081;
	Tue, 21 Jul 2026 22:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671359; cv=none; b=u+kxuT9VwhTvmR3+0jH6q41JCnN+1NlzbBFqy6BfQlt011HHO9Qc4Dr19qyBVjKmauPrqnpNNBjOk6A+Ah5JM/LW3GkS6i1w1wyqmWK3ErlLLQTlsMNq2PxaxDsvcw3Jy7xNr5fKzO34B7KnbVtxEp6G8liRrr25w90dcxIr28k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671359; c=relaxed/simple;
	bh=njFZ4EcTt5dYSiZYgTPtzqy8OfDlnzY4dyHa7pg9cII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTnseL995o3CHOP9KGwjMHy4RFdocPnrqfjHfjwru6I/69MTvqaeW7eiaat8m+WIRy/SlpuNqUb0re5HrQht8d2CVBIyWSU2hqOjgVJ1G7pAnLeJld60s7S11oMnUw2GWl3qXjNSJ11BJDbRJBI8DFjomeOwg6MuFNIT4PrMs90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpBRAdZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpBRAdZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD47F1F000E9;
	Tue, 21 Jul 2026 22:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671358;
	bh=sE88E2dFLKBXpquVd8mdsXzGEFmOaa4JQ109SqiKxWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpBRAdZzuMDeDg1+xNS58H2UUk52qUe64Uf/DBd1si9Du6uz5scS7KiXX265DTnKN
	 Yee0LLqHUiJ0AxljyZpMRlbbkhn51KWRUj2Qfq0NuNg3hfkJktlOojZoWJ/WzvehRT
	 T3Lt7GLswupSgUtdqo2mF5oExrLXoigucxcjMWuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 214/843] afs: fix NULL pointer dereference in afs_get_tree()
Date: Tue, 21 Jul 2026 17:17:29 +0200
Message-ID: <20260721152410.831808297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

commit 0b70716081c6462be9b2928ad736d0d527b09678 upstream.

afs_alloc_sbi() uses kzalloc for memory allocation. And, if
ctx->dyn_root is not null, as->cell and as->volume are null.
In trace_afs_get_tree() they are dereferenced.

KASAN error message:

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 2 PID: 18478 Comm: syz-executor.7 Not tainted 5.10.246-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1
04/01/2014
RIP: 0010:perf_trace_afs_get_tree+0x1d9/0x550
include/trace/events/afs.h:1365

Call Trace:
trace_afs_get_tree include/trace/events/afs.h:1365 [inline]
afs_get_tree+0x922/0x1350 fs/afs/super.c:599
vfs_get_tree+0x8e/0x300 fs/super.c:1572
do_new_mount fs/namespace.c:3011 [inline]
path_mount+0x14a5/0x2220 fs/namespace.c:3341
do_mount fs/namespace.c:3354 [inline]
__do_sys_mount fs/namespace.c:3562 [inline]
__se_sys_mount fs/namespace.c:3539 [inline]
__x64_sys_mount+0x283/0x300 fs/namespace.c:3539
 do_syscall_64+0x33/0x50 arch/x86/entry/common.c:46
entry_SYSCALL_64_after_hwframe+0x67/0xd1

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 80548b03991f5 ("afs: Add more tracepoints")
Cc: stable@vger.kernel.org
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-4-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -596,7 +596,8 @@ static int afs_get_tree(struct fs_contex
 	}
 
 	fc->root = dget(sb->s_root);
-	trace_afs_get_tree(as->cell, as->volume);
+	if (!ctx->dyn_root)
+		trace_afs_get_tree(as->cell, as->volume);
 	_leave(" = 0 [%p]", sb);
 	return 0;
 


