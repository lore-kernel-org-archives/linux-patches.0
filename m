Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484721E534;
	Tue, 27 Feb 2024 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040939; cv=none; b=OjHsy1kmK92J64CHLGe7hdL11Lk+rDCiJXiiXDCvTSyQB9OJG/fr11hkzdaCdCE9ChtTliuwhrdHnT0ofiJnQVaPgdcJFZC5l/E695HfBLsz/0H5m2VfMtmtmo+LzrJuRi3KBl3rXlfK5c8A3ADSp4yfYSk96Qpr2SMAYuJU4pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040939; c=relaxed/simple;
	bh=huPkkyvreQnHBf4nx5/6EsP/kLoB2viNcwl9p55dtUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cv+NFBgraooGd11/q9goEZ/2eX7KmQ9mZ7mfE8bj+yYYjehYKC2swvIdj8qShf504ivO5gQ+Lt84cpSbZHW8CcTiUYG/N18UmeChPfykdxA44i/5S66Vjc4nZG29vicjk+uM+DqYQKCtwizHHWk2iTS/nfaabG6vqLei4GU9l1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5kgYgBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5kgYgBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5F4C433C7;
	Tue, 27 Feb 2024 13:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040939;
	bh=huPkkyvreQnHBf4nx5/6EsP/kLoB2viNcwl9p55dtUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5kgYgBTw6J+sA6q29teAXbjD81hsueTkd9pkMdGJuZ+MJYfPxz42bmuw4YcdD5Nz
	 HoWpRpOL3cdQj36iQy16heNlz29UXirTAQeekoDAH63mSJMBU+lAAl7Rw1tRCPEEO3
	 pkQOtnGUCGyaaRMbuY0AcjtxKz7ZtvZ57gbrf710=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.7 162/334] dm-crypt: dont modify the data when using authenticated encryption
Date: Tue, 27 Feb 2024 14:20:20 +0100
Message-ID: <20240227131635.721507330@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 50c70240097ce41fe6bce6478b80478281e4d0f7 upstream.

It was said that authenticated encryption could produce invalid tag when
the data that is being encrypted is modified [1]. So, fix this problem by
copying the data into the clone bio first and then encrypt them inside the
clone bio.

This may reduce performance, but it is needed to prevent the user from
corrupting the device by writing data with O_DIRECT and modifying them at
the same time.

[1] https://lore.kernel.org/all/20240207004723.GA35324@sol.localdomain/T/

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2111,6 +2111,12 @@ static void kcryptd_crypt_write_convert(
 	io->ctx.bio_out = clone;
 	io->ctx.iter_out = clone->bi_iter;
 
+	if (crypt_integrity_aead(cc)) {
+		bio_copy_data(clone, io->base_bio);
+		io->ctx.bio_in = clone;
+		io->ctx.iter_in = clone->bi_iter;
+	}
+
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);


