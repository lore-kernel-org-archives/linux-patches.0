Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620299;
	b=LhwZWik61RODZZnUFK2IRd6RYRdKldXtnHiGYDu8OUTW/yCWulIiBuh7wgDr+mxrVChR
	 EfDPlFWrpXMxk21F1mhH3gcDlv3L8k4IUMydW0mx3p3UbWI5KQGnH+p++QvyOI+aYJGw3
	 OiTuICuiHsACXkFokI9E/C9GF5fyV288EwGhqlmNkrIJkS/8ZteVdzVomGUZ7ucW0+512
	 WF/2D5OulSNbqZQipMiitubSFyZ7PQvNDKGP9sMMmksCFRC6+GHvPEjd4/H4fOueBRcOh
	 ZkEiFLDYtQAyWUUBYD7FVmHO5Bixo0nchcd2SPBwyuzKmjLyDQ1yzqAaCaqOFQ2iYWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xvWJx8hJ8lAkR0IJstBLBBBHYG95DajsuY827THQluc=;
	b=VtiY7VDSzOJokFS5Oop9geETzFZ5tQS0G5JfPp5A+yKP6BHtiTYtawVNi7Q5damAb7zz
	 oNdZSukVrF5JwIxpBFC8b6OUgktbcV5l/18ACv3BT8PlcgGrGaYGF3v5MVOk6hwpqR3OH
	 J+rR1L/SV7TS6JL2bUqwmLZ1XeGCBeX3t2Efk8jCo8WGnR761XX9Ng2KHmifhZ6RYFZHG
	 f1JtqHJHmMbXaOYp+PRlz3rcuJtGnUF+eWSNEfxtNtPhfp/t9HntYyiEcWoMO6R0jh6XH
	 9k6Xvln5/bDS9/raIfYaEMIv7q24GvJKeTSWQRiTL5br6xlprNRdndJBP+vn3AuymHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcP7b9Tz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D6F606A32C;
	Wed, 25 Nov 2026 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcP7b9Tz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CDA1F000C0;
	Wed, 25 Nov 2026 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620299;
	bh=xvWJx8hJ8lAkR0IJstBLBBBHYG95DajsuY827THQluc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcP7b9TzEZ05i187TiASa5YGvjXxbS+PKXcG5ol38ryJeAWn+IGDnxONMvpQZpCd0
	 PiAYFr2uSz7n5yhgrneTIuSpZjGRSnS+4ZIOC/UUiJ1duL5Y6U5TGvcKC+rx8L0+nS
	 L2ac3A/8DcDfTAOo9yTknoz+ajP49joTuiG1p4oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0871/1005] dm snapshot: split discards on chunk boundaries
Date: Wed, 25 Nov 2026 15:36:49 +0100
Message-ID: <20261125143842.110522561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1358,8 +1358,10 @@ static int snapshot_ctr(struct dm_target
 
 	ti->private = s;
 	ti->num_flush_bios = num_flush_bios;
-	if (s->discard_zeroes_cow)
+	if (s->discard_zeroes_cow) {
 		ti->num_discard_bios = (s->discard_passdown_origin ? 2 : 1);
+		ti->max_discard_granularity = true;
+	}
 	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
 
 	/* Add snapshot to the list of snapshots for this origin */


