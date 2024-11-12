Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556752144B9;
	Tue, 12 Nov 2024 10:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408510; cv=none; b=lS+TndnyWmn2icgZ2W2a0/u/GRqdn4NZfr6ayfSVj5jGHeFT9AOG6oaSQ3SlFTRrFB6iJff1WEs/E7Q1wPu2zyXAnHYBhgR/HTlUP+x84svjgzYR4EwAWiQ8jNw986uIsL+i+mV1/H03TEKkOCgq91QvNkPVyHvd3noeeYk2pwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408510; c=relaxed/simple;
	bh=FjxCBJtEIa79hY58QxTOb/KsRvikVJyBGKrQubY5uLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7vpCqtZDBtf5cGWT2MWlD0W7Ar0fUJzL2f8QHhBGkqYF86SuGFAK9jJRH18p/TTppIH85MGJYuD3qo1RCV4w0UXEEopw4DMyS2R6+Qss3Ebu6mqYga0hPYdpH5ZPONGiVbkt6sBBDq6ZvaB2/nEjUFEvIbc6e0kBU+98hP0oOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGSvzb4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGSvzb4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB813C4CECD;
	Tue, 12 Nov 2024 10:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408510;
	bh=FjxCBJtEIa79hY58QxTOb/KsRvikVJyBGKrQubY5uLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGSvzb4L/TzOJ9rZyQAoCUD/0StIscHxJztkfymLoHHwB4KhHC8OysA3VNCVFAA7F
	 gLRRN34HJW54/mShqOg5jokgTXNODkeR6NMZzbvumWCljKFjLTf67q9QfafQjTSjGT
	 +Qf7OS1ne+uz368WPkLi6EWBYedkDU7+ix2/V6cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.11 184/184] vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans
Date: Tue, 12 Nov 2024 11:22:22 +0100
Message-ID: <20241112101907.928330294@linuxfoundation.org>
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
@@ -1087,6 +1087,7 @@ void virtio_transport_destruct(struct vs
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
 	kfree(vvs);
+	vsk->trans = NULL;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 


