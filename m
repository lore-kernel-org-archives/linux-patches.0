Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623459;
	b=ZazC0Am7PQY51QQkclcW6Z97+SAgrLZuwzyenWCvGsZ1whbf1Ei0pxrI77WROIQne/vu
	 41unZmn7nLiST3aXto7qoYcNjGFJHMrxl9IwujPvJD30lH5iAg5zxDhfVnKXIVIgH5b/k
	 u+waC6XyzHcp0bUkY5mj4fnRFLNeUOTno81IDubt1o55vrhDtosYWhNrZzdqOZcdhDMiN
	 YXHe2ePDghm6/lUWhHaXBtIaI49EbdPjOdk09FVnGqGEBYeFik7MbIp3g59U+Ho66sE8M
	 7Ko+HNKf0h4+ORRIzh0iXrc9D5qqp4fCHWJn56+xDGOQgjnmsqyYS43ca8V7vXOAlpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C79EXoflTAELj6/LgEuLS78r+Cbgj0rhvV6WDwrxGHU=;
	b=1rtiygDhhpOtzSJw+3/tkXMs6ubMLuTJIDioLgzuTJ0GkIKCluRNWpu4EA7qLrchFruW
	 A8u/akONEBBX2VaGVV6/U8HJs7GwXLhTh1hhoODu3ssyYz7Mjwm3QjdnDQpYiNWEtcfMa
	 Tr7U6KhbXluRRXzLdv6kK9lZ2OJhLqTJ2QsYGNNVUU+96/T6I3PyI7oo5HMHjFYFSvR5h
	 JmXOUo2UJtoCE1FPHB+4c9gulZ0hZB0gch7v5nV3OaOhh/bmyOmk+qygEzspoPg3OOvn2
	 r6mxpRWIfQ00gT8XbU15wO/elfL+PwfG5YgMMcAPFGaqUo4hXTTnVQdBsLc7zIWCdaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQgKV6sd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CF6606A321;
	Wed, 25 Nov 2026 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQgKV6sd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141B11F000C0;
	Wed, 25 Nov 2026 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623459;
	bh=C79EXoflTAELj6/LgEuLS78r+Cbgj0rhvV6WDwrxGHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQgKV6sdx9epxtpDkXz/Eh18bQH0NgtJayqWQdj6nbG4pFgLeu+sf3zKjs/2rwljV
	 7EVlfPagO1nwYqNvNISFBnJi56xveyiR2r7AQzjdeTCDS2BIxQNbEc4CRKk/kKFdk3
	 CMkD4pnXpKrtIOykCtYr/RYqmY6sUvtIFSMc8lDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 866/990] dm snapshot: split discards on chunk boundaries
Date: Wed, 25 Nov 2026 15:37:13 +0100
Message-ID: <20261125143842.309299742@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

commit 4fe2c2baad01da64d47f1a0c8fc093df994bcef5 upstream.

dm-snapshot did not set ti->max_discard_granularity when it allows
discards, so a discard could reach the target unaligned, or spanning
several chunks.  Set the flag, so dm splits discards on chunk
boundaries.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1364,8 +1364,10 @@ static int snapshot_ctr(struct dm_target
 
 	ti->private = s;
 	ti->num_flush_bios = num_flush_bios;
-	if (s->discard_zeroes_cow)
+	if (s->discard_zeroes_cow) {
 		ti->num_discard_bios = (s->discard_passdown_origin ? 2 : 1);
+		ti->max_discard_granularity = true;
+	}
 	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
 
 	/* Add snapshot to the list of snapshots for this origin */


