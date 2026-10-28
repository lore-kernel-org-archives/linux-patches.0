Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213260;
	b=Wtk14f0s5npLQxyAuoPzZJzu2U2m4rr8JdtxUtnp3sEvOR8pGowEgbzALfwj/3Sx6pii
	 hm0fB48nWKKV7JSawGr9CIUFAOesf9GZf2yGo850pTYTJpoH5WPoE7GajDLJJStvCNUYN
	 wMNI5ojkRZUzlk/mJF1rjx6HQibBdVsn1dL3+NOJL4UTzTfiWhxS8eBGKtbTgWSzT8eDN
	 D7gdEFgHFJa56ksRanEsVf+sK7cWpvplq/phECVr2bn2t79aKzIjkT4gX0V5Nnv06RcsP
	 Ta+CyyIzw7FXVzXDnKJBIW+Q/HLmdlS+KJ4K9eBv528QCoiR9Z83GJ+2dc1XHgQfLYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQDM7/Yn06xnIpBald1Z+eBpS3QBVjOViunvIuzNygg=;
	b=Y9SbHUzFSoKdQbTbm9XhdPdfUi5dEB2sWeRvlBiJ+fB/LEDJUgOt6KQqoNixpmpJbXsA
	 JISp7W//JY/QTNLx+4yCGB3EWk12vEDE81bSzPdGWu8h17OhkTGCgDhZSMqhSygS7B1EY
	 mBzycYT4k3/YybnR5orcJRYgKvoSFbOhMegzEDf7cTBgalcSMZ6weun08GA7y51czNaXg
	 l2CFkB4f4VcuDUGKripQYSK0SjgYEXE2bHT4l9nvgxz2mZUt2vBn/pPZ2FvBTkiLdvim8
	 +ycNwTgp3ew6fFAZbNxqC7owWc2m8sj3IHz5N2TJp+b/VBlvgXpqa7dcFsy61fINaVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COUSWcgF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7192E606A31A;
	Wed, 28 Oct 2026 18:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COUSWcgF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30A91F01825;
	Wed, 28 Oct 2026 18:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213260;
	bh=FQDM7/Yn06xnIpBald1Z+eBpS3QBVjOViunvIuzNygg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COUSWcgFxcGQfVHw+gV1xGQMiEzRnCJ01Jeyw0b7zLeLG0cUKaUZCc2t/MclbNl3C
	 1kdSp8QjOsOuA9HST9tBDe53xa3nd86q/GSj10kA7FCh8rUkNwr5jIS6RipzzlAbKw
	 QwbKO1dZYmAxDgrGCHv55gqrfndPV4OHIsDXmzX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 0436/1887] btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()
Date: Wed, 28 Oct 2026 17:42:12 +0100
Message-ID: <20261028170509.152505157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1fd742c7479961da6d0bb794ef8ac6b7b9442847 upstream.

When paths_from_inode() fails, scrub_print_warning_inode() jumps to err
without dropping the reference taken by btrfs_get_fs_root(), leaking a
reference to the root every time path resolution fails while printing
scrub warnings.  Every other error and success path of the function
drops the reference.

Drop the reference on the paths_from_inode() failure path too.

Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -851,8 +851,10 @@ static int scrub_print_warning_inode(u64
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to


