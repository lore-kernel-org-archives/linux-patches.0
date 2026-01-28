Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56AA242D7F;
	Wed, 28 Jan 2026 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615888; cv=none; b=V3md2z+4XUPCRbFINTYtC/UGngF0lxLuTf2R41qTlgOtuM8zjmn7n9DDXlf4xzWvY8bDUcONaCQKrEKp26ReaSwZPDm3xs3gMaTBYNfbcqTN8ZtrCd+tUJMB9kLN1GvfUPXAuUkv/UHRRUQHtEnq6Dd4jL0mLk2Es+eXgnoyIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615888; c=relaxed/simple;
	bh=dCYTl6VA29VzxqEbW+8z+4jTN9noqZNIe8xXchhx6dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoFCi4hHAahzxHtM40sK+IRxnRAR4E/718DxNeu87G5KuUL65leXe9DE3Wz96C1uKdRRPY6JLijOKpyyWKHZo+H9Ckupf+3arkQRdAa9uiw0HAvo2qy02C1AC4CNIOvK2wtvs0IRRDRi91/LR/2doY2GQRKS9xLnSVord2UTxQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geEUi0Gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geEUi0Gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D083C4CEF1;
	Wed, 28 Jan 2026 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615888;
	bh=dCYTl6VA29VzxqEbW+8z+4jTN9noqZNIe8xXchhx6dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geEUi0GsLy3pnJQvzKxi6CsiVHh+weAyJDjXl3J2Yru4EOpBDL5Bba1vP89CIigH1
	 0pu2FEPhXI/u5CbCWMbkGA+YLo8L4/NBvozkkBEtwIAypi3Sh2WqKppyc+wAV9n2Jx
	 9+14Ri2XONVjRwkaqp1NRQY/vBulbiiYRk7GrbnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/227] vsock/test: fix seqpacket message bounds test
Date: Wed, 28 Jan 2026 16:23:09 +0100
Message-ID: <20260128145349.640412567@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 0a98de80136968bab7db37b16282b37f044694d3 ]

The test requires the sender (client) to send all messages before waking
up the receiver (server).
Since virtio-vsock had a bug and did not respect the size of the TX
buffer, this test worked, but now that we are going to fix the bug, the
test hangs because the sender would fill the TX buffer before waking up
the receiver.

Set the buffer size in the sender (client) as well, as we already do for
the receiver (server).

Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260121093628.9941-3-sgarzare@redhat.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/vsock_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index d4517386e551e..667f6f0ad6afa 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -351,6 +351,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 
 static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 {
+	unsigned long long sock_buf_size;
 	unsigned long curr_hash;
 	size_t max_msg_size;
 	int page_size;
@@ -363,6 +364,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
+	sock_buf_size = SOCK_BUF_SIZE;
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
 	/* Wait, until receiver sets buffer size. */
 	control_expectln("SRVREADY");
 
-- 
2.51.0



