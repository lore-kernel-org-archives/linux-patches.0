Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62612213ECB;
	Tue, 12 Nov 2024 10:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407181; cv=none; b=JuDBUv8lqxFgUILBkyWJQzji8D/LW6sVAI5zxU2TeW/cgD5QDFYlY4NVL8S9WYGCdPt5SVtZQHItQDtx+RXZW5avnwSXoxfjfHjwMBYe52yYHS6+mYxV/v7nDfp2TrxUXllxUKsFZVNeYqZGnUUFJ5PHq9rcUxYX5aZ4zkmaaqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407181; c=relaxed/simple;
	bh=NzefCdYsot4jGQ7rTrGopXrVpAx3Q14KqUXMS/ukUiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVSgBN0ffk21DtqtEYccWUpeO83LQ2yNs4aH2zYkrCdK8UJn6zDwh4BqNc6bNqH93Ff7hDanqMXwrruXUKvgkHU+9nmQcWQzwAi5UgaCQbmwmjGEiNjXElB+I36Sh8WLvizez9k+FT4A8lVspvn+dQfVM6XaFkI7Aqi4KjJZAkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES/yooSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES/yooSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF14C4CED7;
	Tue, 12 Nov 2024 10:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407181;
	bh=NzefCdYsot4jGQ7rTrGopXrVpAx3Q14KqUXMS/ukUiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES/yooSfC65aZFgNv+gk3NmOg/2AJV2f1kjmzoICJ37G+vu+fwKP65afDpLbFQG7L
	 BKOmnmtSaAiBVUWc2EQ/lINR2BHazOaaZNZBuE7Z7pBCWgHSyN/clrh25ePs0y1Kq2
	 CrKHwz30I/W2OLEgPEAxBo+/j9AGLQ6Mt/ssIC10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 75/76] vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans
Date: Tue, 12 Nov 2024 11:21:40 +0100
Message-ID: <20241112101842.632449651@linuxfoundation.org>
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
@@ -812,6 +812,7 @@ void virtio_transport_destruct(struct vs
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
 	kfree(vvs);
+	vsk->trans = NULL;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 


