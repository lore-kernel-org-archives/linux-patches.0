Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD026D4F2;
	Tue, 15 Jul 2025 13:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587783; cv=none; b=drFYLuVl3K8j/Id0SK8uLEyUprcVDsHVZmETdpvGPOvTpKHxol6j8Q0dZJceGY3Nz+4TNifGjo9leQkBiUK/8D3A6bm0glHX5EvhzJJeplX2v66f3igbhVqkQDm8LgmP0auinwyMAl4y9jk285fE4fiM81J2v71k8ZUhaK97VOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587783; c=relaxed/simple;
	bh=IeaeEN+FukU5MilIC0bq5E+eu3LzqGG21iaroaBOeDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGcoRGI1r+zgV+e/iJEkokf+72z/BNKefFeIHholeSa0vKO3uBLYhxVeEb2xMYnKb/2QK34WHKgo9CuuU417C+pIC4HMtOajFhCob3r8K/12BMzP9AptwpSGyudw+qVySZvHcW913THP6ORALvJ/SHPv3sEgSGfyjkXE2TlHjNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilju8XC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilju8XC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D789C4CEE3;
	Tue, 15 Jul 2025 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587782;
	bh=IeaeEN+FukU5MilIC0bq5E+eu3LzqGG21iaroaBOeDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilju8XC4MPJTxKkltb9os4rC7N91jQxBXq1xEeAVi7CV0DLNsMZiKZO9yPn1PdE9Y
	 zPtfGUgG+gWmS7P6rUoJOmgcTLriOYsPx3rXdiD8eVbAhobREg+RT5S1ULFzrjmKj/
	 hcKxoi4bl7Gx3uo0wPlAGnnQltD27FVD308UZt+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andra Paraschiv <andraprs@amazon.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/208] af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
Date: Tue, 15 Jul 2025 15:14:11 +0200
Message-ID: <20250715130816.612738309@linuxfoundation.org>
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

[ Upstream commit 1b5f2ab98e7f99f1a83960b17c5596012a7c5e88 ]

The vsock flags can be set during the connect() setup logic, when
initializing the vsock address data structure variable. Then the vsock
transport is assigned, also considering this flags field.

The vsock transport is also assigned on the (listen) receive path. The
flags field needs to be set considering the use case.

Set the value of the vsock flags of the remote address to the one
targeted for packets forwarding to the host, if the following conditions
are met:

* The source CID of the packet is higher than VMADDR_CID_HOST.
* The destination CID of the packet is higher than VMADDR_CID_HOST.

Changelog

v3 -> v4

* No changes.

v2 -> v3

* No changes.

v1 -> v2

* Set the vsock flag on the receive path in the vsock transport
  assignment logic.
* Use bitwise operator for the vsock flag setup.
* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 687aa0c5581b ("vsock: Fix transport_* TOCTOU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5f82dfe50c123..8a6af90f2ff2c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -441,6 +441,18 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
 	int ret;
 
+	/* If the packet is coming with the source and destination CIDs higher
+	 * than VMADDR_CID_HOST, then a vsock channel where all the packets are
+	 * forwarded to the host should be established. Then the host will
+	 * need to forward the packets to the guest.
+	 *
+	 * The flag is set on the (listen) receive path (psk is not NULL). On
+	 * the connect path the flag can be set by the user space application.
+	 */
+	if (psk && vsk->local_addr.svm_cid > VMADDR_CID_HOST &&
+	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
+		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
+
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
 		new_transport = transport_dgram;
-- 
2.39.5



