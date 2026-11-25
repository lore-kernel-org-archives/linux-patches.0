Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620503;
	b=ii2Y4nPjafWQqlwYJkoJ9tLwR1KMvyg/46suz0LsimOhfvlZVQtOcAUzgiNKWlwFVoVa
	 o523wswBicXDA255A2BPSORUfToBZJqCH3ci4avnwCQptrC4RU5IeRYgd9CHW/4ifTPhF
	 roA9bYYNQwb/j3TlUdJPSa5C29M+orgni7CNzpz0xl53fnS4swwyK3KuxshFGjLzQNeLK
	 SqR1UCBx5gPDLvSEPMmuY+DS/LEosxNxkoXf2bP37W7Y7gUgH/A8zd5WFose1Lq8f9lMZ
	 3wtgsRhndTyLMvNIPQhRLrYzRRAGMx1FExE3O2RJjLQ7k26CzwOtJMik6+v1SPO5d6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3BcL03qAix6x4ZUlsS7vc5y3v37Mt1KQJ3P5VGOC6A=;
	b=zuWWdTyc108rMYj1wIGyFma1SE3Io4B9FMHpJIxKIfZYZCWoO/ajKsbWgLylMQxYB+gv
	 c98f/UhSTPvIWkxm20NvlEerqirCk1mHCISDDXZ7J9foeoLa2X6IK4bGcYKut7yc8XtC9
	 R8gRYAbm3KLffi96hAWy+eeh7lTKj6Ufk+CvwPHOF4Y5Q+WKHxMQRQ7e04DvRkjUoIHor
	 Ul7onIPbF2ruxBdpAh6y8ZcspMcc9Hh9z32oj5B/nX9Vq2DDPAf1wmbilaK2xilwfTD9r
	 /iV0TIuT7YYI9Z8YDVJsiF+eSAAZ8QRjsb2f2jnSN1suOH6RgLiV73k52gjGSILmOCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kuBR5fX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ABE606A323;
	Wed, 25 Nov 2026 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuBR5fX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B191F000C4;
	Wed, 25 Nov 2026 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620503;
	bh=m3BcL03qAix6x4ZUlsS7vc5y3v37Mt1KQJ3P5VGOC6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuBR5fX/KkXYHPxbb5pUPF2t706Db/IhzBPQL30nHLY09Oay9CbXss6ROJL7xzAOg
	 Trh5AAIQu9YbErhc7aEuAA8EnlQtBq1P/tPIOrbJ7FNB7dXGHQJG7St8fwQEl9PrdL
	 NK/hNrcP8CgnyeXA9Xv+YmVY1USMePh49B/bi3oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0884/1005] dm-thin: fix leak if __set_snapshot_details fails
Date: Wed, 25 Nov 2026 15:37:02 +0100
Message-ID: <20261125143842.409600510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


