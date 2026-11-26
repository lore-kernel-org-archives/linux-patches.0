Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705614;
	b=4S8hGaY2vktZbwFSW7Gjt/S6kzIMecukv96tRmpsPcY3fwqQhiqYWz+J7Lb46Wi5qMuU
	 Y/PBeB3CBFq7U1gCQf55iuX38u2/GAyKkTmD9qTJMv6gO8tyJ5uaLxgnnU5nC32Zxwiky
	 xu9myRAFGxmCypjcEgt419fgneTSan8wO8ORBdDu+24aCvVpdqQOYHC5t+tFJT1lv60G1
	 2LWnb1SG0fhHhuI4vY1tAsbQDBQVOyg77yCjzolQAB1lUmgQgOINeLvvtfTvbzwKYeuCK
	 9IZ3Q0rEdU6wPQsJ+7PWpnY3IAKn+GjDCDjovPMuJNvIzpmgzgQ4h5DcqbFj5qdYjpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7d5fvDqXgvE0gfRthNCgKEKwpISd3rb1aWcffc7p6PI=;
	b=NCZnA+ScrURWRR99vEw7B2GwSYPgsxoTHVdc6YVo4i9EBVLRtpTF6vtzXPTmYhbVhV8F
	 RVcdocLn0xNEhW4EBNjE4gkTYsqILZWeqcIeASYGYOYLmv/SqdLXi+EuQofS7D+wwyWFD
	 ogUqpz3eovFVS7GobRiXpz8+HV5APCBmixg7MvddH0yPzVifV6LZhUD1AgaRfgQJfON+B
	 FtmS5xH71gUaEfwOZENguvXKxRnTps/Js9Foc7GnEeNGr45QvvAM1VAAjI3QDBqkcIStM
	 pVBc9RkrB/8oFX+bxe04WauUVBQa6fv48syuuVMhwEb/ZCpjOvUoMGUhW7hSKSJqOHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnYzrGFp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA66606A31E;
	Thu, 26 Nov 2026 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnYzrGFp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A551F000C4;
	Thu, 26 Nov 2026 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705614;
	bh=7d5fvDqXgvE0gfRthNCgKEKwpISd3rb1aWcffc7p6PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnYzrGFpLX2rnygoSRhqPFin7oEBn9+8jr5Wf4cSFapEusy0WDSFXlttZfTZ1/Xa6
	 /TRRWcQDkpsVUAaDn7/bPlRboHashZx5bxq+JECAmyMFRTyilf7LVSaA3BWz+d0sJW
	 mPyXNtBxNh97e/xz10wq+kyWem0/xAtMnpCRktC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 256/319] dm-thin: fix leak if __set_snapshot_details fails
Date: Thu, 26 Nov 2026 15:40:24 +0100
Message-ID: <20261126144012.522426740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit dfb95816cf6f2f2660af2ec64c65dc204c60b5e7 upstream.

If __set_snapshot_details fails, the variable td is leaked - this
prevents any other snapshot with the same id from being created.

Fix this by removing it from the list and freeing it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1203,10 +1203,13 @@ static int __create_snap(struct dm_pool_
 	__close_device(td);
 
 	if (r)
-		goto bad;
+		goto bad2;
 
 	return 0;
 
+bad2:
+	list_del(&td->list);
+	kfree(td);
 bad:
 	dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 	dm_btree_remove(&pmd->details_info, pmd->details_root,


