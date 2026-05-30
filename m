Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E448A3242BA;
	Sat, 30 May 2026 18:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166018; cv=none; b=n9UlJgF2fDBeFuVwjGJPsMjBkdXrZmj4Ii7+fDggDg5lS6ORUzgXar/g1QSnQm8993imkwNo/ypbccz+fJqOeYPhw3dGYf9/1DLb1oGmSztsB+IYVw6kC63LDL2PrKBqVne7XSwg2rK/68pW5Wr1EL9yyVoVssEcWPF4bzXamXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166018; c=relaxed/simple;
	bh=nQluZPJFMoKF/mcYN6+41LCZo5bjstos2N4bK7Mjxi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpfICn9X5OmNwaVnTfkDejPlkwg51/ltzHi0Kf0pVXrSMKlkC6yZ9AdhFXpiN/ZMiaElzWjB3T/4XwZZfUuD7Xfv2g5TRolyqV8wa7RCgQIO9yrQBt1iUtOAWRglE/vehIzMpV72ZpPgyHJQ4JiI0Eo6JrdVzXDcqLFipSkYGao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tS1P+Fuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tS1P+Fuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8101F00893;
	Sat, 30 May 2026 18:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166017;
	bh=w/iVl3G6zb/nHqLWvSbfhORLg4qXwbQZpckqdbk7spg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tS1P+Fuuikd5BDZoLcZ93xeLQn5BTLc+6+9Wsq4aUxE5u+JF6azGJLH2iKtEQaNXV
	 Iu9iRKINDKu18Vka77XlmtdKL/bAj2IYxmquVH/HWT5BUd6HMoKdBaMscDn+LFq7QV
	 edlknZ62DXGFQbrH1jCVN/LB3yacnId5hlRESdrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 250/589] dm-verity-fec: correctly reject too-small hash devices
Date: Sat, 30 May 2026 18:02:11 +0200
Message-ID: <20260530160231.560208225@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 4355142245f7e55336dcc005ec03592df4d546f8 upstream.

Fix verity_fec_ctr() to reject too-small hash devices by correctly
taking hash_start into account.

Note that this is necessary because dm-verity doesn't call
dm_bufio_set_sector_offset() on the hash device's bufio client
(v->bufio).  Thus, dm_bufio_get_device_size(v->bufio) returns a size
relative to 0 rather than hash_start.  An alternative fix would be to
call dm_bufio_set_sector_offset() on v->bufio, but then all the code
that reads from the hash device would have to be adjusted accordingly.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -733,7 +733,8 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) <
+	    v->hash_start + f->hash_blocks) {
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;


