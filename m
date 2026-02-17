Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1670286D4D;
	Tue, 17 Feb 2026 20:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360926; cv=none; b=hAdfWwjH42IARw5ZFtkBGOv4fLuF2O9lY/3rPWpCPLhOwC5dyCe8XI1oboJmEkYAO7WxCYsKWUL3MKe8RfGr9qLvfoLE5j2KosRgnTC/MsovjOZLBYHhej1qHOs22mXbCXMymrP3tNyyxFX7+stkUlOrrc8JH6T6NVSlVjwqCtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360926; c=relaxed/simple;
	bh=A1OF/gL6g4zI5dO5z+XwzfSXkcCSf0BtFczexBJ0gGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9v7R/nklpnBWWjyFCQSBLj1evggZwFflIpW02xpHYqNDxh2kF2scyJnjE0GTQUdL5jTmacI1BHO2Jp/GWdlM9ZnxTT5+R54rJzey+XIp4hePZpGSfxc8PK6hudRtSidXVbTE6RmRtcGrWeuHe13dc5AGEI8TCGpFgou1WqqOE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCyeCkWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCyeCkWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657D7C4CEF7;
	Tue, 17 Feb 2026 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360925;
	bh=A1OF/gL6g4zI5dO5z+XwzfSXkcCSf0BtFczexBJ0gGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCyeCkWGvKNWgVO+xYdpbLWNJnXohNiD0ptp2Yhsx4pz8wdDepn8gY2dJ34xLlGm0
	 xJWAcayXsOPjqSY3TTgsyhrAWtVQ5orWGxD84QjHh//gTnZudDmK4+5k/gVVdvQvJc
	 Mgr2d0JJFKtcN+MqmzQlgdkwN3tX2r1YRCqRpsaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/24] crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
Date: Tue, 17 Feb 2026 21:31:29 +0100
Message-ID: <20260217200001.337492475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 14f86a1155cca1176abf55987b2fce7f7fcb2455 ]

With function virtio_crypto_skcipher_crypt_req(), there is already
virtqueue_kick() call with spinlock held in function
__virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
function call here.

Fixes: d79b5d0bbf2e ("crypto: virtio - support crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -556,8 +556,6 @@ int virtio_crypto_skcipher_crypt_req(
 	if (ret < 0)
 		return ret;
 
-	virtqueue_kick(data_vq->vq);
-
 	return 0;
 }
 


