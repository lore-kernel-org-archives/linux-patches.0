Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704839;
	b=IcGgctOk2QelnpZpvtRMxREwuGSw8sTyXjqeziFrv18tP9hApUM9EpYZXJsskgbdhiav
	 7H5P6fm9+ezytppvos75H1u3htY2Vo8CUBqK8kBjkNBgLoYBL+OauJayUCH9ZFLMb+kqq
	 1UQiVzyvPVtbtSbRyecz3eiIEUn+gj29URDB8m0y6uLg3VyAlj0DaRKP0RgZ4ISbQtaMf
	 JZOpyQqVxD+wWfm3XXYHcOS7ekqE0RUDE8CmzEXEsl8T8+gCfBDErOMV8sr7SgRXl7GIS
	 M+k16/3b3ED3vVqarCp2fxvIsXsRZcDSnY52fxAiuNV10TunpaAiPWxuZi9hr0T14cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j1JP0MCfr9hC7aGOZ2QtK/PD2PGjSXgOrFtwoojD9+M=;
	b=dGvrAOESL0vKtpxMk6Eg/eJTc0vMuoM+MVFdYvO1zCF0gWhCelMdnJcrMEdJGVOwSvn1
	 9MWbBj/SXH+4vYhFUxq0aOlrzlCdHLZxkc/WmMgp86Rj8Ku9RBiDxbFsyK6OeNrP0VNPZ
	 XUkV5rhqu30ee7Xi85sPYHdXqoRoMmrEGvR/6YXao2gsd+KXqROKfw3rUXnmE+3P0VipE
	 iaP2mF+ZDN5aa7CpG2KI/2pVdEJVCZCxuA44UdAgBucpi43nn350f2d1j6jc3wmdkgE7C
	 KcVbAZWW5w0RMWUehsy+Ws9mjyYCiTWts2m6qhG3kwUEDYuOwtT5tPDhM05ZpWOhFTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsIlPkvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D5A606A31C;
	Thu, 26 Nov 2026 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsIlPkvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17331F000C4;
	Thu, 26 Nov 2026 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704838;
	bh=j1JP0MCfr9hC7aGOZ2QtK/PD2PGjSXgOrFtwoojD9+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsIlPkvgduBq8MlZNuvinma2Sx8N/uW5zghD1anNm87mFD9q1Q+gBYRWZJk0S0AUb
	 IIZ4YeqaTUSB3deAfTtuAqOQmLt3xlENHx5u3udf3hZswr12yAo42kFDJPRPS5yawD
	 RVKeHVBnYbZi7RZe/jMp9aP91zY5CaHy4uFjq6c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Rayabharam <mail@anirudhrb.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 5.10 259/265] vhost: handle error while adding split ranges to iotlb
Date: Thu, 26 Nov 2026 15:39:49 +0100
Message-ID: <20261126143623.364296052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit 03a91c9af2c42ae14afafb829a4b7e6589ab5892 upstream.

vhost_iotlb_add_range_ctx() handles the range [0, ULONG_MAX] by
splitting it into two ranges and adding them separately. The return
value of adding the first range to the iotlb is currently ignored.
Check the return value and bail out in case of an error.

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20220312141121.4981-1-mail@anirudhrb.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/iotlb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -62,8 +62,12 @@ int vhost_iotlb_add_range_ctx(struct vho
 	 */
 	if (start == 0 && last == ULONG_MAX) {
 		u64 mid = last / 2;
+		int err = vhost_iotlb_add_range_ctx(iotlb, start, mid, addr,
+				perm, opaque);
+
+		if (err)
+			return err;
 
-		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
 		addr += mid + 1;
 		start = mid + 1;
 	}


