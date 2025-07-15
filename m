Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55B42E92C2;
	Tue, 15 Jul 2025 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587545; cv=none; b=oAXyK0InV1wuLQDfZPSdtkZLk3boJ1PjpzpJvkw9c4RdT7KZIdIal4H3d0c6Eh41TXBtoOYNPFWOVooS9n4V1Frlm3bECsM62TodYTri0RLk1AxZ+hNw00ADMycEINLsawWXqUp8TLnni6VqVfa/5HXERxZPEHE/V0Eskp6Xv8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587545; c=relaxed/simple;
	bh=fX4aUcGKHfWt9i0UM+HwPV62ayXXJKcmbwOp8KSZYww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FoO93eImudnFBiWFzxQ2apzBKSrrxda4DUqQgY6jNp4KrHQNvOqu1XNSgGUegu8MwuvG5Fuj/yA4hMmycfxCeSK3WTdbhPxOhJ7P1NGs0mDu6ZzLVUFxNhoLBHMP/DdJVG+FACUxM4wBeLEUCHOBHdqllSPAJ4LT+i6o6nmOaI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ye2LUGKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ye2LUGKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C7DC4CEF1;
	Tue, 15 Jul 2025 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587545;
	bh=fX4aUcGKHfWt9i0UM+HwPV62ayXXJKcmbwOp8KSZYww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ye2LUGKzJhdJhFb0bEcKcDFjhIt4kGR7lz+f74SQx/12EXL4RW8KTcbCKzFZUMUV4
	 F6ptlmXYn5YjzfAS+UU1iVFyQ+bESgPcLucFa6kIEdvUH1SOAmIikQVfxHAuBk64pI
	 qWm/VOy6YiJcbTi2F/iK2+/Sx8Sldc+UQXeOorvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/208] vsock/uapi: fix linux/vm_sockets.h userspace compilation errors
Date: Tue, 15 Jul 2025 15:12:41 +0200
Message-ID: <20250715130813.036269900@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fd0ed7221645d..67e3938e86bd0 100644
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



