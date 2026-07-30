Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED98384223;
	Thu, 30 Jul 2026 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426816; cv=none; b=ZcHJm/XxsIvQcQiufAo5DQjY7kcmxg1VKRR3Zo4Xo5lbeZeu5C6FDNXdNeJ2xGYy2eYH7V+at+TB76MTD7V3QxBIlctwEjKO4VObrWtoiC3BQYEkmQRnj75184AG8zfoItVgiIYeTLuUmFr7uKBaF2TXLdy8Ekfl17MyUU4Vjug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426816; c=relaxed/simple;
	bh=wf0NHSlk6ckDK3DEILtmRtzIjSIeRFeVUyUI73MOeM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/wUwH17iBFyGYqYx4RJeXM9P8hZSHLt09gIdNP46vmEE5BQ8pqPWAcxA/3LM5WkJ0rpGrPKq/DnD538z/KMzoYw69yG9bAcgQDWLsuT0Wvg8viSaBSg24AN5B4NgH90X2O6TNt/zUiAxcxbq7KflM4HkNJjjiYZLwh3+JGZtB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVO3tEVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVO3tEVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C941F000E9;
	Thu, 30 Jul 2026 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426815;
	bh=ENGYIbs0NJh/DYK1aB0CAgU6Jh5MOHpSGhzEoMuNtG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVO3tEVYKBjOf3lDVn4eysYpi0226sx7uNIFt5N3ipSSkX7x6LfiA5txUkkpZo6Ez
	 zgjLKncWPaN0MxgtOioIN6aPtkKyJW/LU5zqxN60LZAoHF8OOjb1suHCTksTWlBi8m
	 gE0jiS8fYLPh6N+RQtSp54VTLvw3Hqcsz4M3SqSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Blechschmidt <iblech@speicherleck.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ondrej Kozina <okozina@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 551/602] dm: avoid leaking the callers thread keyring via the table device file
Date: Thu, 30 Jul 2026 16:15:43 +0200
Message-ID: <20260730141447.613353073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Ingo Blechschmidt <iblech@speicherleck.de>

[ Upstream commit 981ccd97f7153d310dfa92a534525bbaf46752c2 ]

The refactoring in commit a28d893eb327 ("md: port block device access to file")
accidentally causes the caller's thread keyring to be kept alive long
beyond the caller's lifetime.

As a result, "cryptsetup luksSuspend" silently fails to wipe the
LUKS volume key from memory.

In detail: "cryptsetup luksOpen" uses its supposedly ephemeral thread
keyring to pass the volume key to the kernel. dm-crypt's
crypt_set_keyring_key() copies the key material into its own
crypt_config structure and then drops its own reference to the key in
the keyring with key_put().

With this fix, restoring pre-v6.9 behavior, the copy in the thread
keyring is then promptly garbage collected, such that exactly one copy
of the volume key remains. This single copy is correctly wiped from
memory on "cryptsetup luksSuspend".

Without this fix, the thread keyring and the volume key in it remains.
This second copy is only freed on "luksClose". "luksSuspend" neither
knows about this copy nor has any way to remove it, so the key remains
recoverable from RAM after a suspend that is documented to have wiped it.

This fix should not introduce new security problems, as the code is
anyway gated by CAP_SYS_ADMIN. The device-mapper core, not the calling
task, is the legitimate owner of this long-lived file.

Fixes: a28d893eb327 ("md: port block device access to file")
Closes: https://gitlab.com/cryptsetup/cryptsetup/-/work_items/993
Link: https://www.speicherleck.de/iblech/cryptsetup-luksSuspend-issue-reproduction/
Signed-off-by: Ingo Blechschmidt <iblech@speicherleck.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Tested-by: Ondrej Kozina <okozina@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -737,7 +737,16 @@ static struct table_device *open_table_d
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&td->count, 1);
 
-	bdev_file = bdev_file_open_by_dev(dev, mode, _dm_claim_ptr, NULL);
+	/*
+	 * Open the backing device with kernel rather than caller
+	 * credentials. Otherwise the caller's credentials would be
+	 * pinned in bdev_file->f_cred until the table device is closed.
+	 * That would keep the caller's thread keyring alive long beyond the
+	 * lifetime of the caller, breaking userspace expectation (e.g.
+	 * cryptsetup(8) leaking the LUKS volume key).
+	 */
+	scoped_with_kernel_creds()
+		bdev_file = bdev_file_open_by_dev(dev, mode, _dm_claim_ptr, NULL);
 	if (IS_ERR(bdev_file)) {
 		r = PTR_ERR(bdev_file);
 		goto out_free_td;


