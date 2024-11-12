Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD6A1F26E3;
	Tue, 12 Nov 2024 10:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407512; cv=none; b=mxh2eVIYceTXil38MZTiGDFMHXK0UZkvm6s7Y5z0wgQwUBr7wSCPhsTdhz5uHTe9CcEKPfAZLTUr/Qr7NH2AIj5rh5YV7NRwT6iFsAtaQC0R2uSPJn6rYd9JpSW/MiUu8SRLwAoG1cFRFHgHBahcIqp4497zLJthjJhITJp+MZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407512; c=relaxed/simple;
	bh=wQOLJJkgbvMW3pBMhELGGsbMdfY0dUqRhmb1BEEpv3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kws6VsgMea2Nh0nXTj4UDN/g4WLWgHEl+bGxdUtLBQ6QrnBtfve0jfaep1NqIECPEOu8SV96y+EJDfBELs3XuCXtCcehsYY7fBM2Crqo6+25MYsBBFPYumuHZOrq6jBUivsHtp4C9Xzi8yRmbBEldr5xPcP9BvhfJIQECJtDZ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNJm6YZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNJm6YZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00DEC4CED7;
	Tue, 12 Nov 2024 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407512;
	bh=wQOLJJkgbvMW3pBMhELGGsbMdfY0dUqRhmb1BEEpv3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNJm6YZwV3rAV7XyKmKNorfQgmcqjcKf99iC9+ma9QjVMO+5lKGwvClR0gNCev/Vj
	 z10S41jB18kJI4hwtGGTqQaH1+In3m7BlwkMzyq55FAZK2YEQxVudaL7BgDoYApvgR
	 8+AfFET8lWpNOcVWC8+Kgjp54lKwuWs7vp7PpySA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 97/98] vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans
Date: Tue, 12 Nov 2024 11:21:52 +0100
Message-ID: <20241112101847.937261002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -827,6 +827,7 @@ void virtio_transport_destruct(struct vs
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
 	kfree(vvs);
+	vsk->trans = NULL;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 


