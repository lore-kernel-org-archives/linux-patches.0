Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8430C618;
	Thu, 30 Jul 2026 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424770; cv=none; b=pqYeMkHJUX4WeEGbBJ87gGG4PnK/bWALQlWm2WDFQbGxGJ8lp9nOYE7OI/0nQQyzV2IAPO0IAcliot0nd6RKaYUJOJEdTvqb6OOKzACJkTGOFcTaJMSizqpsZ4RYRCUXerHcguU74xqJZPfnI9N+/KRzuiz053lRgG7LtsjFdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424770; c=relaxed/simple;
	bh=GrFRAw+db1bDpAniHkXNDfigeFvwgwO9WV0m+4UxCnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzGt7BUluuAgE/YK5vIHkhkCVMp8/880EqRuGP8jgJ9G2MoAR1vr5JH940+XVkxcIhJVDjE/ZgsBE3ImRW4fu6EB83jgsjNC8HJXrPGuohofv6szu0cMUrSEpKy9BefgeIE4jqqyuhCqKbzgTdXrYHX5eH+8a3uatAzBtxdonXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+wCNyMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+wCNyMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B861F000E9;
	Thu, 30 Jul 2026 15:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424769;
	bh=FuAkqavZnA7eWfsuqHeVpA7hLkYfr6aWoNRDBDjsWAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+wCNyMiOopscPCBdZbN/VjEtZNVz5EE7En9sDLcOuzXzhvPIxcJPk1hBIFrbySqa
	 vyZMWzqplNwWuPMc4ZL8R0SJVBI9VstsFlWKJCh7GVeD+xy6xirnXdNmmswp9/xO9E
	 jP0+fgca0Hz/fWELr1Nw5GqvGFhH2PthsYn3nZkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 503/675] mptcp: pm: userspace: fix use-after-free in get_local_id
Date: Thu, 30 Jul 2026 16:13:53 +0200
Message-ID: <20260730141455.818122598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 9bc6d5e4ca9f3cbb41d43400b3a31cb0403796c9 upstream.

In mptcp_pm_userspace_get_local_id(), the address entry is looked up under
spinlock, but its id is read after dropping the lock. A concurrent deletion
can free the entry between the unlock and the read, leading to UAF.

The race window is narrow. It was reproduced only with a locally
constructed stress test that repeatedly overlaps an MP_JOIN SYN with a
MPTCP_PM_CMD_SUBFLOW_DESTROY request.

However, the KASAN report below confirms that the race is reachable:

  [  666.319376] BUG: KASAN: slab-use-after-free in mptcp_userspace_pm_get_local_id+0x1dc/0x1f0
  [  666.319386] Read of size 1 at addr ffff888124845610 by task swapper/0/0
  ...
  [  666.319401] Call Trace:
  [  666.319405]  <IRQ>
  [  666.319408]  dump_stack_lvl+0x53/0x70
  [  666.319412]  print_address_description.constprop.0+0x2c/0x3b0
  [  666.319418]  print_report+0xbe/0x2b0
  [  666.319421]  ? mptcp_userspace_pm_get_local_id+0x1dc/0x1f0
  [  666.319423]  kasan_report+0xce/0x100
  [  666.319426]  ? mptcp_userspace_pm_get_local_id+0x1dc/0x1f0
  [  666.319429]  mptcp_userspace_pm_get_local_id+0x1dc/0x1f0
  [  666.319433]  mptcp_pm_get_local_id+0x371/0x440
  ...
  [  666.319821] Allocated by task 45539:
  [  666.319844]  kasan_save_stack+0x33/0x60
  [  666.319855]  kasan_save_track+0x14/0x30
  [  666.319858]  __kasan_kmalloc+0x8f/0xa0
  [  666.319863]  __kmalloc_noprof+0x1e7/0x520
  [  666.319867]  sock_kmalloc+0xdf/0x130
  [  666.319885]  sock_kmemdup+0x1b/0x40
  [  666.319888]  mptcp_userspace_pm_append_new_local_addr+0x261/0x500
  [  666.319910]  mptcp_pm_nl_announce_doit+0x16a/0x610
  ...
  [  666.319967] Freed by task 45560:
  [  666.319988]  kasan_save_stack+0x33/0x60
  [  666.319991]  kasan_save_track+0x14/0x30
  [  666.319994]  kasan_save_free_info+0x3b/0x60
  [  666.319998]  __kasan_slab_free+0x43/0x70
  [  666.320000]  kfree+0x166/0x440
  [  666.320003]  sock_kfree_s+0x1d/0x50
  [  666.320007]  mptcp_userspace_pm_delete_local_addr.isra.0+0x157/0x200
  [  666.320011]  mptcp_pm_nl_subflow_destroy_doit+0x51d/0xea0

Fix by copying the id into a local variable while still holding the lock,
and use -1 as a "not found" sentinel.

Fixes: f012d796a6de ("mptcp: check addrs list in userspace_pm_get_local_id")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Tested-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260722-net-mptcp-misc-fixes-7-2-rc5-v1-2-6fb595bc86ef@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -132,12 +132,15 @@ int mptcp_userspace_pm_get_local_id(stru
 	__be16 msk_sport =  ((struct inet_sock *)
 			     inet_sk((struct sock *)msk))->inet_sport;
 	struct mptcp_pm_addr_entry *entry;
+	int id;
 
 	spin_lock_bh(&msk->pm.lock);
 	entry = mptcp_userspace_pm_lookup_addr(msk, &skc->addr);
+	id = entry ? entry->addr.id : -1;
 	spin_unlock_bh(&msk->pm.lock);
-	if (entry)
-		return entry->addr.id;
+
+	if (id != -1)
+		return id;
 
 	if (skc->addr.port == msk_sport)
 		skc->addr.port = 0;


