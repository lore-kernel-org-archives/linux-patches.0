Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B90403AFB;
	Tue, 21 Jul 2026 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654943; cv=none; b=uZ496hL1hKqbGUfnkhbRBYwOX+ly0HlKmzQ0xWDJgFt5VX40iGgbxk72tHMqTT3RwRMnKNkG2+/9BeccnFVivCPJPiorjTahko6NwCmVv6zc+BRSYdZ76vkI0T22S3BOOl7wEkeBxzDi8IsM+EC7TTMPBdeAalQKUKJyPjLIRMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654943; c=relaxed/simple;
	bh=0KPynoMBvq+85F/ajbpLM1bChAuE8FzZD59Pq8cK95M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZ+QmO4mDdoP0Sk6iabOBFEyNzVr44TS9I0Jt0bYHVKNLMm9vido1KtL22g5qQqdd7/VHYjTtkZ5bdjnI5RqJsPCC8JfF0eWTQGUFZn9Yn6cxRTUnKx0ktPKkY2CcoRu9Czm0GeoO4wuZQ4In6F2JBGsI+0H09O/8uLiksIUA/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDU2Jq9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDU2Jq9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814511F000E9;
	Tue, 21 Jul 2026 17:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654942;
	bh=E1AzbnR6AYrU2FfrxDaymEIPUPRLbMM4pwyP1sRVE0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDU2Jq9oMvGFfqrUHxDpQYU0PC0jwSI6X9Qebw5+xzEYfXgPmEdEAkc0jt8gkwC/v
	 JkR2ECbz50dJSAc13YBiI81qUy1FSIsMdDuMfzP1uKBOYsfF7oU9S+sGh/zZlnFxGr
	 cz3SwQbI1Sga6pem8aQwCNE9GfLH2BuJ8AvjmfGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Blechschmidt <iblech@speicherleck.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH 7.1 1852/2077] dm: avoid leaking the callers thread keyring via the table device file
Date: Tue, 21 Jul 2026 17:25:25 +0200
Message-ID: <20260721152636.418087320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Blechschmidt <iblech@speicherleck.de>

commit 981ccd97f7153d310dfa92a534525bbaf46752c2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -735,7 +735,16 @@ static struct table_device *open_table_d
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


