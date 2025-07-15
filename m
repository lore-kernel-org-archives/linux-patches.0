Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE01E26D4F2;
	Tue, 15 Jul 2025 13:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587785; cv=none; b=gZVlhU+5bGCwVdINu77r9FOY6ggO6OsZATZrMFowSaYrMcyyfdx2UFtKrsigJUC7/YZih6rBIvlzvTGMq6teokDxHbn49bK81EozQiCzYAWCw5w5dnTK6JfHRGzVJZoejeBtlI2zivKlUt+QGnVdoFotOOW/62pde0nSaHpdUog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587785; c=relaxed/simple;
	bh=4kU4A5eLL0AshR9tHKIsFn7QSt3ZBuh8jpDWCX+YeTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUs6Qw/+tvbp4/MooI4aBatKrILT8c9RXgsp80cWGJX79aQ4CBDE1NFEeK5UUidOZMZx1qnRc9DaecWYgM1KNuBXtFX74spD4baD2efGmrDNtYK9KKoWXNCMRdPVaXucuiYB/ayJL0T6195cmtHBZoi7D3rgNlqHBu4jZ37v88Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTeMi0jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTeMi0jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD2CC4CEE3;
	Tue, 15 Jul 2025 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587785;
	bh=4kU4A5eLL0AshR9tHKIsFn7QSt3ZBuh8jpDWCX+YeTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTeMi0joKSajcr2q8r4yy8WwqzSAz++vHOvhW2/1WLac4i4QDmVIKFTP82j9/qOCf
	 dN3juWPu/EPR/ScFrLb0dxvus5cO9mTsJnm6Y5eVQkLgC0W1KdiocrlPWNFkttIoXg
	 IwsqaUmZ8XnVDkxMZBD6sT5HQexWhRQd36HJnbig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andra Paraschiv <andraprs@amazon.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/208] af_vsock: Assign the vsock transport considering the vsock address flags
Date: Tue, 15 Jul 2025 15:14:12 +0200
Message-ID: <20250715130816.652204599@linuxfoundation.org>
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

[ Upstream commit 7f816984f439dfe24da25032254cb10512900346 ]

The vsock flags field can be set in the connect path (user space app)
and the (listen) receive path (kernel space logic).

When the vsock transport is assigned, the remote CID is used to
distinguish between types of connection.

Use the vsock flags value (in addition to the CID) from the remote
address to decide which vsock transport to assign. For the sibling VMs
use case, all the vsock packets need to be forwarded to the host, so
always assign the guest->host transport if the VMADDR_FLAG_TO_HOST flag
is set. For the other use cases, the vsock transport assignment logic is
not changed.

Changelog

v3 -> v4

* Update the "remote_flags" local variable type to reflect the change of
  the "svm_flags" field to be 1 byte in size.

v2 -> v3

* Update bitwise check logic to not compare result to the flag value.

v1 -> v2

* Use bitwise operator to check the vsock flag.
* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.
* Merge the checks for the g2h transport assignment in one "if" block.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 687aa0c5581b ("vsock: Fix transport_* TOCTOU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 8a6af90f2ff2c..beacbe957594a 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -431,7 +431,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
  * The vsk->remote_addr is used to decide which transport to use:
  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
  *    g2h is not loaded, will use local transport;
- *  - remote CID <= VMADDR_CID_HOST will use guest->host transport;
+ *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
+ *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
  *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
@@ -439,6 +440,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	const struct vsock_transport *new_transport;
 	struct sock *sk = sk_vsock(vsk);
 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
+	__u8 remote_flags;
 	int ret;
 
 	/* If the packet is coming with the source and destination CIDs higher
@@ -453,6 +455,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
 		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
 
+	remote_flags = vsk->remote_addr.svm_flags;
+
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
 		new_transport = transport_dgram;
@@ -460,7 +464,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	case SOCK_STREAM:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
-		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g)
+		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
+			 (remote_flags & VMADDR_FLAG_TO_HOST))
 			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
-- 
2.39.5



