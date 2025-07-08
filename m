Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46522E266B;
	Tue,  8 Jul 2025 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993935; cv=none; b=k/5TjqRX8nXu7yyQXyOnuxdvqRTj+ui9dekHYgRxl4a/QdBmR+FK0AmaxswlA2/CiuZUvGpwO6h85BGxLUkajfP4E5gBKbkb4rQSN66U8l5i5bKAaEdRhk7cLgJqmoYBw3qeW1+Bm4aro71evcpq4f3YA23hCaPs/WyvLVwYSBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993935; c=relaxed/simple;
	bh=ELrox8P9yDEqw1u2GtK2bBLEZ3qA4vWKP1mcGfut1S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HSmGv04zxw5TU3TFv5LzoBnpr+hnKEsAWrFcoxp07uM2BsxR5OZCLSWlj1XvJoTnWtysoP9fPp0XYJT5QkXVqcEwLfGxNrXVHOJNZCtIPubQlPHqTGcjZmS4f6CRwrwgQk3JM7MFJQaTjeQEK7/gzsHDNKUMjLJ9I+3ni420wfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPdasRYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPdasRYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C850C4CEED;
	Tue,  8 Jul 2025 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993935;
	bh=ELrox8P9yDEqw1u2GtK2bBLEZ3qA4vWKP1mcGfut1S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPdasRYjoA1YJRCzozj1cG4MdixYV2hlfHn5PHVqM/k7HGrd6T/yxwTsT5glUQF4I
	 hSydKeRT0K9JYc6HqFXrSppJFUnG7p6FyzR+jY7S/yOGhmCXGysxo5MOQtxKLG92KG
	 Iw2aq2FR+biZGrlK4dMwjkUFz/0fMLGy6lAgiywY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/160] vsock/uapi: fix linux/vm_sockets.h userspace compilation errors
Date: Tue,  8 Jul 2025 18:21:44 +0200
Message-ID: <20250708162233.408299914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 46918a1852d7b..4263c85593fa0 100644
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
 #include <linux/types.h>
 
-- 
2.39.5



