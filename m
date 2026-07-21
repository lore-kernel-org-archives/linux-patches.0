Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F046EF82;
	Tue, 21 Jul 2026 18:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658934; cv=none; b=k5SmKRNtcwITgUW4p5GEdkscfO8XSOaeKVVFGnaryVM/7WX+C2z2eQ64rWl6JZH8M67+aIQQug+oSBKHdzCx/QelLK7FHa3IPVN9/MSK2wE6KHYz6IkjontLS31cek/6GvxkMo6oriqYhvPe4nZH+XDgP3qyRn43baWXYAAgP30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658934; c=relaxed/simple;
	bh=quPNS3H8tW7mXvs9tAvtVQw/WwC4/p8xUyO2NeFDyf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g506b3df969xHyz73TzfUCsB9P0uXQ8DdTgTW6aCIGWxUfLQX9yp7lgACsF7zuDS3H/bfsEZKNz8+hHNbSieYVf/XTTFXnON3SNwWGAStEkaxdLPMKctT9jz7SD+SWCe78WXCLmwevXlPUn2YCRwvSYV6kVxKoG2D32B/4klDak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDRXoH8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDRXoH8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE49E1F00A3A;
	Tue, 21 Jul 2026 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658933;
	bh=Aw6JlgrhQVNq1uuBirctWo/M11pQnVRUIxmR839iMlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDRXoH8oGWkXrrzZUTHApLWUMfuBNEeS1192/Voi+KdkSR/cJcyk19kMzHsb4N/89
	 SG/pCKyuSl6M61bMyia3O1y0gyIJ76WwYe2Iei/bDgvVkbcxOSvUg5JdLwa5Y8gnh8
	 WhPPB8kRnKPj21wHiy7ZuI168oG7IWnUP09FYv5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Joe Damato <joe@dama.to>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1330/1611] netdev-genl: report NAPI thread PID in the callers pid namespace
Date: Tue, 21 Jul 2026 17:24:06 +0200
Message-ID: <20260721152545.368949606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 1f24c0d01db214c9e661915e9972404c96ca73c0 upstream.

netdev_nl_napi_fill_one() reports the NAPI kthread PID in NETDEV_A_NAPI_PID
using task_pid_nr(), which returns the PID in the initial pid namespace.

NETDEV_CMD_NAPI_GET does not have GENL_ADMIN_PERM and the netdev genl family
is netnsok, so a caller in a child pid namespace can issue it. That caller
then sees the kthread's global PID, even though the kthread is not visible
in its pid namespace, where the value should be 0.

Translate the PID through the caller's pid namespace, the same way commit
3799c2570982 ("io_uring/fdinfo: translate SqThread PID through caller's
pid_ns") did for the io_uring SQPOLL thread. The doit and dumpit paths both
run synchronously in the caller's context, so task_active_pid_ns(current) is
the caller's pid namespace.

Fixes: db4704f4e4df ("netdev-genl: Add PID for the NAPI thread")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Link: https://patch.msgid.link/20260615171736.1709318-1-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netdev-genl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -2,6 +2,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/notifier.h>
+#include <linux/pid_namespace.h>
 #include <linux/rtnetlink.h>
 #include <net/busy_poll.h>
 #include <net/net_namespace.h>
@@ -189,7 +190,8 @@ netdev_nl_napi_fill_one(struct sk_buff *
 		goto nla_put_failure;
 
 	if (napi->thread) {
-		pid = task_pid_nr(napi->thread);
+		pid = task_pid_nr_ns(napi->thread,
+				     task_active_pid_ns(current));
 		if (nla_put_u32(rsp, NETDEV_A_NAPI_PID, pid))
 			goto nla_put_failure;
 	}


