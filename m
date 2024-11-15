Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AE9185924;
	Fri, 15 Nov 2024 06:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653963; cv=none; b=tgVzgIn7Zk2fZn2Q+rxiTi6T0jbchDOjThFLvv/BtO8W0dr1OuCeZXu9GY+pAMUdUJXsoNCsxY8mlWN7PQTZvcyfKTG8e/BY4qGLikOwdE4Z2forS7c7vhdvrUSstD6cFY56pU0ROCtUdR5AsCnYTIivfJCcGkVZq6GN2CmmPgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653963; c=relaxed/simple;
	bh=AGsepUgWyWwc07lfhjJEx0beKwbM53BfQaL+Aa2gzjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUxaqMXrafSwso97Wa8hJLWniMgpL8J5v9FcxmdHcLYJ1STduKjQXxnPS/zsxshNiWfXpk/zo/deQ7H3K0dF/ZldJKi9OG+caTh0JTPd64EmCNPy3ZoaHYLWf6QQBum5mlOoAi2E7xtCyRqsdiHmAYc2XTiF6XlnO/s5IYDE71c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRjSsltV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRjSsltV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B897AC4CECF;
	Fri, 15 Nov 2024 06:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653963;
	bh=AGsepUgWyWwc07lfhjJEx0beKwbM53BfQaL+Aa2gzjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRjSsltVrWkDWsPJ7EUiUELWDjETmdHbMgg86i0FxuS/TjBYGdcWE63C6ehWw0OIk
	 rAFXagb/5AVnzarKG75GN/Z0CqxVJZuPZ2Lm/LJruKwdAsYCg8bjAuXpltv6aI34ac
	 AzRZts++ULZr6jLauUYzY+Riqs5UiNQFSRrn9lHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 67/82] vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans
Date: Fri, 15 Nov 2024 07:38:44 +0100
Message-ID: <20241115063727.966139356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -687,6 +687,7 @@ void virtio_transport_destruct(struct vs
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
 	kfree(vvs);
+	vsk->trans = NULL;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 


