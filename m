Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BA3BBA04;
	Sat, 17 Oct 2026 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257221; cv=none; b=Rhmfax4tWCX0wJ764aY/VEhFYraLXIhmhPI4PVWfDKxtR0PEy8QpPA/9zQT31H/duE0nQmKW/gqdaJNSvimXvAm74p+0Y2E+t4DRbqarddaS+QlmmGv80lhJQ7cLDqjuCWFyGM7/epVN2WXJy7Ubssrjl94wfRaJZnC0cMS6cNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257221; c=relaxed/simple;
	bh=8TcDeBFEamYNbSgOJ4SdyLJNBpQfQYxaH/SAvSemDi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKcOKM9XKyz/ar/FaBPHKjBCRfBdW8hYHfDdLjsXXlZDtOMmnlX1vqv9KoFLEOp+reJqneYq20jDsoQwxuhMK/I5qLpA7IaXXdrZWx22D+ch9r23EzsluloD2gXANHzmcIjY8WzSUPBr+7MRbmRBSSXjMmf+tPjXoYys45FCbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBXl0R+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBXl0R+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC4F1F000C4;
	Sat, 17 Oct 2026 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257220;
	bh=08zU1pzbR/PGZrMd+w7tipStjMomerSBCrVsduUK3fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBXl0R+XmUbwMe248Uw9onylzmjR7aP3cn2yehQdaLVkJ8gR9FSoXOiXu+jZyNeX8
	 R/NBS7soD/aWsaTzCn+vyiPVgsSuc1N3AWzKlzNBhXzU8ohOGBVN3U/nxbJFTChEGh
	 LbaKlTLGbgaYB4Ozx7HTDmqnrD0O0wtD7ZiY7bOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=84=B1=EB=B3=91=EC=B0=AC?= <tjdqudcks0424@naver.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 0491/1674] KEYS: Fix add_key() race with keyring restriction
Date: Sat, 17 Oct 2026 17:46:03 +0200
Message-ID: <20261017160443.717912885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 성병찬 <tjdqudcks0424@naver.com>

commit dd3ea3fcba7c75493760cdbccd35f029597e8d5e upstream.

__key_create_or_update() snapshots keyring->restrict_link before taking
the destination keyring's semaphore.  keyring_restrict() installs a
restriction while holding that semaphore.

This allows a writer to observe no restriction, wait for the keyring
owner to install a reject-all restriction and return successfully, and
then link a key using the stale NULL snapshot.  The writer only needs
write permission on the destination keyring.

Move the restrict_link read after __key_link_lock() and
__key_link_begin().  The read and the subsequent restriction check are
then serialized with restriction installation by keyring->sem.

The race was reproduced on v7.2.8 in 19 executions where restriction
installation returned before the link completed.  All 19 linked the key
despite the reject-all restriction.  With this change, 312 executions
reached the same ordering and every add_key() call failed with -EPERM.

The issue was found by manual concurrency analysis assisted by AI-based
analysis and independently verified with a QEMU reproducer and kernel
instrumentation.

Fixes: 5ac7eace2d00 ("KEYS: Add a facility to restrict new links into a keyring")
Cc: stable@vger.kernel.org
Signed-off-by: 성병찬 <tjdqudcks0424@naver.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260930041802.6114-1-tjdqudcks0424@naver.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/key.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -825,9 +825,6 @@ static key_ref_t __key_create_or_update(
 
 	key_check(keyring);
 
-	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
-		restrict_link = keyring->restrict_link;
-
 	key_ref = ERR_PTR(-ENOTDIR);
 	if (keyring->type != &key_type_keyring)
 		goto error_put_type;
@@ -865,6 +862,9 @@ static key_ref_t __key_create_or_update(
 		goto error_link_end;
 	}
 
+	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
+		restrict_link = keyring->restrict_link;
+
 	if (restrict_link && restrict_link->check) {
 		ret = restrict_link->check(keyring, index_key.type,
 					   &prep.payload, restrict_link->key);


