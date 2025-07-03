Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACCC72610;
	Thu,  3 Jul 2025 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554167; cv=none; b=uFU3QXfc9wGVVTb2D562bRotS3opCJesLchu0TOU9vOE37DmYEPkinxVWdaRyhJ2IBAV85fYPNJDoItpMkA6pXWEM8KP2zGLMSgqykHNY+Z7wif2INVaAmmJH4yr7viIySMSbcqEo1kTzyDOpu1qatzCqXFiSMCo22Uk6Zu4IbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554167; c=relaxed/simple;
	bh=Ed2z0YVNguD5DaEKVzBXhMQI0YFDYYFwOh0yXJagC94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbOXH2xHYcFJpPwqhuop0bXGcF9S5ON5u2yGAJlz8DuosGM92YrqbDpcmLXKVf9LNTpK2Tpj/GoZ83ZWfC7vAceXB3HO7WJkJAHBo/YHKfxgmaGlfIy/ztZvMnBvam6x5iXxuKmPaiETvFWcOWp55+OTwdFMCOQq7oK7sx73XCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le9pPPPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le9pPPPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1204EC4CEE3;
	Thu,  3 Jul 2025 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554167;
	bh=Ed2z0YVNguD5DaEKVzBXhMQI0YFDYYFwOh0yXJagC94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Le9pPPPizvMBKbFjpwBlEFqOnXyDPsHjkJ6lxpN7/dAnGjQuWD6pxtEEX7THvcpwh
	 5/9vQ+5NB6ko4gtxsHn3d4/wi5+b28hFByQNoxUEPu8D/9S8e38vP7p4EvYSugfnXX
	 D3TRn1YqdjiNXrfxTPaYqvAXJtQo4si0CNve3mHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/218] vsock/uapi: fix linux/vm_sockets.h userspace compilation errors
Date: Thu,  3 Jul 2025 16:40:50 +0200
Message-ID: <20250703144000.019507149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



