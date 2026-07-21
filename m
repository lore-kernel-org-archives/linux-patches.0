Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593773D3321;
	Tue, 21 Jul 2026 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654734; cv=none; b=tE5HuqdeX7to3OvuVz0dxLme+kTCqq2FEgHT78R+aplkmewF9erEdcBt0aX1lUyb8fhD6CghtaXemAADRMGUdK/whpQb4HWMbMp+2s1SYIGbmkuh35svTUp+sPrA0K+emAT6bsKtoF1HAADRGlhCTzu/1Ji6sZQs9GaD2W/op/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654734; c=relaxed/simple;
	bh=VilFUno4bLgeaypHjmYEKcsGvyNewgZhGyeNWtJVlas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJjyJAshZRoCKcPlMJlLt3CZjTuzHxKOm5CFHsCryZR4pdm8+rLc+eDg5Mnd3HteyWogC9aHIlgQ0LTy9xlzGcKCWDsTKM3AgJ0WZiTa22QH5F9SVCkbrqdoxh2ezvwur2xWEWLv8UItaJwApmSr+os457gqz3BJhMaTZovSTkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp9L45Tw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp9L45Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC951F000E9;
	Tue, 21 Jul 2026 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654733;
	bh=ompKkpgKhFI7+Sb0gzQ526vqL/vG8DjX69j2oIyThQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tp9L45Tw31UV0r3Oo8jo0VERwmCQqwGdoZScMeQVSZLGzeqxaLd4nU7zOjHCAlxdt
	 axox50Yht1hSWpRArQa2ejJTz5WPSW4KE6TEXH2HP9efbWFHKRFcOGpuLdsRXIeMKS
	 HtievhJu0MyNTn5GQPqRl4770h2fII3Jq7m6s0xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Joe Damato <joe@dama.to>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1817/2077] netdev-genl: report NAPI thread PID in the callers pid namespace
Date: Tue, 21 Jul 2026 17:24:50 +0200
Message-ID: <20260721152635.602966580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


