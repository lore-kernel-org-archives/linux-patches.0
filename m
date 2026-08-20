Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A7236A37A;
	Thu, 20 Aug 2026 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238698; cv=none; b=I/1AmAJrS1RP8WXbzM3KkyPHEDLikYIdW10heKOplBQ/p2zO7ngbT9EXxvY9snNT0co+qKYN+ZWH235whwCz4xdVqS8l4uIXX5qE445CmkcDkj0XOmlMA+9g/lwjl0Vg/YQDK3u/4S9iVMhBhj4o9nifo3pTcKM/No2VBYb/ggs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238698; c=relaxed/simple;
	bh=ch1S2NraGyDohQzxL+CeQwm/PVzHD1Sg0H7+72g7T0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqQ0xTjP0d1443XBcEn9NFoLHlZicpSQirw0yRxZBRUSp28fSxJE1C22DB/zZP040gi8c34JaYpb/bMfZe1aB/RT2ySqPm+QN1F9YqiIC9xa8MAm0zX8xZKvtyalJcTQ8VDjSJmzjhosdFuj/vqGTFPswfyDf8wE5fVpmzSALoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BScl5TxQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BScl5TxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571A51F000E9;
	Thu, 20 Aug 2026 15:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238696;
	bh=4OFm24nFLNvZ6NXQCk9/CEGkWM2udFrXJxdkUxtGbRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BScl5TxQyrbAJFz1KlGecE+bdEeviTDL0Qh2yQSkEYbXsbNOGnAeEnrpB+uFaB3w2
	 ZwvOf5pI5CckTR+1srIY4b3Zf0waTvqgthafLdO27M/7QoMF2qJwY70lDbKhuHeiho
	 KLn6MJx9SYmKocdJRJJVhX6/SU6W5Qpa0sHpZmGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 010/217] selinux: reject a permission value exceeding the class permission count
Date: Thu, 20 Aug 2026 16:52:58 +0200
Message-ID: <20260820145237.883346982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d14b5d0e97fccd27974fedc03b903408872907fd upstream.

perm_read() bounds a permission value by SEL_VEC_MAX but never by the
nprim of the owning class or common, which is taken verbatim from the
policy image.  security_get_permissions() then writes perms[value - 1]
into an nprim-sized kcalloc() array, so a class declaring fewer
permissions than its largest permission value drives an out-of-bounds
heap write.  The top-level symbol tables are validated this way; the
nested per-class permission table is not.

Reject a permission whose value exceeds nprim, which is already set when
perm_read() runs.  Well-formed policies are unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: tweak comment for line length]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/policydb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1168,6 +1168,9 @@ static int perm_read(struct policydb *p,
 	rc = symtab_insert(s, key, perdatum);
 	if (rc)
 		goto bad;
+	/* indexes an nprim-sized array in security_get_permissions() */
+	if (perdatum->value > s->nprim)
+		goto bad;
 
 	return 0;
 bad:


