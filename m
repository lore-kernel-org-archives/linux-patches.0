Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8C7261B9E;
	Sat, 30 May 2026 17:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163789; cv=none; b=KIubtoAFXo0QpoY3/V4VrNx8QMRwm3O29oUrZ/0/iyXMkjozdEEIdmhKA2CydhkbF2l1NbtQyj+PUG26rAYberpeOv9dz7NlnhDDZqNGk0qevNiYD9SkQmaZm30cYgRKOZ62ka5GxBr75dV6ysANvpSkKVRVRX3PKicPebMNsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163789; c=relaxed/simple;
	bh=2hhyzXkgjvgPaLQWZy59ymrDplVQDAKQ/17NCY+1atg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvloFHtcVD2O/8Y1jYuI/8h9zNKwLKNRMEsycTpdpYeDL0OdSTdrkXQN6d4trUdmUoz+Vqs2rN/T1ehzHZ86Zmop+J39tnyj3AjXFFqI64ikrVjFkXqb4WGs7/wn+3cVQSySI935nwSCrLySkyhipgQAsd7rsMgazkzBuViccK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efz/Dlxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efz/Dlxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD451F00893;
	Sat, 30 May 2026 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163788;
	bh=IVJ9VSFBz2ApugICJ50+bN9pe4Fs4vWcknyz8iJ/C4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efz/DlxpvKOxnNifxZzcxvFL3UACcOEY831gBWFhpRS2ljuhotb5lpubkgUXKEzul
	 hNVqHe7FcvRKrn9JCWXEJO78cZsaqLmPrRHml7bJtoblGLKQ4JC6TGpAEnKeF4QVoi
	 REZjWkY7DQ/aYRuePaE80goMKPCWZUsQggbg1pgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 331/776] dm-verity-fec: correctly reject too-small hash devices
Date: Sat, 30 May 2026 18:00:45 +0200
Message-ID: <20260530160249.128190198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -731,7 +731,8 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) <
+	    v->hash_start + f->hash_blocks) {
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;


