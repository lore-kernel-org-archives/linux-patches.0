Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BB72135C5;
	Thu,  3 Jul 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556126; cv=none; b=n+3OXgEkHYRjaBxeWEFMjU4PJq/kGeeznhVhwUYssGXTcuLk4RqZJvW5/QYdU9BR7DjPus+0ydRnqobOFIB2RqT8ygr348Cp23/qGtQ31JWnK8qV+jjk2ZEvmPRJZbpdQbCdfk+WVlhgIwMukEIvMxXhhg8rBoTx57qajWaGUmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556126; c=relaxed/simple;
	bh=eMBSBm1DZfSyEgY7Rfl3jhaP9mc/eADa23vz5Eq5QB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDSpeWvUcel478ef5MnYWocdN1P31/kuSYzffko6z+0PrlQPe29+y3v7hM4fGVWRU7m5pfO7Q3KEr4MfCjhsgvyuUYy4VZ5lsh9fl4ZJpQo9tQf7J2zSbIOtYAlXdPtW0zecHyPDoJk2cQAzliVsgQWMv+EP3kKpyLf9eECOiIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAsce9uL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAsce9uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B54DC4CEE3;
	Thu,  3 Jul 2025 15:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556126;
	bh=eMBSBm1DZfSyEgY7Rfl3jhaP9mc/eADa23vz5Eq5QB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAsce9uLAenGF/XQQmLmLWb6VE3bQfwlOAaJyilhpjcltqaOlr79Dgsj9f/PFDPPi
	 IpCS7D4c7X2mjMbAoJkhy1JISyklRXRsix1xm590BtYeqoOlk5zgEmakfqy/8wcnku
	 30J5f2NG7y6ndvcX72QTe+d1RLNvkl6NGr1+Dlmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/132] vsock/uapi: fix linux/vm_sockets.h userspace compilation errors
Date: Thu,  3 Jul 2025 16:42:51 +0200
Message-ID: <20250703143942.625786899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed07181d4eff9..e05280e415228 100644
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



