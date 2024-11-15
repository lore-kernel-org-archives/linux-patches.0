Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF329A9;
	Fri, 15 Nov 2024 06:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653158; cv=none; b=ibCyvSeXK98H1zI+vxvCjGs8bPfLfSBHzHQj2P2Rz4iY8ti9rPfPR2iPXeRRyY1KrGH+Puz4/YYcHlXOV8i2h8mm1GxlRLMk4hDtUUq9dBcmChMVZEU8GY5GJC01GtL2921D3jkOYB0+2PU4vahu1IJtuIOgw5mMz25MqIybHBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653158; c=relaxed/simple;
	bh=4W+OLwYHSkVwABBpIK7LTEBhpKl0waVeqwVfUINpMBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGb0nyf6Q7v9LdYNsXi1IijRp/ffIsfNp37fXkVEYYQ686zz2F5nXlYuqq635GJTaiflFvSenQQ1kiDD8VbFhYASzFXX+bRNPbehonKM/os+Au59uCjwVfybBZHpbDtI7kpEunjOEYBQOl1rDGS9bKfZeU2EP2VzVpipZ7XcL+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCeCPuJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCeCPuJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6337C4CECF;
	Fri, 15 Nov 2024 06:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653158;
	bh=4W+OLwYHSkVwABBpIK7LTEBhpKl0waVeqwVfUINpMBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCeCPuJuCNFfvgAYEWtJaHfnkhN+D8RQy0MXeACw3WqQlXDRtE5b9rBwoGXG3UZGe
	 Cz5xxJTvn/2x+w+JjkOjgzgkfKRikeZiPJ5qiyiBnswJPb5fnFCFUVKO2iR/7AHocS
	 qGwxgFE3TgJ2m/0lXyYEF0xbRWW3IjWGUIwj+5zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.4 52/66] vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans
Date: Fri, 15 Nov 2024 07:38:01 +0100
Message-ID: <20241115063724.719504232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -680,6 +680,7 @@ void virtio_transport_destruct(struct vs
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
 	kfree(vvs);
+	vsk->trans = NULL;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 


