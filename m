Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAC416423;
	Tue, 27 Feb 2024 14:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042674; cv=none; b=ueOFXsHKWM4Xal9XqkcidVv8ZeVYEpGQJKhZ+3LFGtRMiP6Xs4RKibA/ruun57BzvwxaPYLg5HdZZ8j+fMzeSRUp81f/yuiZnrxjiV+zCutq7Eikt3jauHyF5pbIvr86H1Nv20FkOVwoeTJs+bj/aApD0KB1cZ5Y6A7EkCVm3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042674; c=relaxed/simple;
	bh=o6KKztbgE0KtpCMsfUVSFSQev3r/x6mbldEgcC5CAXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvrPQfNU+v77+pt5M2L1oebc0IL3ocYyTrFhV0LqNzajUXQMXqJGNIg59iIdOKfjqMWsoNVSwhwLYmaSlmUOAoQDBsWrB6SYRB1RU7Md47H3Al+GPHi3QWiQIym3Q1LKHdK0jxNLlWFS22L02QIDmVYDwbzgu+eipam/CJ5PrCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8fVUSuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8fVUSuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1ECC433F1;
	Tue, 27 Feb 2024 14:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042674;
	bh=o6KKztbgE0KtpCMsfUVSFSQev3r/x6mbldEgcC5CAXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8fVUSuX4XdFaw1zsynZ5OCZ0FMYPtlDSwLSLAr03bqU0tsaqSrOfdgQRGt939H5d
	 3iVd//0A2ATjj2MmZT7LMtlTFFr1+LGUFFx/2PTJJm1J+7pomK2hvaC5uNBtdJxkYe
	 OBx9krzSn3XnCBNp4Ym69tZA3GLtfFeSctmdttGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 079/245] dm-crypt: dont modify the data when using authenticated encryption
Date: Tue, 27 Feb 2024 14:24:27 +0100
Message-ID: <20240227131617.808681202@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2065,6 +2065,12 @@ static void kcryptd_crypt_write_convert(
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


