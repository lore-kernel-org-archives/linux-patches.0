Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE9B335BCB;
	Mon, 18 Aug 2025 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524471; cv=none; b=mKdINca0jRwYLh3TGHjFQGSFPVTqCgA3Fl0ZDmwUAm/Se3awqbidPG1yF2KH1w1hufd+a46Nj4WOaHYjXfJ7vcopEhJ3G3XvDu0SQTSOz1olzXst0bB4vQxpV0gtCx5L9BPKbOBWDj1G9wPSVUU1vWSv3QbrpSfnP/9qYai2bAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524471; c=relaxed/simple;
	bh=Ww8B96CE4oNz/6Up3c5VntK52MemCqumPkpupiHmc/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsvNYfjNKYrXuIxnB/MIlJkrQFBFCDYjZpnqXEQtPZ8cGEfqiHTZ5Ewa4Of91QbYLzWyUiYQW8Wl5KNu5dMHFCFCn1SFuTI8Pb/dode6sr0QHLWtg5DDVtAFnjcT+burvnE7BkI+9rshVhkrEHHW7zoP388aiaI4mJELgtrP8jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFQblKfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFQblKfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A361C4CEF1;
	Mon, 18 Aug 2025 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524471;
	bh=Ww8B96CE4oNz/6Up3c5VntK52MemCqumPkpupiHmc/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFQblKfqpLGPFjekFX6lvWGAksMcyidvukKwaLOfnfSnKaBYVPBkR8xEtqLyP2deO
	 d6qwropvs2hthoF0b7DUmMz/ZEf83gwawgDcMOgA96GefcN+DhPqBYS9zJHEOcmNHh
	 NHXMOyCz0l2dQHIgwtoZEU2iOaVFIcfQQDvagHjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 483/515] userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry
Date: Mon, 18 Aug 2025 14:47:49 +0200
Message-ID: <20250818124517.018652504@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Suren Baghdasaryan <surenb@google.com>

commit aba6faec0103ed8f169be8dce2ead41fcb689446 upstream.

When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
obtaining a folio and accessing it even though the entry is swp_entry_t.
Add the missing check and let split_huge_pmd() handle migration entries.
While at it also remove unnecessary folio check.

[surenb@google.com: remove extra folio check, per David]
  Link: https://lkml.kernel.org/r/20250807200418.1963585-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250806220022.926763-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1829,13 +1829,16 @@ ssize_t move_pages(struct userfaultfd_ct
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
+				/* Can be a migration entry */
+				if (pmd_present(*src_pmd)) {
+					struct folio *folio = pmd_folio(*src_pmd);
 
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
-					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+					if (!is_huge_zero_folio(folio) &&
+					    !PageAnonExclusive(&folio->page)) {
+						spin_unlock(ptl);
+						err = -EBUSY;
+						break;
+					}
 				}
 
 				spin_unlock(ptl);


