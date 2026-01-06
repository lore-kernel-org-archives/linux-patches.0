Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519F629BD9A;
	Tue,  6 Jan 2026 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720972; cv=none; b=JrbBypCZktcetfwQQxa9pYlyDnMih4fe4hl5dcnrkYqbKDhgdQApG3cKELySoDVJak/Di+6cHIpe06n4XkUUbSX9Spg4g4lEFJZ8hqIO0+IcwYes3SjTX50KXbZJoRxH+NsaJU07nxdpZdvkMOzrY3WoSB+P1N+LnHc5LZM+aQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720972; c=relaxed/simple;
	bh=fS8Y+kj2XeVN/0GzJtDbZaCthbeF+qK1gkuTA0tGsSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLYQ0utlHoNI5VSQ2BKKM/ugMKL3ufmuRPPstRbnGuzTSsURMzW74//DMtKu3MNsPVTnYJeYUCvZcuzYDCAEqdUhyFlX0qnNmcElj473bJJK0CL+Y0+PBnvCKSvicuckjhHw6YgXmJgKyEulfj7uQvCHmJ/kL2mMIVGKbcrYxCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Xjivdd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Xjivdd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF52C116C6;
	Tue,  6 Jan 2026 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720972;
	bh=fS8Y+kj2XeVN/0GzJtDbZaCthbeF+qK1gkuTA0tGsSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Xjivdd5uscn9qgcRaIt/Xaw8CqYGIFs9rKqsU654UrEAXFXwgjfhv1GQBUmbT5up
	 NAxg46ZZSVk3aHHBiPcbrNysXkqJoRAu2onDA3pgyiENJLnomIZYAbxkCgwfvw9+fp
	 upwA/iATva3Fy8gxIadIxricZP1UUejud8g5mcPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 6.12 398/567] dm-bufio: align write boundary on physical block size
Date: Tue,  6 Jan 2026 18:03:00 +0100
Message-ID: <20260106170506.062815974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit d0ac06ae53be0cdb61f5fe6b62d25d3317c51657 upstream.

There may be devices with physical block size larger than 4k.

If dm-bufio sends I/O that is not aligned on physical block size,
performance is degraded.

The 4k minimum alignment limit is there because some SSDs report logical
and physical block size 512 despite having 4k internally - so dm-bufio
shouldn't send I/Os not aligned on 4k boundary, because they perform
badly (the SSD does read-modify-write for them).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1375,7 +1375,7 @@ static void submit_io(struct dm_buffer *
 {
 	unsigned int n_sectors;
 	sector_t sector;
-	unsigned int offset, end;
+	unsigned int offset, end, align;
 
 	b->end_io = end_io;
 
@@ -1389,9 +1389,11 @@ static void submit_io(struct dm_buffer *
 			b->c->write_callback(b);
 		offset = b->write_start;
 		end = b->write_end;
-		offset &= -DM_BUFIO_WRITE_ALIGN;
-		end += DM_BUFIO_WRITE_ALIGN - 1;
-		end &= -DM_BUFIO_WRITE_ALIGN;
+		align = max(DM_BUFIO_WRITE_ALIGN,
+			bdev_physical_block_size(b->c->bdev));
+		offset &= -align;
+		end += align - 1;
+		end &= -align;
 		if (unlikely(end > b->c->block_size))
 			end = b->c->block_size;
 


