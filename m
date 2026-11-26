Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704685;
	b=1M2vuvCTSGJnI7UW4+GOpxiGHvnwj9gJFc0PCnQ5Qrc/2NbEeLr/1i4NIo3PDzQdEJas
	 QX2x8BzpGBjNCOta/tcvfHqx3qkEOWvVORmU9yL0+Dc8Bh0v6TMEX3Dm9DUclxKNAqbuF
	 8audXDyNLbcZMs4VJxU13mPknxSGhXw1T7Qx4oqKIB/GUBYxkY/HUiGTTak6D6D2rILRE
	 4vqeD2ZdU+SzXrqKBoYrL3fD2FIqclAP7vEAzAnFJTKl+eqbeREdZYGxUX3SD0ZJMTOWV
	 t4l0W4EgQPF+9dT3P7yZ9SQ0D8LLdRYqCwHNaJXNE/jfzvVQ/1LVW1HzKS0li2z7QqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V44Sb8gaBYdmVfcj2eC0Qt9B0Dy+RYXp1IvLcG6eBNw=;
	b=Rwje1jOzY3gEzoRtKi4tsBt1HU6eg9ddAUO/rBq8/lKYOsFtwqseZgkdmDt2kntxDdle
	 yB29Xhc2CmD8gDppxLj2WrecU6WOOq2O6fFTwIUK6D8GxbaUeJ315iDbKZyqPW2vcTGRW
	 1KSAlPvkvlqleiL2KVguFAAj+jrQPh9wHLvQ6TLxgFq/EgmantRP/Fa/PGIDUPJTlJfB7
	 kj9iLw2nk7ibE9ImMdxhg+yMjLjXpjKf4ypA5sk3jGjMmgur7t1ziPgbwvluLH637i6+z
	 9We37ZpRn5v380aTtKdETtlWA8b64WaKHaiLArD/0M4wcu/cXpaScJ73lqwcH+M8mqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lqtcpccU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA276606A321;
	Thu, 26 Nov 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lqtcpccU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3B81F000C4;
	Thu, 26 Nov 2026 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704685;
	bh=V44Sb8gaBYdmVfcj2eC0Qt9B0Dy+RYXp1IvLcG6eBNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqtcpccUeojFc+o5x3W9+3SIgC16wIsWFFopooK/XMo2YT/FzLnNTvQK8dB3RCRHX
	 mCy3u8I+UGQeDlBeBzwejvzBjns/Ceft+th7Zt/nL9ObGwqwXd0af8w82ngVLqRgxU
	 ScU9OeNSlShHg0A3ayyKOzyiy7KfHXerd4tiGlIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 209/265] dm-cache: fix NULL pointer dereference on open failure
Date: Thu, 26 Nov 2026 15:38:59 +0100
Message-ID: <20261126143619.836379437@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit d12afc2f9ed6e14019fed9c02a74ad699915dc85 upstream.

When __begin_transaction_flags in metadata_open fails,
dm_cache_metadata_close is called. dm_cache_metadata_close attempts to
execute list_del(&cmd->list);, but the "cmd" object is not on any list
yet, thus it crashes with NULL pointer dereference.

Fix this by initializing cmd->list after cmd is allocated.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 9b1cc9f251af ("dm cache: share cache-metadata object across inactive and active DM tables")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-metadata.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -760,6 +760,7 @@ static struct dm_cache_metadata *metadat
 		return ERR_PTR(-ENOMEM);
 	}
 
+	INIT_LIST_HEAD(&cmd->list);
 	cmd->version = metadata_version;
 	refcount_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);


