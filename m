Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1D2145FE3;
	Tue, 27 Feb 2024 14:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044214; cv=none; b=oNq9NwKKPKnPW8iMyCv9agBFQTanqrWP/ZV+tFBrVXYcrHRtbHVIuy0IhCRRHqEsCNCR0tNtIGm2MNNs5KBqdR7P8fz92mHuqLLhTiRHUymE5gydOGyR/QBmEYNwFSUHgBbzKDTdxQgB7MFeHPVJCL7ltNDPqNLcgwbOSay/OOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044214; c=relaxed/simple;
	bh=vFBPWm6LckukMVwo3vGAvIYXWqHPP0tV2HYhLNsff0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2+ixzy66glgfdsZ2vsvlrSN4zlFzY0nXxBwX8jK+qHlMHadD5c0wTKMa0Xb8LsD4QtZWWU/b1rjlr0sYBv02kx5zigU0ZhOPAfJUvHwznyZK7E2lIGsIV9V5lX3/KUQrfei+SL6W5YGSrFt3omONZHGwZaS51lbY+T5QU1A8Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/M23ZmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/M23ZmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8461C433F1;
	Tue, 27 Feb 2024 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044214;
	bh=vFBPWm6LckukMVwo3vGAvIYXWqHPP0tV2HYhLNsff0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/M23ZmG40zh/6ZvddGWT1ad8rh2CWzuZ0tyuT6Gweu/20ltjuaB/RC0R2vKue8Mo
	 Pn9qAeo0foGrzu6sQSRZ7lKWaWLYYVCpJUCFx3JF/TJNvogEbISkNFHWs7LtOE1es3
	 CNNGFuKEpyu4i2drbDWoubUOJ7ehOqcIqF1kOXjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 076/122] dm-crypt: dont modify the data when using authenticated encryption
Date: Tue, 27 Feb 2024 14:27:17 +0100
Message-ID: <20240227131601.193523159@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2064,6 +2064,12 @@ static void kcryptd_crypt_write_convert(
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


