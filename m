Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDB33B95E0;
	Tue, 21 Jul 2026 21:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670146; cv=none; b=gIjbdDOYQS3rzyNUyyckz5vTuAcfTZSDzDw0u7QGP4bNlE9GMBNt9xn+SIWypaGfG4lbathbN9Y5UBHUmAdc0BU4eDxFMrzXQHYr8bZ494Yu6aa6yoInZpT0HsR/nJ/a1+F6uttrTQSrvCJR63iON5mXnTInz2jp2USo9FeMbgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670146; c=relaxed/simple;
	bh=zMa+AtzbKW2cf/F8A9Do4w/MatymhN2L+F8pBeGdIrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBFBMk4u5i7Cudzzb8I4dCyhpqgYnmlmPFJve6+wxp3aGyYSIGE7Dz7Qpic0mXLhOdeqmO6NFdfxBtHFE4eB+6FrCHSSJuSuSZXeh8NjS6WovrXiQMcpcX4DkDIa976fi7Z+ZlWgv2+q8hpqDb6K6Ok8MUrVe6+WWiSFoeriyVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVGSKWR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVGSKWR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17031F000E9;
	Tue, 21 Jul 2026 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670145;
	bh=5lpC+GbRRvMFW2fJlw5yNRs8rmp7UTr83i71IXA3fQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVGSKWR+K6ihHFcqHLF5NMAQOv/9lRZ1ERwXs0hv7jST0SXJEYZuEXblPanUUqQ3a
	 W6GpJzDHhhXMzI6pZrBB9/QFas8Gm69XNN0T/kJxHW+mCElOuphBqHNqA0vVTOanta
	 IybRRZvuZUWsN6UDx2sdgY6BKT/r5NltcLNorlBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0795/1067] ntfs3: fix out-of-bounds read in decompress_lznt
Date: Tue, 21 Jul 2026 17:23:16 +0200
Message-ID: <20260721152442.347400751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 7160a57192fb16d7a6fa9b7f5c7ac341d2444a89 upstream.

decompress_lznt() does not validate array index bounds before accessing
the decompression table. A corrupted NTFS3 image with invalid compressed
data can trigger an out-of-bounds read.

Add index bounds checking to prevent the OOB access.

Reported-by: syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/lznt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/lznt.c
+++ b/fs/ntfs3/lznt.c
@@ -240,7 +240,7 @@ static inline ssize_t decompress_chunk(u
 		if (up - unc > LZNT_CHUNK_SIZE)
 			return -EINVAL;
 		/* Correct index */
-		while (unc + s_max_off[index] < up)
+		while (index < ARRAY_SIZE(s_max_off) - 1 && unc + s_max_off[index] < up)
 			index += 1;
 
 		/* Check the current flag for zero. */


