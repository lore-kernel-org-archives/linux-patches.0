Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A77914600A;
	Thu, 11 Apr 2024 10:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830883; cv=none; b=QPYRww75dSPnlqw5ljezCa62pYNm48ue5ot7WQo/xBkAkwPFnyjNhXXigW9EVzKzgPvbnZ+Y261eLgc1I6HRmU+854F6alN2faDeTOjcQpxheUDGlCklZJhAiXcVRRDdxteG50xrU66jYnlC7hk4vlqL13TOgHCiFrsfVCsmS50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830883; c=relaxed/simple;
	bh=ThcLjudlETkcyEkAEwfARA4f6aqI2Dja7TDkgtH3BWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DesyvXvkndkLG5IFZGzLw9vjK8ADzC76xl3Hnyyte9ItWptJNmP9qG/WLABeukr8vDJsOJUqP7JgxvmenTGFaej7wamjmDRxQIPorMokz33McvROPGQYC5L3fzAGj2+W4AwIEaL8l41U4ysQ5hLQjYxZ+XxfdR+4ldcMu51qnI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ay9FwTxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ay9FwTxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA0CC433C7;
	Thu, 11 Apr 2024 10:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830882;
	bh=ThcLjudlETkcyEkAEwfARA4f6aqI2Dja7TDkgtH3BWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ay9FwTxUbrA1bZEv+GYjbBHmmheDoJdg1w79b+u9PVqUC4kG9F08v+IplYDIXGPTj
	 ie9yQYn96hkOzEMvN1GotGgRB3gCGDUzZ4qnAm6J7Aya+wpfYDFcNrkqKdmwCwEJPO
	 5W7gSyyXmkvdbl+rzHkZpyXFBo4t8RprI+hrPjNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH 5.4 111/215] mm/memory-failure: fix an incorrect use of tail pages
Date: Thu, 11 Apr 2024 11:55:20 +0200
Message-ID: <20240411095428.243761246@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin <liushixin2@huawei.com>

When backport commit c79c5a0a00a9 to 5.4-stable, there is a mistake change.
The head page instead of tail page should be passed to try_to_unmap(),
otherwise unmap will failed as follows.

 Memory failure: 0x121c10: failed to unmap page (mapcount=1)
 Memory failure: 0x121c10: recovery action for unmapping failed page: Ignored

Fixes: 85015a96bc24 ("mm/memory-failure: check the mapcount of the precise page")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1030,7 +1030,7 @@ static bool hwpoison_user_mappings(struc
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	unmap_success = try_to_unmap(p, ttu);
+	unmap_success = try_to_unmap(hpage, ttu);
 	if (!unmap_success)
 		pr_err("Memory failure: %#lx: failed to unmap page (mapcount=%d)\n",
 		       pfn, page_mapcount(p));


