Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ECF220C7A;
	Tue, 12 Nov 2024 10:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407905; cv=none; b=FWw9Jih56i04IS41SrEuRQzFyrsm0gAGUiyfABUfGuG6nPYe71WosVjmip6SpXVUXYZGDSyx52Vh2oGYofGpwNseDzCRM5VgYlnqnZ1OeMXZwjw3U907/TduG9HPDSpwKoYUjyQ9M9Z6rC365FA8cCmN6EgU/sunymJ6QAEKEVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407905; c=relaxed/simple;
	bh=UR3avfWpimfOyZFikjU49jsCW4CLC/PmBfg6V4uonT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km7Hp3LT+DFZ3aBkh9A2l92xGVNbKkQ4kDRHF2G69cxTKxgeHOCkTkEiE9DBZ2LBettjbshegyASTRAfgY74xPUhISih4ANArOqNrv2Hms5c0NW2nCo5vNETXJ9DU5ftg87YTDSLb7IGzSOwLTUTvqnRxwqIuGdniYQ+eo8Uj/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZwARkRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZwARkRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7484C4CECD;
	Tue, 12 Nov 2024 10:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407905;
	bh=UR3avfWpimfOyZFikjU49jsCW4CLC/PmBfg6V4uonT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZwARkRlIMI6tOagJEfGDkrhgGBykaMVePJC3B02+dxiXBcGwQty/wmoeZG7vwwdE
	 aimJYNcuQhhA3wgzYE01W1s5dkNu6pGCf4hdpk2MkpBD1CJjcSFN/Muv0LacGkf1kY
	 SVF3whMUM7mqdcMviF8jrbgZOUsHyU+9UT/uMfP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.6 119/119] vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans
Date: Tue, 12 Nov 2024 11:22:07 +0100
Message-ID: <20241112101853.263007567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

commit 6ca575374dd9a507cdd16dfa0e78c2e9e20bd05f upstream.

During loopback communication, a dangling pointer can be created in
vsk->trans, potentially leading to a Use-After-Free condition.  This
issue is resolved by initializing vsk->trans to NULL.

Cc: stable <stable@kernel.org>
Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Wongi Lee <qwerty@theori.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <2024102245-strive-crib-c8d3@gregkh>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -923,6 +923,7 @@ void virtio_transport_destruct(struct vs
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
 	kfree(vvs);
+	vsk->trans = NULL;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 


