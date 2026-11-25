Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626056;
	b=bR9LcUUyiYl200TkGOhcELUWFIOfNxCCwA1hoqIKTXK81jnja/6xLJ63vOq0/QHCQekC
	 JLTCNcERnWzHz+0cAOTkHTvseUooJM4fNH2roe8u7WgeDhzayG9Y+EuVo88QEf7GcRCFF
	 opl7Yum8pCNgmdUMn7rN/4hxM3NqLvfXeocO3SLKyS94Ch4ENhEU0Koj9Pbat/kPYOuvE
	 JUvvgcb9Vwml6VdI4Fm1VjY6vhpH0PoWhoM85g9ld/pj6K26CtiJGe9tH62G9beeMLdA9
	 Gdwtlyo8uJR313HXCYaikHpoCm/8uBgoVM3HZeEbiWan3620BXbjiPHUrIfXzSDiTdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5fumzzSP+5nKa1LrSzRxWk+zb39+3EoyhNaiE09kfjE=;
	b=Vtc4nx0u2/ihM30i8tobAgAsbevnwmiCbXBE7ferMU5C7G19QH/baZ/lgH1OoQ74fW79
	 x0b+kj3yYYKHK7cHItGdGnqFlYHwjIZZewa+XwdxZUe4wKXxlIhnCK2MaUAAULrYs/RFu
	 46m3yAIfPKkTZPPiZhZbzSeqHk1LaKzuuwc9PevFe7gZYfAI0M8HOFh9dWdBHb83cnZev
	 aFk63umyHIaAnyOQjHN/1lNUj8WjUIYLi4y4QXpIBy1MU0s7Bc+U6f/mtqZhAsfqDqZ0j
	 7aKcHh0FOomQ4ioCWPCi/5zZftEasG4nUa2/BZQQb8Qni3cLgXwY3uim/jLFobWYpOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSCLVjNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00405606A31E;
	Wed, 25 Nov 2026 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSCLVjNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F681F000C0;
	Wed, 25 Nov 2026 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626055;
	bh=5fumzzSP+5nKa1LrSzRxWk+zb39+3EoyhNaiE09kfjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSCLVjNhDz2QqAIdmuINF0d2mn20Sv6RP4jJvJN+Dl/GhYqXynPTajdR3VdAOW8rQ
	 BNQqgeS/mV7RcJry0CqtkDiGgch7AHHGAR4TIkUTBvrQujIZT/fYX8z/HYS19im9iK
	 YNyilTKATp9Wz6VsbTQ1omXyV2iYuOth/JEqtUjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 718/816] dm-thin: fix leak if __set_snapshot_details fails
Date: Wed, 25 Nov 2026 15:37:46 +0100
Message-ID: <20261125143905.797111950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1225,10 +1225,13 @@ static int __create_snap(struct dm_pool_
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


