Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FE12E424C;
	Tue, 15 Jul 2025 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587780; cv=none; b=rbdltxMaZDP5fiQa+d6RjIfttRlqOl9XJEDuOICjeeAp+MoF+gY54ubz7DeHa4PN1jAYZwRzVaUuPA2Uu5fhUotvd7W1yBV9gXBuaPV6ehwwisSX27ndLXoLcNWd/ikAoBr0JPMs4eocPx6Ug9Z5nmALPIGWFsZ+lKEX36lMe00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587780; c=relaxed/simple;
	bh=3oVxXjVuo4ePQQwnXoCX3UnERIGESwtGV4bO0BTBSLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnlPBWlzYBmNo5TKpl/hqf9phVr5WzF4CUrM3Dd8+sKZMzIt4KT5giaUhby3Yr9GtveKGhID1RSDMxLvi0PaOCG/TraAdo9syaWyv0G0OhpLR+ZV3/2qMTbeS4DyORLAUEHhHciLyefQKlrtzxr0yWO3vGCJsQechXHb2tUBf+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQP3UN7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQP3UN7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A68C4CEE3;
	Tue, 15 Jul 2025 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587780;
	bh=3oVxXjVuo4ePQQwnXoCX3UnERIGESwtGV4bO0BTBSLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQP3UN7EgU7tIzTKXLBlKzQZR3SUda0QfUvQahGhvoCerrrSGec+6juhqylum34l3
	 mRz80Scaq2N0fL5HVOob9vCq1MW/G7ahUCIEXK9gMeWz6gfmbIAg8ckMj/ICtxWZHB
	 lVAikmoyIypkVAR35hhNRNmu90P/1qAN2NaQ5gM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andra Paraschiv <andraprs@amazon.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/208] vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
Date: Tue, 15 Jul 2025 15:14:10 +0200
Message-ID: <20250715130816.574701069@linuxfoundation.org>
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

[ Upstream commit caaf95e0f23f9ed240b02251aab0f6fdb652b33d ]

Add VMADDR_FLAG_TO_HOST vsock flag that is used to setup a vsock
connection where all the packets are forwarded to the host.

Then, using this type of vsock channel, vsock communication between
sibling VMs can be built on top of it.

Changelog

v3 -> v4

* Update the "VMADDR_FLAG_TO_HOST" value, as the size of the field has
  been updated to 1 byte.

v2 -> v3

* Update comments to mention when the flag is set in the connect and
  listen paths.

v1 -> v2

* New patch in v2, it was split from the first patch in the series.
* Remove the default value for the vsock flags field.
* Update the naming for the vsock flag to "VMADDR_FLAG_TO_HOST".

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 687aa0c5581b ("vsock: Fix transport_* TOCTOU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/vm_sockets.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index 490ca99dcada1..4263c85593fa0 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -119,6 +119,26 @@
 
 #define VMADDR_CID_HOST 2
 
+/* The current default use case for the vsock channel is the following:
+ * local vsock communication between guest and host and nested VMs setup.
+ * In addition to this, implicitly, the vsock packets are forwarded to the host
+ * if no host->guest vsock transport is set.
+ *
+ * Set this flag value in the sockaddr_vm corresponding field if the vsock
+ * packets need to be always forwarded to the host. Using this behavior,
+ * vsock communication between sibling VMs can be setup.
+ *
+ * This way can explicitly distinguish between vsock channels created for
+ * different use cases, such as nested VMs (or local communication between
+ * guest and host) and sibling VMs.
+ *
+ * The flag can be set in the connect logic in the user space application flow.
+ * In the listen logic (from kernel space) the flag is set on the remote peer
+ * address. This happens for an incoming connection when it is routed from the
+ * host and comes from the guest (local CID and remote CID > VMADDR_CID_HOST).
+ */
+#define VMADDR_FLAG_TO_HOST 0x01
+
 /* Invalid vSockets version. */
 
 #define VM_SOCKETS_INVALID_VERSION -1U
-- 
2.39.5



