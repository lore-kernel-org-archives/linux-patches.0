Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE19360EC5;
	Tue, 13 Oct 2026 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895778; cv=none; b=YqkPPpJg3AFXlB18F5e3ypCpnWgQr+CATV26BY2kCSGpa1sV3MyoaVnSbXeoeCw1v8GneJjaBXmO8TCxV0Jn8pp6y+LQpNSdHyY55nGOnQfzVI1RQoyd+CfrKVWiCO0QAIjFFfkTpSh1RPCKCICgGEmwx7uKWeGdTaqg6HGZpH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895778; c=relaxed/simple;
	bh=busEQCWeWrF58/n03+x1s9mlY1TGsjYh7dXBo9I5W04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cdhIcsaAGTKrROAwF8U2dkEupqMSiC8/+RjJX+GPTGML1lTRZiKRFWYFpcepOLSEA09XsIlR2SF6OXurHHlYmqm7WclhS+xqDr0bwFzNO7FqnUhJ+pQ3AQ3L3dAXDMA40NpMfv60DREVzcfWj7rwLROqOYJ9csewsw7CvcIKySE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nodh2h9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nodh2h9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD99F1F00893;
	Tue, 13 Oct 2026 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895776;
	bh=wAeFyiK1JQcAZMCWQhGO3rvdeArghtC4Te8uRC+M0s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nodh2h9FCJmdnbtU52HjD6Ff2BuWPJA+r1VMz1bD3WmnaiYD5XCK5rE6kjJqn0Yse
	 VVnQx4WzzYcR7lSM28UY33+9w6LcjPsvSE/AcYxE9EfJSWjw/HrxpYv/iT1mPhU2/O
	 xUPxqgp8bX9/xhrvbLcC/9DyPwHB6V8C/ffrWbqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=84=B1=EB=B3=91=EC=B0=AC?= <tjdqudcks0424@naver.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 389/497] KEYS: Fix add_key() race with keyring restriction
Date: Tue, 13 Oct 2026 13:39:16 +0200
Message-ID: <20261013112917.127668912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -839,9 +839,6 @@ static key_ref_t __key_create_or_update(
 
 	key_check(keyring);
 
-	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
-		restrict_link = keyring->restrict_link;
-
 	key_ref = ERR_PTR(-ENOTDIR);
 	if (keyring->type != &key_type_keyring)
 		goto error_put_type;
@@ -879,6 +876,9 @@ static key_ref_t __key_create_or_update(
 		goto error_link_end;
 	}
 
+	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
+		restrict_link = keyring->restrict_link;
+
 	if (restrict_link && restrict_link->check) {
 		ret = restrict_link->check(keyring, index_key.type,
 					   &prep.payload, restrict_link->key);


