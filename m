Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB6A4A2613;
	Mon, 31 Aug 2026 13:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183732; cv=none; b=hxeNOD2vik//41dL3ECS0XX56J1LbbUr+p9NEn37l+08eVjAFo8uI2rHvS3q8aHeEWpsRtWwj1AhNFEh7X0TCH6kquou8JbtGrwdTU7Z+y4vt9UvdAXrSCwBUi20w8GFbGM7JKJ91dsC9ha40Pfwj9/M9KOqQrSFqXX/3eg+c/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183732; c=relaxed/simple;
	bh=C0sR8aB0hDwpiDCs24N3m2jgcCQ3z6daLsK4EBkbKvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCvUV+qUMmTlsTyq5nYCjPLhnSaJGpfdPjLLmXkfaGYmcn0hPAKo0c984W06BrvaF909x+oa4m3AAC4zj7jzkaUIXhyeDEYQvxYzv/39clIPDjdZlXvR+kFTRIu6UhLWdiMST6s2LH0dDdHWTPHirYKOa7hYuXn+oXsHFSoDSk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO77V/5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO77V/5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A711F00A3D;
	Mon, 31 Aug 2026 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183730;
	bh=4dajARCkof38Xxb88YSHpfoF0r6h++S8Gk8StnbubjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MO77V/5lZ05KxhOfwIvPRGB5gCOOszifv2yzbyQhQEqlH+Wm7mpubpazFuePRN7ec
	 ejbmBC+CU+wwHk1jSks0d5iwfFivwWoCNxKwoA+8W1N5lb4S49dTPkj6wE63vC+cXJ
	 wzg/bTZLTfmDErtwzbnsIkEvibuxkXE6KtK8GwI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 06/76] Revert "selinux: reject a permission value exceeding the class permission count"
Date: Mon, 31 Aug 2026 15:33:38 +0200
Message-ID: <20260831133359.492648375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

This reverts commit d81bda85d95f3a2b9eb906c7a818d88645413bb4.

The stable pick applied the nprim bound after symtab_insert() because
the upstream context (the SEL_VEC_MAX check from commit 18fa21f10d00
"selinux: more strict policy parsing") does not exist in this tree.
On that error path perm_destroy() frees a key/datum pair that is
already linked into the symtab, leading to a double free when the
failed policydb is torn down.

Drop it here; it is re-applied later in this series in its upstream
form, after its strict-parsing prerequisite.

Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index e4fa4be4823f9..b788916f5ed07 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1167,9 +1167,6 @@ static int perm_read(struct policydb *p, struct symtab *s, struct policy_file *f
 	rc = symtab_insert(s, key, perdatum);
 	if (rc)
 		goto bad;
-	/* indexes an nprim-sized array in security_get_permissions() */
-	if (perdatum->value > s->nprim)
-		goto bad;
 
 	return 0;
 bad:
-- 
2.53.0



