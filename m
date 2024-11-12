Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FE819E992;
	Tue, 12 Nov 2024 10:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408507; cv=none; b=XohOeDB6MyULg0rVJskTd2Vfk3MgA0+sf0tNrfeb6+GjkQNbEXs0pFRn7MHK2MbXBBbm5q3nQjPmvb8eiMeVeVPiAi9qGlKDIWqDuNnD4XSLez+ru0Tm9aIWFjKlrojmapQzbcgpjolbz+2PnQsmLeCdAYAxwFd1xtMUeMyhlts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408507; c=relaxed/simple;
	bh=Eu4u+XjRhHRBcsdPX2n38zDPOuVHUJ9FIimTmlAgrEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs2dfFkCdJsTH+XpFpCcMJ4eZv88ExrRnmrXqLzdgGmxBWSvHk+3uvXNCvbon1XvDRWCxgdWEVRMXFksAFcFGRBaSk6mDlPpXmFWa6CNfVtlp0xbVZXCkD7GCrar2mw5616jBiZ/GxCNV+BE0ent2YlV4mYsKC1spglQy/ZS1O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjo+t3t3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjo+t3t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CD5C4CECD;
	Tue, 12 Nov 2024 10:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408506;
	bh=Eu4u+XjRhHRBcsdPX2n38zDPOuVHUJ9FIimTmlAgrEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjo+t3t3cEOtum0j3mNrkewM6v7mLLgW1mtPvUP+DeFwgC73Hu8lJ2Gz6KPol4ZGv
	 xKPHo1BEBKmAbcvPt05eeqQUbyuNWlESkaHcmPaY/dw0Lo4OTQUnG1sGTb5XOOxXS8
	 s2LFBDRRh8iN0HfbsoJ3YWhohQbkd//f1MQlen80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 183/184] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Tue, 12 Nov 2024 11:22:21 +0100
Message-ID: <20241112101907.889791794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -549,6 +549,7 @@ static void hvs_destruct(struct vsock_so
 		vmbus_hvsock_device_unregister(chan);
 
 	kfree(hvs);
+	vsk->trans = NULL;
 }
 
 static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)


