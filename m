Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D4A18B482;
	Fri, 15 Nov 2024 06:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652882; cv=none; b=LdexjCHUOkca+8C1I8KzpCboETM5ZymtMUZyjULXQsXwBXMO6CF0RguU6dFfSiO0py2buH6dbMtORYFX+JiOhro05luZEUyRBw8zZPP/QlQx4S0sMeH94Wl6D7CC6zKKOe1i6d8w0Va25okCpRRmFKQFyZ2oyIe26rhNeLezBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652882; c=relaxed/simple;
	bh=J3qFZLXAxD1eqZ1YmAE8fBLrucs8M4cQBFNwnFZpsyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaqhAf3V2yusVTCLTDRl23VjMK4UQXj1XKe0o3MBvDkb87AyalzMN3nG6MtowjCsQREar3LlPfPO73RuxEr6W+DuFNPYXEc021QtI2F2MKgUNtkId+1lWppqzuloEWf2AdXO8bwdhXUN5fNVEj1BLiUQB6lm4AWfMYpNzgJVOO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKUCN0/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKUCN0/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD877C4CECF;
	Fri, 15 Nov 2024 06:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652882;
	bh=J3qFZLXAxD1eqZ1YmAE8fBLrucs8M4cQBFNwnFZpsyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKUCN0/xQHSIhFgL+I9PcnDcLUosxrxiIRI0cgJy5C/d8hX5atNmjx3BN2HBS7Z5Y
	 IuwTKNZHQZRxPUnV8DbwwebujY11RqUXbhPjDmeZrmNL3hovU22KjNBzC2RJkw/U6w
	 ELNrZ30fx2zUcmS/2RM6HEu6AA2/zCz2X6LMdobU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 4.19 43/52] vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans
Date: Fri, 15 Nov 2024 07:37:56 +0100
Message-ID: <20241115063724.409396378@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -646,6 +646,7 @@ void virtio_transport_destruct(struct vs
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
 	kfree(vvs);
+	vsk->trans = NULL;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 


