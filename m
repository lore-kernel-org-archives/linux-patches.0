Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623451;
	b=Qu+aq44vUNhFEES+DqdT9RQrRefP+imEHjHLMd/1tOPkBAk2lsKlgf8QAqKwaqhuUD1L
	 1xBWagU8wmCT0gqxvsg/79zaRMk8OrX9FDjc6lSl5uPLXKj/l5Se0xECUQ43ApRbkba75
	 AeNpjqLkkKXm/2v2gU6aiYfoyF4xSiVW7gKAX+S5vgBCwnOQFAKpauZw1+Z2VWWmBniyK
	 wM8iRUbLMsXOPQcwbtBh6eZRg5XausIzTLsGlW3kL2jQhCEmOntqXHvGrgyHqvHdcsjN6
	 bMjgECmppKIagikC2qG+xMGD2v1MHvlAJpJ0vhPVompXt9u9/ME21iyeV379c+vuNGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rPH3l/dv8BsXEu/55GYS69vpmro2ryZVXvsuX7YDsHw=;
	b=jk2oQe5BVXqCJjShtd7iXF3rF9oMVTKKfwz+lgX4vmnWy9Puy96Vq1fp4lMm2Lz7J+az
	 2Qg78fTqYVsCPUJKl4qsgdUm9Rk9qDrsWbgLmiq23d5tJw31e6GEAKfLwSO9YrmY08Tva
	 TxkM2NHaTsSUFga87olpT4uBpUtsk7UYEC+1V8GHPth4qQx/c0MxfbUFlPlbCmsL1o67G
	 i4EFqSyG5IH+iIE1DLWO4V0gbZAgPlZaHUCMdh0jjeRuZ73HynXUwdQGr+c1eoqv2EFYW
	 FzQVvwtClu1ISr5OdtFTkwg+PrEpVOhH1w94Hl82MZ9jfYItaEU2WJi6yyAxlnmR+4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cGhT4UWY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01943606A31E;
	Wed, 25 Nov 2026 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cGhT4UWY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ABB1F000CA;
	Wed, 25 Nov 2026 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623450;
	bh=rPH3l/dv8BsXEu/55GYS69vpmro2ryZVXvsuX7YDsHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGhT4UWYKilFUFXpdP9f02o/Fh8ZSWy+7Gjmfvk1IHnqUnSpZKfK590N85G/+uL07
	 6XzK1ggm7KQupuELLkrT1ACvJp0kqz+Xmg0P4WJSangqnssT+0hvsOp8+BBnAhxIW4
	 0nwdSoXsNpsvUkcSv6As0h/hqZkS70dWyQSteyI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 863/990] dm persistent data: dont ignore writeback errors
Date: Wed, 25 Nov 2026 15:37:10 +0100
Message-ID: <20261125143842.241125532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit fa887f2ebee7aff97eb87b3365939616ade09774 upstream.

An error returned by ie_cache_writeback could be silently overwritten by
another successful ie_cache_writeback. This commit fixes disk_ll_commit,
so that it doesn't ignore the error and returns it immediatelly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 6b06dd5a9722 ("dm space map disk: cache a small number of index entries")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -1190,17 +1190,20 @@ static dm_block_t disk_ll_max_entries(st
 
 static int disk_ll_commit(struct ll_disk *ll)
 {
-	int r = 0;
+	int r;
 	unsigned int i;
 
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
 
-		if (iec->valid && iec->dirty)
+		if (iec->valid && iec->dirty) {
 			r = ie_cache_writeback(ll, iec);
+			if (unlikely(r))
+				return r;
+		}
 	}
 
-	return r;
+	return 0;
 }
 
 int sm_ll_new_disk(struct ll_disk *ll, struct dm_transaction_manager *tm)


