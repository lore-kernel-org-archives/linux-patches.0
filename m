Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220D32EA746;
	Tue, 15 Jul 2025 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586455; cv=none; b=SO9MOtNGKH23EdFW1VgXoJSmD3BpdNtnGhHAllQwl5EOrcT54MZHyQPZurLXtuxr0DpD25Rb+898fc3mDAmN8XyF3GOB7cSR9Dvz/e8JgeFu8T2hwcDNvgw8JpbGGX7YYseAFlZ88/vBXUPLaSIbiwlRfwtcF4TaSHwi3CmX5pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586455; c=relaxed/simple;
	bh=ksmy/UNubdp7Tzc89nQDLEPRuhuDajkx3danH2SVBik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CX/FdJmT1gWpGANryraz8vpJyrn9/XiX7QRzRZpDFw8KvBnb5b1O0FnZuq7jAX9LrEdOVDK+auIs4P3IbAYNajMEPol3tONstOLdvToPIUYNbNwtrLmieebc5LE07WAUJP0etdUuxfZV3UoJP8VX4xwobVui2GOWsFZWFoNdXho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJk1rBcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJk1rBcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D4FC4CEF1;
	Tue, 15 Jul 2025 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586454;
	bh=ksmy/UNubdp7Tzc89nQDLEPRuhuDajkx3danH2SVBik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJk1rBcjJlVMlkQck4uZlw0yTYEG/FwRGY5Peuvp1vRElSpGn07DPKbHb9pETtCz3
	 RpfpLfi2dLWW0EVluuNmtUGwEDND91XtgDeaoEQwTNSoktgjIkwqUfIwG5Un44+u69
	 AiXQEzA+nnjCkuv37a7eryJOOPZ5EXoCrCUAbxPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/148] vsock/uapi: fix linux/vm_sockets.h userspace compilation errors
Date: Tue, 15 Jul 2025 15:12:42 +0200
Message-ID: <20250715130801.921091802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 22bbc1dcd0d6785fb390c41f0dd5b5e218d23bdd ]

If a userspace application just include <linux/vm_sockets.h> will fail
to build with the following errors:

    /usr/include/linux/vm_sockets.h:182:39: error: invalid application of ‘sizeof’ to incomplete type ‘struct sockaddr’
      182 |         unsigned char svm_zero[sizeof(struct sockaddr) -
          |                                       ^~~~~~
    /usr/include/linux/vm_sockets.h:183:39: error: ‘sa_family_t’ undeclared here (not in a function)
      183 |                                sizeof(sa_family_t) -
          |

Include <sys/socket.h> for userspace (guarded by ifndef __KERNEL__)
where `struct sockaddr` and `sa_family_t` are defined.
We already do something similar in <linux/mptcp.h> and <linux/if.h>.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20250623100053.40979-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/vm_sockets.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index 68d57c5e99bc0..f763d1caf27df 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -17,6 +17,10 @@
 #ifndef _UAPI_VM_SOCKETS_H
 #define _UAPI_VM_SOCKETS_H
 
+#ifndef __KERNEL__
+#include <sys/socket.h>        /* for struct sockaddr and sa_family_t */
+#endif
+
 #include <linux/socket.h>
 
 /* Option name for STREAM socket buffer size.  Use as the option name in
-- 
2.39.5



