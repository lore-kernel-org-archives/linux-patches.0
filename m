Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207685;
	b=aH9tEqv/Ki/UJC43xp2Quy+4BCOky9qGVXQw+XC3VaMkLIOs27sV9E3qJBHVNWNZm07J
	 ZNOYB5mIpXSTD+PFCo7qGWUws5pJtiYMmi4iPi3yey8rWYNS8LkO2zqqefMwVNNY1Exho
	 ACPC7abA9qj+iHt8Q6hNBxffmPBq4hcYCsW5BBIcrQaU9Y2x+fArHglgQcMXtUB3PZwWV
	 C4m/4ecjSNQDKSwMAUZH8v4u7mS1LTWokNzjTNdzStu/Jf1atoI5GPanJg89ziOWSj4/R
	 g4+LABgb5Qc7iqR65Mas+Fr6x/EHT0n5QVTD4b/tE2y2T0QsQcG73Hgezr2hJZuRtkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0dQN4obddbRGA3XUkBq63V1pk0kkAe8uKoQ1QI76VeI=;
	b=YJyOnMEXkr8h3l7yXC1yabS8bKmAv2k24ncouHX6kAd2wVV/HrMcQlvzZgDZrTBd8zB+
	 Akdk9O6hfmWk9Mcv3yuhTo4JVO6T1A32qojcqV7JVaGnhTxzLcubm7kKwfNghYv9VCUbB
	 +R++PiZ8N031E43x3Rxo1DwymtoWCrJxUj5WVvjBiDKMpwtONmzvSaSdv2+lUPwoP0+zs
	 5Vvp38+Dax4j2AqByoS6g+pVM6uxDJAG+YnA4KsiaciRUBrvaO/4g6mP8uiJRCVDCdtgU
	 ZOWlEV8ibn2ogc0rmKTRlnQ7+fQOchxcpMmnSDvJs/NGKAFclLAC0Y4wKKChkdISyEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiZ7pQmf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D73606A31A;
	Wed, 28 Oct 2026 17:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiZ7pQmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3671F01825;
	Wed, 28 Oct 2026 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207684;
	bh=0dQN4obddbRGA3XUkBq63V1pk0kkAe8uKoQ1QI76VeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiZ7pQmfwuD6GYnnCobcyTPBS5mP8Ir/nQ/WTRo/9gDrUXd0lmYdK2X+pZ4IRXlQq
	 CJI6dMY+lab8E/g4o6MG9kUsx0+RTLAUlET/DOW79CPNXnK/W1nA0PooZiNJFeAdHP
	 MLYuDUyc2OWbdz6YO68G+erMXKL7XX9R/xULygAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 103/247] dm-integrity: fix infinite loop on discard with large tag size
Date: Wed, 28 Oct 2026 17:58:26 +0100
Message-ID: <20261028165949.836002877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

commit 18d80c77b4c7dd20699e81cedfbbff4e9d198f28 upstream.

When integrity_metadata handles a discard, it fills a buffer with
DISCARD_FILLER and writes it over the tags, max_blocks blocks at a
time. If the kmalloc fails, the buffer is the on-stack array
checksums_onstack and max_size is set to HASH_MAX_DIGESTSIZE. So if the
tag size is larger than HASH_MAX_DIGESTSIZE, max_blocks is zero, bi_size
is never decremented and the loop never terminates.

Fix this by using sizeof(checksums_onstack) as max_size. The array has
MAX_TAG_SIZE bytes since commit b93b6643e9b5 ("dm integrity: fix a
crash with unusually large tag size"), so max_blocks is at least 1.

Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1856,7 +1856,7 @@ static void integrity_metadata(struct wo
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 


