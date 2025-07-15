Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFB826D4F2;
	Tue, 15 Jul 2025 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587777; cv=none; b=hIh595WLqR1BEyGj70knVMFhsr52yNvhJMsPIqWB8AubQtSJssKAYwePaqYR90XJUd8UaXmS5yiWd5tS8py4pMrH+qgSNZIYV7poiuLs0c6YnG0ygIQyxzaCHhaaDnejMZCxCN15TeITu1o1Bi45i0ndi4QoHOjU1j6fo8H0uf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587777; c=relaxed/simple;
	bh=hpzorVeN8rqteMINtD0rbZ8yxDeIqju3zjwTMvA8//k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYq6CxzyefokipaiFso0GEkbcl46XdYHExSLhXHIlQ+HZAtVYh3hXMBBD/PIc0HR7FmqIabGQJTi01kyU+L1/buueySllUhrHxsFrr5QhvzHnDxC5elSTOsK/WIz/oQLLexiWsN0q+mCO+cnw31zchd0y+Bco8wJWCnWz6dLQC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMsRb0lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMsRb0lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388B2C4CEE3;
	Tue, 15 Jul 2025 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587777;
	bh=hpzorVeN8rqteMINtD0rbZ8yxDeIqju3zjwTMvA8//k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMsRb0lTkMoVVI0zQb5Ykg4HKEwBMuGgFgtiEj15J4FVjQUBimTdBQjlUA7hAO+b1
	 4Fo2ECZUY2AV7uT7GbrGr5P+3dEp5nB81Ob/gAs8jsl1FaepzR0zh4KeaSNX2mSF2O
	 XZ2PEMS0ZWh+3GL/C/BuM34NiP+PoGUAEpH8PnBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andra Paraschiv <andraprs@amazon.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/208] vm_sockets: Add flags field in the vsock address data structure
Date: Tue, 15 Jul 2025 15:14:09 +0200
Message-ID: <20250715130816.535062280@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andra Paraschiv <andraprs@amazon.com>

[ Upstream commit dc8eeef73b63ed8988224ba6b5ed19a615163a7f ]

vsock enables communication between virtual machines and the host they
are running on. With the multi transport support (guest->host and
host->guest), nested VMs can also use vsock channels for communication.

In addition to this, by default, all the vsock packets are forwarded to
the host, if no host->guest transport is loaded. This behavior can be
implicitly used for enabling vsock communication between sibling VMs.

Add a flags field in the vsock address data structure that can be used
to explicitly mark the vsock connection as being targeted for a certain
type of communication. This way, can distinguish between different use
cases such as nested VMs and sibling VMs.

This field can be set when initializing the vsock address variable used
for the connect() call.

Changelog

v3 -> v4

* Update the size of "svm_flags" field to be 1 byte instead of 2 bytes.

v2 -> v3

* Add "svm_flags" as a new field, not reusing "svm_reserved1".

v1 -> v2

* Update the field name to "svm_flags".
* Split the current patch in 2 patches.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 687aa0c5581b ("vsock: Fix transport_* TOCTOU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/vm_sockets.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index 67e3938e86bd0..490ca99dcada1 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -22,6 +22,7 @@
 #endif
 
 #include <linux/socket.h>
+#include <linux/types.h>
 
 /* Option name for STREAM socket buffer size.  Use as the option name in
  * setsockopt(3) or getsockopt(3) to set or get an unsigned long long that
@@ -152,10 +153,13 @@ struct sockaddr_vm {
 	unsigned short svm_reserved1;
 	unsigned int svm_port;
 	unsigned int svm_cid;
+	__u8 svm_flags;
 	unsigned char svm_zero[sizeof(struct sockaddr) -
 			       sizeof(sa_family_t) -
 			       sizeof(unsigned short) -
-			       sizeof(unsigned int) - sizeof(unsigned int)];
+			       sizeof(unsigned int) -
+			       sizeof(unsigned int) -
+			       sizeof(__u8)];
 };
 
 #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
-- 
2.39.5



