Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6451DDCE;
	Tue, 16 Jul 2024 15:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145059; cv=none; b=FlPzaD7mgxa0y5IE+YvwlZrW79W65a3mmGog1WOWmyaoOQGfviAsg6DD10iv5IToKRjQC9+DOB9dMmU31ip27pAnpSgPN7Z5CSQck78E2oxmtB7bfGEmDQBg4+FYKwEzYwoYzR7Ceow+Q5SsLpiG3Pt6q+SrupGJP+TXRTFPLq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145059; c=relaxed/simple;
	bh=GRm/TN8vnbFZ1fwMxx8KrUkSIg4s1Nhe/Dj0L4QMyjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjrcEE/8sZop0ilKGXvDme6RKMfZozbivnqo/nIgOjvDnMtlSGIDN8yJ4dqTECkO3uXUfVu9JcduFPBp2iANPv+wZ2gXZi/voTHo2Nyec1EUqhL0dhZDWDqkUY9riZM61vLR+CdfaLeNK2vmrnYGNUJDaD4EOASQQjJOqQZGHfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqPBZ2tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqPBZ2tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5676C116B1;
	Tue, 16 Jul 2024 15:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145059;
	bh=GRm/TN8vnbFZ1fwMxx8KrUkSIg4s1Nhe/Dj0L4QMyjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqPBZ2tvlUaJtI6Hrhco2Z34uAWtqL/VmiCpSaw+o5ChP+d0/wpWmx5YWNYLpLsdJ
	 +q/6YWTSGCytuWmN/kJoC/4jWciQk2flOtn3fS9va5E6kIMWguWsK1ce8o4CmK7EWx
	 A/OzPmEe4t2fJR184k3kJgZ1rMHL3kITF6bf3mRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yskelg@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.9 084/143] s390/mm: Add NULL pointer check to crst_table_free() base_crst_free()
Date: Tue, 16 Jul 2024 17:31:20 +0200
Message-ID: <20240716152759.206872946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit b5efb63acf7bddaf20eacfcac654c25c446eabe8 upstream.

crst_table_free() used to work with NULL pointers before the conversion
to ptdescs.  Since crst_table_free() can be called with a NULL pointer
(error handling in crst_table_upgrade() add an explicit check.

Also add the same check to base_crst_free() for consistency reasons.

In real life this should not happen, since order two GFP_KERNEL
allocations will not fail, unless FAIL_PAGE_ALLOC is enabled and used.

Reported-by: Yunseong Kim <yskelg@gmail.com>
Fixes: 6326c26c1514 ("s390: convert various pgalloc functions to use ptdescs")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pgalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -55,6 +55,8 @@ unsigned long *crst_table_alloc(struct m
 
 void crst_table_free(struct mm_struct *mm, unsigned long *table)
 {
+	if (!table)
+		return;
 	pagetable_free(virt_to_ptdesc(table));
 }
 
@@ -262,6 +264,8 @@ static unsigned long *base_crst_alloc(un
 
 static void base_crst_free(unsigned long *table)
 {
+	if (!table)
+		return;
 	pagetable_free(virt_to_ptdesc(table));
 }
 


