Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB9E37B3F7;
	Thu, 20 Aug 2026 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238059; cv=none; b=Zqq00pEhN+4PxCxUm9h2853oy7KWBkJ8yjx/uCo4ngCdKOBsJfAN/4HhlJK6OxG/1FMT5GtW++rkEXXbPmyfFK4JOiYYIHlmE3exO8KEKX92isRVmdsbJ2AJwjOAZXvLPuAO2mAJqeKjcfc345WPxS0KiDKuq0ammwUyXoeDU4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238059; c=relaxed/simple;
	bh=XgG5A45h4TRYLqvPBqR6JqIOBvAx5UFDbzQ0B861uKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCX+pKSxZF70WASDueyLN+NhZJ+BY7IowhWmsgYNOGi0+7iquNQd2eeWssGxjxi+JjRoqCZ9JIVGKfBikekLzRYCqFl6TLAGDMSSEeu/gtX6XBomYXHFmUBTrcTXJmktuCm9KckFdXWpIzpuc5qI82y33jLu5U/pIBlJD8RpD5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kY5xtx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kY5xtx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DDB1F00A3D;
	Thu, 20 Aug 2026 15:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238057;
	bh=yAHvJ3tCcy5F7RXdZManS4lJfU2qndwibI1RycrQfu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kY5xtx/8UkuCSXFmIc2oLDWyGnC1q6NBBfnnomEcecjUtp7EykAtIP5bJvQovtAi
	 xQPOfX2YAgvJCCsbQjyal4bKvNFbD0HEsXXtM5tcPu0h32Ps7IVAHl2gewB+eLzwmU
	 isrpyaQQCRuohwl2VBD3aR9ACYi62SE497Xn9FfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 006/228] selinux: reject a permission value exceeding the class permission count
Date: Thu, 20 Aug 2026 16:52:28 +0200
Message-ID: <20260820145244.659570969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
@@ -1167,6 +1167,9 @@ static int perm_read(struct policydb *p,
 	rc = symtab_insert(s, key, perdatum);
 	if (rc)
 		goto bad;
+	/* indexes an nprim-sized array in security_get_permissions() */
+	if (perdatum->value > s->nprim)
+		goto bad;
 
 	return 0;
 bad:


