Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F11A436BC6;
	Tue, 21 Jul 2026 19:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663881; cv=none; b=nFniviUWJbDNDz0ww8YmwRm2jTjKEPBaHVhmuyjjaBvltfEkMQmNh/inJ8nitb05FNQv36LNQcuPBMbjSMP0y4lo8fBReKADBpHUZenRko0m7pre2ApzK02UlPNk654bjUi9DKYXXN3PD+5gFC7IdelxhU/d3K7ItmSSD1onpX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663881; c=relaxed/simple;
	bh=efKOGzO6Rw8ixRgTsKxOl+YOHp7uZMYgF6EHnD6AEUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXqUCx8mHTVo6Sf2lBtJIeVie5Q4v/T3iI48dfq/6rJvzk5bjCPO41+vxKyuqCUAjwg1Lb4YVTTj8rfgQpiKrQHjlLotYEI0JhxhjEEsCp9JoLCjdXerDVcAE7A8NiyM5ynV7J6leN1TqFMdaHjm9FtAY3/Z1XCZPu0Gh8KcmV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LWO41q5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LWO41q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F1C1F00A3D;
	Tue, 21 Jul 2026 19:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663879;
	bh=Dd137DBq0DBH2zz6U6vonmherHS7f8zLU83fsioGM8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2LWO41q59roJBGIOXUiG2wsRHgji2dlFlLp0oUhVNZ//2DB5i9KYI0Izn4opy19S2
	 o8eIChSOdE2ov1KsS3rypIZxpwUOmIPsGtSL9RjpwnPozBvD4GvLmZPSGWqCf2T24X
	 FlmAYi3ZwwdiPr1DfR78Be2HdxSjdvWu8SrWgxY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Joe Damato <joe@dama.to>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0990/1276] netdev-genl: report NAPI thread PID in the callers pid namespace
Date: Tue, 21 Jul 2026 17:23:53 +0200
Message-ID: <20260721152508.168084107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -181,7 +182,8 @@ netdev_nl_napi_fill_one(struct sk_buff *
 		goto nla_put_failure;
 
 	if (napi->thread) {
-		pid = task_pid_nr(napi->thread);
+		pid = task_pid_nr_ns(napi->thread,
+				     task_active_pid_ns(current));
 		if (nla_put_u32(rsp, NETDEV_A_NAPI_PID, pid))
 			goto nla_put_failure;
 	}


