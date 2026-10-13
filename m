Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C899C3AE18C;
	Tue, 13 Oct 2026 11:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892130; cv=none; b=T1Huayx1tY6vHk9MoxKZ/VmBgasUmlJlMge9WwWwcZOvklYeRIBLTkhitb3FCsaVCoW9ZIzwjCasJxjPGSvT2IctHuoNdaan225v71pOtYWBJ+1YXMlQy9viGQ5wE4tRQV9yuZz2ClxZwP6e3Q9ka6mG7SbLEgohQK35pBRIteU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892130; c=relaxed/simple;
	bh=qEmfESYbH+piFuceYDWVJ3G+UWTT8YiDLX46ss+ddUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzbBxoZi1jlI/L1jrmqpJ/TTu/TWaNI1NOWiUlweaXVgGv/lpNBAgftGLRX6aZcb5U9nEMP6VTD4/RVzOvT2eraemcC1q59oNJBdXC6ngZ3d2DfDqf8OT0jEaX69yUiAj0S8x4m+/g9mT7bC5/n9vn48oN+OJrlwLpfZa2RvHfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrFz0aub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrFz0aub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFE51F000FF;
	Tue, 13 Oct 2026 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892129;
	bh=NqnqQhz8Pnf3KH5tsfPFp+O1ybAJnm81lVnyccRUsK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrFz0aubQyw36otWSZTsLZgqbXz3hMi2YNNgG/LAFTC8nBgiHrW2zzZqDgJnh09/h
	 Tdv47kCrXPb3NdzF3ld12AfbpouIDg5yKMJnuIQaGR+LgySASq+UKMTnk5i926fjZI
	 A8QmtGPJL64fux0L6GqQLS8TaO+G+69skCs57JzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=84=B1=EB=B3=91=EC=B0=AC?= <tjdqudcks0424@naver.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.2 068/281] KEYS: Fix add_key() race with keyring restriction
Date: Tue, 13 Oct 2026 13:36:24 +0200
Message-ID: <20261013112856.780681969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -840,9 +840,6 @@ static key_ref_t __key_create_or_update(
 
 	key_check(keyring);
 
-	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
-		restrict_link = keyring->restrict_link;
-
 	key_ref = ERR_PTR(-ENOTDIR);
 	if (keyring->type != &key_type_keyring)
 		goto error_put_type;
@@ -880,6 +877,9 @@ static key_ref_t __key_create_or_update(
 		goto error_link_end;
 	}
 
+	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
+		restrict_link = keyring->restrict_link;
+
 	if (restrict_link && restrict_link->check) {
 		ret = restrict_link->check(keyring, index_key.type,
 					   &prep.payload, restrict_link->key);


