Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01054384CC3;
	Thu, 30 Jul 2026 15:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426960; cv=none; b=D9VZV0plTd9jqe8CwD4tVCn8pp5MN3YMTbLTLiOuMF+nEQwKsdozVIvNpS3bdPgPC51uO+ALp3MIUnbOAcfAPna9/Mj7eLt3wj7FP9tgq2wDmNe8+d6nVHwXkEz/Bzrr5Vqw5/Dm7xIsBo0CKda2NccpP3zrkcYJpfRiZH7p428=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426960; c=relaxed/simple;
	bh=eeJLqaI6dVvV6Hl7uIVjIWVzyPiyZ180mVgJPByX/+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbiyVL462RPXMXsOW8O0L1Q8QJTFOLif/6WDooatAi3mMQwQyzKz5WwRgwpe7Z6Qz4ivIM1YeMOM9lS7630o3qHUPdVBcALXcHk62Ht7mLLPIJZviH8SSHnxZCuzIiSi4p3lCkHsjWzXP1gYWXWrkP3Erp6iCpCpQNgLIS63nuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdhp+zoI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdhp+zoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666781F000E9;
	Thu, 30 Jul 2026 15:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426958;
	bh=VXxNnc2fhRKn5l44IlouTIC9YAh1KE0ydU7WsuNRoho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdhp+zoIcNKoNAR9uoESkoLeFOxR4jke1ToFZD9SqiUCQdJ7F1Yc+BiHNfX5MsE7q
	 J9162rvkO16rrliCn1RN3Qh8nuu/kboD/XbNDQvs/Ybz149n1lm7D5Ug2s/6TwyUkm
	 oj4udyhLeMPRLeU0hdjs0a20ZO14bbhvFMDBESXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantra <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	syzbot+41c68824eefb67cdf00c@syzkaller.appspotmail.com,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 601/602] afs: Fix uninit var in afs_alloc_anon_key()
Date: Thu, 30 Jul 2026 16:16:33 +0200
Message-ID: <20260730141448.683554378@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 19eef1d98eeda3745df35839190b7d4a4adea656 upstream.

Fix an uninitialised variable (key) in afs_alloc_anon_key() by setting it
to cell->anonymous_key.  Without this change, the error check may return a
false failure with a bad error number.

Most of the time this is unlikely to happen because the first encounter
with afs_alloc_anon_key() will usually be from (auto)mount, for which all
subsequent operations must wait - apart from other (auto)mounts.  Once the
call->anonymous_key is allocated, all further calls to afs_request_key()
will skip the call to afs_alloc_anon_key() for that cell.

Fixes: d27c71257825 ("afs: Fix delayed allocation of a cell's anonymous key")
Reported-by: Paulo Alcantra <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: syzbot+41c68824eefb67cdf00c@syzkaller.appspotmail.com
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/security.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -26,7 +26,8 @@ static int afs_alloc_anon_key(struct afs
 	struct key *key;
 
 	mutex_lock(&afs_key_lock);
-	if (!cell->anonymous_key) {
+	key = cell->anonymous_key;
+	if (!key) {
 		key = rxrpc_get_null_key(cell->key_desc);
 		if (!IS_ERR(key))
 			cell->anonymous_key = key;


