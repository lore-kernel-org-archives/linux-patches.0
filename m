Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6242325DCE5;
	Tue, 11 Mar 2025 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705373; cv=none; b=BmmEwYfaQ/SnIADe/rgMIPLrH5lhf3ck+GirK2rRSIkDfvQ57Gw7ZFuyhN34TeMzxoJrOzhx56HC447LR+pfE/HT8EJix/cVwU8S9KiwmW4aW3cwXzrc5ln/TORbbwZJn/gwLq+WH1KC4VoMVbRAqQY4EVr9/R5TBtquKfxsaaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705373; c=relaxed/simple;
	bh=niudUVNwYDVH9gWOYmJqm/Nqr0bws02C4JwMp0koAhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qahm1r5+96o37lJbqdYcXfj6osfSe02hfzf7f8MqHfpCCbYKghEwcyLwBoDY4yJrIfhheh2UIq6vsjWEiWWxkq8MUke+8EkYFgjuWTBVOXkkf8RDSGikL2fHy6rbrND5orbJtNJyUJzefsylcJ53InDr/mMrMRvfOtLMtUDrg74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6c2OQlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6c2OQlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC46C4CEE9;
	Tue, 11 Mar 2025 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705372;
	bh=niudUVNwYDVH9gWOYmJqm/Nqr0bws02C4JwMp0koAhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6c2OQlxgcNpw6IjCDpoJvozuo7Nm+RtFf/U4VcLHkUK5rGY88XPVMfqugp8Pg7MH
	 kK7NZuk0b/pOEClXfOxOKReTjiLtaTYNwUNwgkA6GJEVX414azfVOk0Y9NrvKDuDCP
	 gZU+oxs6zqm+XXLNanFqQuKz/yPMe+O2RzJpJ5IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 5.4 002/328] udf: Fix use of check_add_overflow() with mixed type arguments
Date: Tue, 11 Mar 2025 15:56:12 +0100
Message-ID: <20250311145714.969237020@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

Commit ebbe26fd54a9 "udf: Avoid excessive partition lengths"
introduced a use of check_add_overflow() with argument types u32,
size_t, and u32 *.

This was backported to the 5.x stable branches, where in 64-bit
configurations it results in a build error (with older compilers) or a
warning.  Before commit d219d2a9a92e "overflow: Allow mixed type
arguments", which went into Linux 6.1, mixed type arguments are not
supported.  That cannot be backported to 5.4 or 5.10 as it would raise
the minimum compiler version for these kernel versions.

Add a cast to make the argument types compatible.

Fixes: 1497a4484cdb ("udf: Avoid excessive partition lengths")
Fixes: 551966371e17 ("udf: Avoid excessive partition lengths")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1160,7 +1160,7 @@ static int udf_fill_partdesc_info(struct
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
 		/* Check whether math over bitmap won't overflow. */
 		if (check_add_overflow(map->s_partition_len,
-				       sizeof(struct spaceBitmapDesc) << 3,
+				       (u32)(sizeof(struct spaceBitmapDesc) << 3),
 				       &sum)) {
 			udf_err(sb, "Partition %d is too long (%u)\n", p_index,
 				map->s_partition_len);


