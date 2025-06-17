Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42483236457;
	Tue, 17 Jun 2025 16:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178510; cv=none; b=DqF8MM4yewstKJqIAyANEVUm2hTkTee8Wc3SdPucBQ0Axz5xa67S60FXqneRwJAvuvQSlSiEKLL2u4U8S3fG89j/niJYeE9CwUdV1t/8KpRC2G6eaDQknYKxGwpqvOpltULIS/gAcjwEdkxk8Plmuyp0eHdQ4Eaei+Tg0J3Mwfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178510; c=relaxed/simple;
	bh=8AJ6QxtIogRDap0XUqCspSRwLrlhqpPlyhoeVgWq9Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAvWCaD4NF2rfwPxPyJlXFwZhcKZ25OgMvMdOAh/MIWiq+f+DsIOlI7+naO7w/CHt5JAXGbXsmCZiG56rHMkeG/ZbCD1QHY/nlTWbB3wRQwl98FZlnwSCE05Bd2eO3Z0CYtaNromBfYL+WEVKWMlCsKMN4OYeb/9iqM8XB9Uto0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHpDOGC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHpDOGC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA16FC4CEE7;
	Tue, 17 Jun 2025 16:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178510;
	bh=8AJ6QxtIogRDap0XUqCspSRwLrlhqpPlyhoeVgWq9Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHpDOGC0EaQuRvU30eFkB1Sh0H3Ftrh+/YGMYwalgnIeWFPxRYIuStWwS+UwbJ1bD
	 Z3HwMWJVmK3pUmEgXadwGmTgOcBFn4VaqlXzz2E1ECjXkPadlvYsW4xPQW/17qrwQX
	 u2pQovhp58BZNLq15r8WfXnBSQyI39D7wKL2ajiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 470/780] s390/uv: Always return 0 from s390_wiggle_split_folio() if successful
Date: Tue, 17 Jun 2025 17:22:58 +0200
Message-ID: <20250617152510.629776263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit bd428b8c79ed8e8658570e70c62c0092500e2eac ]

Let's consistently return 0 if the operation was successful, and just
detect ourselves whether splitting is required -- folio_test_large() is
a cheap operation.

Update the documentation.

Should we simply always return -EAGAIN instead of 0, so we don't have
to handle it in the caller? Not sure, staring at the documentation, this
way looks a bit cleaner.

Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250516123946.1648026-3-david@redhat.com
Message-ID: <20250516123946.1648026-3-david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Stable-dep-of: ab73b29efd36 ("s390/uv: Improve splitting of large folios that cannot be split while dirty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 2cc3b599c7fe3..f6ddb2b54032e 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -324,34 +324,36 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
 }
 
 /**
- * s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split.
+ * s390_wiggle_split_folio() - try to drain extra references to a folio and
+ *			       split the folio if it is large.
  * @mm:    the mm containing the folio to work on
  * @folio: the folio
- * @split: whether to split a large folio
  *
  * Context: Must be called while holding an extra reference to the folio;
  *          the mm lock should not be held.
- * Return: 0 if the folio was split successfully;
- *         -EAGAIN if the folio was not split successfully but another attempt
- *                 can be made, or if @split was set to false;
- *         -EINVAL in case of other errors. See split_folio().
+ * Return: 0 if the operation was successful;
+ *	   -EAGAIN if splitting the large folio was not successful,
+ *		   but another attempt can be made;
+ *	   -EINVAL in case of other folio splitting errors. See split_folio().
  */
-static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
+static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 {
 	int rc;
 
 	lockdep_assert_not_held(&mm->mmap_lock);
 	folio_wait_writeback(folio);
 	lru_add_drain_all();
-	if (split) {
+
+	if (folio_test_large(folio)) {
 		folio_lock(folio);
 		rc = split_folio(folio);
 		folio_unlock(folio);
 
 		if (rc != -EBUSY)
 			return rc;
+		return -EAGAIN;
 	}
-	return -EAGAIN;
+	return 0;
 }
 
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
@@ -394,7 +396,7 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
 	mmap_read_unlock(mm);
 
 	if (rc == -E2BIG || rc == -EBUSY) {
-		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
+		rc = s390_wiggle_split_folio(mm, folio);
 		if (!rc)
 			rc = -EAGAIN;
 	}
-- 
2.39.5



