Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49B23B47F4;
	Sat, 17 Oct 2026 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255720; cv=none; b=ljS1v62QZ6nxjaXwO9G9vT4n9oD0NIUrM3wqrFX4tvSW+T5W0s9AP2m5r1QTrxXo0x+D9FxQGtXZCV/KPAxw02VyJ085jP3AUGXAFRoOKwUCNZ7vF6gasA7+Cq7ro8QvC1CK3BvPwonDGD6niXVuKq2uxbih9XEB7Gcdwhp1zw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255720; c=relaxed/simple;
	bh=E3tZV6eD3HT1HvlpKr7dORN4haXFF6sk2RX8DdwJb9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEYPf8R4QI8X/tWCvXPBGdKZjYiMcPKI1MzgSc92jwRWDhGi86qK3mq4TUijvb5OXV8jOPA6OoRykiJKQ0z8Xms3A7/1mNQN+iwHx5K8clUkzUxd/Yyxdj9D6kU08ho5iaXdUYAdVrKC7UUb4v6+b/TjZHHOfchhvgpFs3t7EQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9hBNp5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9hBNp5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA981F000C4;
	Sat, 17 Oct 2026 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255719;
	bh=O4aN5Vai3vi+n8x4im10+PGeiANYFA689itPmvpd6w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9hBNp5gIc1jmhdWJjs9HJcv2lnZEjdEatBVjLaDbYsowa0683R96EPTd3vAPM3aB
	 fz6S6Ra7aPZaNlKRQHAIBQZtgBhxZ94qxASjILkESpcOZ0lywVQLuYF/6kedqZ6j0f
	 U8bB/09AJr8Mia1OiFvQg6bIdUm6rETw97gl558Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 868/869] s390/uv: Dont return 0 from make_hva_secure() if the operation was not successful
Date: Sat, 17 Oct 2026 18:01:49 +0200
Message-ID: <20261017160059.112719890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

commit 3ec8a8330a1aa846dffbf1d64479213366c55b54 upstream.

If s390_wiggle_split_folio() returns 0 because splitting a large folio
succeeded, we will return 0 from make_hva_secure() even though a retry
is required. Return -EAGAIN in that case.

Otherwise, we'll return 0 from gmap_make_secure(), and consequently from
unpack_one(). In kvm_s390_pv_unpack(), we assume that unpacking
succeeded and skip unpacking this page. Later on, we run into issues
and fail booting the VM.

So far, this issue was only observed with follow-up patches where we
split large pagecache XFS folios. Maybe it can also be triggered with
shmem?

We'll cleanup s390_wiggle_split_folio() a bit next, to also return 0
if no split was required.

Fixes: d8dfda5af0be ("KVM: s390: pv: fix race when making a page secure")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250516123946.1648026-2-david@redhat.com
Message-ID: <20250516123946.1648026-2-david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/uv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -393,8 +393,11 @@ int make_hva_secure(struct mm_struct *mm
 	folio_walk_end(&fw, vma);
 	mmap_read_unlock(mm);
 
-	if (rc == -E2BIG || rc == -EBUSY)
+	if (rc == -E2BIG || rc == -EBUSY) {
 		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
+		if (!rc)
+			rc = -EAGAIN;
+	}
 	folio_put(folio);
 
 	return rc;


