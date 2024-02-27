Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129D413B79F;
	Tue, 27 Feb 2024 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042022; cv=none; b=Zk5ZlaKQnDHZyDLBv79dOedyic/L9jyZmg/yqE4ujBo/9V37F/Py68CEf0LN7fLv04ifeNri+4NPyBPlREnQuyEWNT+o9fuyszq3r+vryFsXOEFswxfmm/MDdDhkg8EzcaaSc7J/rs1qEeBs4q/QgPh1z48HYOkOu81mjz8nKTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042022; c=relaxed/simple;
	bh=7j4fkQ4ObMh4ZkWQMB2A8pMPxYizMQW5GBAd8YXZPso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fmca52UmEld2Bzkgs4UoP6VzBgqwHzN0sb+91pScF9jPjJJVS6MsvHy8UgDC8mBCBj2QmVnF/5QujkPtRHJufp35dOkzJONwq1LAu5h8yR6ZObdEIatLhlqh2s8GfRTWS/B3HDb9FIrtqX2uC7TaTUnKDdWUGy88vpp/jCQYqqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/qfWw6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/qfWw6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92980C433C7;
	Tue, 27 Feb 2024 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042021;
	bh=7j4fkQ4ObMh4ZkWQMB2A8pMPxYizMQW5GBAd8YXZPso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/qfWw6gsiVfGi1HnJTnZLht65N6sHz9LBwmYObR4ObhtM9NJEDIs9h/3jA00++yC
	 G85MJM4Uqq4NlXJ1y0WcDj1hZHTZnR6iHIj+MuX1HfnKzdChjuYYwAR9skLOwTjDcp
	 LIiKM2rSfxzlE+gRL+iepYeSChGVlkSADgm7vfqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.6 150/299] dm-crypt: dont modify the data when using authenticated encryption
Date: Tue, 27 Feb 2024 14:24:21 +0100
Message-ID: <20240227131630.696413793@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2117,6 +2117,12 @@ static void kcryptd_crypt_write_convert(
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


