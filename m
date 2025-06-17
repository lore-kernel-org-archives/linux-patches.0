Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D2E236457;
	Tue, 17 Jun 2025 16:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178504; cv=none; b=HrdeTbMRntGJEiu9DQB7GPp+Q+HZ3VjgZByMflq6re1eV4r43s4AiiSC3s4/RVwc/h/2nwoT/T0ox7v162nurYnFGOF0dT+5x1uLBvWGTRmc5LVXcsEgBPKmqtzAXJiHa15u1OQWt/UABGOMJnmMRmPQ+IVqSGH9iPv7ReGXKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178504; c=relaxed/simple;
	bh=AxI+Gdqrl3Sw45g7kSY/ouwpl3LONccpE9X+CaqRiIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0qMNg1YJM6FyGSHMViBm8ojtP7rUcOMqCIiEIC/bOscP5XHMmrj4jhJ3DEv1nDXFL0tc4cjl7O1YHOUZzwps6ayvfOuOcEGXqPapdtFUr8ftSmo3Zq/ZROwixUTIrVHAfQnUokYXWalm7k5AGu1Sdr5MCLF0KIOvcFTPMzqstg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV3dWALp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV3dWALp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EA8C4CEE7;
	Tue, 17 Jun 2025 16:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178504;
	bh=AxI+Gdqrl3Sw45g7kSY/ouwpl3LONccpE9X+CaqRiIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV3dWALpUrOiVedEJouqZcfCijFFhq3zUIYRdwmz8TGCxYrjJiIQzMFB/qX2LSGUn
	 mqZxnypjzTEbJOMSygyQafHBcz1Yq2t+G+qj7LLwbCKVk3UBiBIygWyQxuX9RoeFE/
	 X4mJz25mIigM2x8iwy4Rz4ky1Bi9NCfA7EeDEcO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 469/780] s390/uv: Dont return 0 from make_hva_secure() if the operation was not successful
Date: Tue, 17 Jun 2025 17:22:57 +0200
Message-ID: <20250617152510.586240918@linuxfoundation.org>
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

[ Upstream commit 3ec8a8330a1aa846dffbf1d64479213366c55b54 ]

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
Stable-dep-of: ab73b29efd36 ("s390/uv: Improve splitting of large folios that cannot be split while dirty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9a5d5be8acf41..2cc3b599c7fe3 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -393,8 +393,11 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
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
-- 
2.39.5



