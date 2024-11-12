Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6420B20B;
	Tue, 12 Nov 2024 10:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407177; cv=none; b=Awp9uYiAn3LjQpWNV86emELiysDuk2Q59wKGl+NZApPsgHUqa3//zV2u8ID+aJQrIDTz/ar6K7yKzHsa7WMBIxnYNvhPXUhjK/dY8t9Nuba07kHtBzHRtgdpBJFtBh4RZyVSbelpE2ErB5hb45hj73K1QcZXUVzRTWOgW7yJEUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407177; c=relaxed/simple;
	bh=6UqWFONK4uy0VcZgPm7DGbC481S8qdspyYE06nCl5nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkQczTi3QEovXhstmRQW44iGv+q3lFSuDU61jP3oJk0YROS25Xa+BUmWiHPZhsc4xhNcWE0G7Q4FrkMKTrcHUwZuq0tyqlws2py7IvVUI0AdxK7aS88hmoQq4g23b8bD9qrgvLrkqy4XiykIbXSxEvqhqgbSFxL7ROBsocBpNZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLG0O5UG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLG0O5UG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B545C4CED4;
	Tue, 12 Nov 2024 10:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407177;
	bh=6UqWFONK4uy0VcZgPm7DGbC481S8qdspyYE06nCl5nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLG0O5UGwDxHFZ4WD1sjf+wJvctOWSiWu2Nd2PiKjZ/uAIVmusP3NSyFYxR4hX8pa
	 7BJ3n2TU0Ujc5QFDvQLfGtM+BITHtRa2Nb5LlM8zxxnhqA5tGriOXPkVMWtKEGdRq6
	 LcNapjd3/i9f3viUzBSqd41+/qt7D0E9N5DFjKkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 74/76] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Tue, 12 Nov 2024 11:21:39 +0100
Message-ID: <20241112101842.595464461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

commit e629295bd60abf4da1db85b82819ca6a4f6c1e79 upstream.

When hvs is released, there is a possibility that vsk->trans may not
be initialized to NULL, which could lead to a dangling pointer.
This issue is resolved by initializing vsk->trans to NULL.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/Zys4hCj61V+mQfX2@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/hyperv_transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -538,6 +538,7 @@ static void hvs_destruct(struct vsock_so
 		vmbus_hvsock_device_unregister(chan);
 
 	kfree(hvs);
+	vsk->trans = NULL;
 }
 
 static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)


