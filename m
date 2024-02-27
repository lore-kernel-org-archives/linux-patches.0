Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F8145B24;
	Tue, 27 Feb 2024 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041608; cv=none; b=sQRWeHlZgKsEglhUZdmMC3R3+toZ3M9l95qFS7o+dM0EjEX3Dg8Ufi2z0cVwZmHH2sNbJ6vtOHHdjeorlRXBEPei3q+5Ebnxz0fHFu0n57kkeSoyrWIG6MZVB3v6RDLvPoNjSUj/vOeM0vB3XGgDyD8ZsEJqUkxcB8C+x8CaeAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041608; c=relaxed/simple;
	bh=aB50/IYL4du53ZSPFgX2xc7FXhL3vUfaNu9qKRiaNao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1Z8p7iXA+lHgOF5w9LyD0gu/EPA9U+Qc6vm36CsPCjg6K6Ktihf1CT7Gd5H7cHDl83OwYPCNnIUvpjXI3QYfwQHMiegXbw4UwlIgODkx2/5wrddAYUxXcH9xQKMW1LLBanh7tVi9r8aK5+Nem1V6lu6ZzO3KBQEKwge7B2k0XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROpqcM1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROpqcM1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982FEC433C7;
	Tue, 27 Feb 2024 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041608;
	bh=aB50/IYL4du53ZSPFgX2xc7FXhL3vUfaNu9qKRiaNao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROpqcM1Z/B/G7Xo5YA87Nw0hTLCVNOfilOTuZz4rCEM/DQuD2qGh/syLyRR0nRJcI
	 JEYvkTCqSYs0em2LW5lORKqwBV9qaeZxWZH+VyAEsJ+hIgBWnZGefn1moFB3+8HN9h
	 JfyuZ1WSqB4EcNUmZDLH82mG2CPr0UY2cq+DCvSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 29/52] dm-crypt: dont modify the data when using authenticated encryption
Date: Tue, 27 Feb 2024 14:26:16 +0100
Message-ID: <20240227131549.488413493@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1734,6 +1734,12 @@ static void kcryptd_crypt_write_convert(
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


