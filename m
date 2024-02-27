Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E84713A26F;
	Tue, 27 Feb 2024 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043393; cv=none; b=DZcvgwwjag9KMXVRmM5UgbohKRnuZSv1BVHy2XQXckC7i+2xJqLypjDkQIPRcMVVWdNJCDBfwACYYYNShXid29CcoqsVKC7zsSUcBXvjjboJOjVxNIxTOkbcHxawrAmgdwf/HXwT9Jl6q83yS+FmDM41Blo3WmaqAf3QD4r4Nmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043393; c=relaxed/simple;
	bh=XXnsp8X2DnpVENLZflIzUZXA3DLUw+ggHStYoX/rNJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkFt8tWU9PfmjCkpNrvjwd2eftIiZPQBwi7l8A3vfzZ9QDImFCDwPGGfRz7Q4HDLX2x+kwh+b3BnoV9kYRTiEsqUoZ3Z2vRJCWnZDDXloH9abwfkdBHcs9dggPlA7g4AO2LZ7ksXO5jcMVc2vfiLGfJanXNgSXzA+XXdgbMs598=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8DoGKQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8DoGKQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D980C43399;
	Tue, 27 Feb 2024 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043392;
	bh=XXnsp8X2DnpVENLZflIzUZXA3DLUw+ggHStYoX/rNJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8DoGKQIMjsbGKqZcK1flDZ0mNCNvPUWjTNdHmqo2Ap0+yS6BdvvnD3i8pIr7jAKc
	 xMsIe2GHQp3HNGrDLisHXmdVJXgsJ4iTCndQb8h5WXPGWjylawR01/qNawK9LS1Rt9
	 fMZsfOKQAsf85hqAWxNzt7IQbdEaAUfksApzDUUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 091/195] dm-crypt: dont modify the data when using authenticated encryption
Date: Tue, 27 Feb 2024 14:25:52 +0100
Message-ID: <20240227131613.485210816@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2078,6 +2078,12 @@ static void kcryptd_crypt_write_convert(
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


