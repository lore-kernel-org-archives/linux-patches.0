Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8581CACE3;
	Mon, 14 Oct 2024 15:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919723; cv=none; b=sCaygJNP/FcIntXtcvC6M+AXi36ajSyo48THCkkU0pIGqlgYtM1udhBtBZsrrrlsNnry3RJh2wmSC64HC3gdfG1EvoyQaKNFsHloGK0Igxi9hSWJ9pw1ZCWkqfaD/tEamlbb9VLJCd1ex4lq+2+N4GiK17f0l4xkkjAkfn2XqKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919723; c=relaxed/simple;
	bh=C/kJkLs6lvNjcUsQIJoGzImYSry0Mj9QOSnRFRmTkSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjmeePXMoqBChY9y9WLSngc+tjKE6LTxEurN/Wk/MdmShPWwVqW/uIX9XUj7x1tv/tiV8XBY9Q6FzMB/PKbIn6BqucDe0c9u3Pi0dXAZxyMeAay2JKig2ClIz+XxJHvEKSjWvXMf11HYPpuSc+Kps0vcNmlIru53ASiS4fj/rqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/adQCqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/adQCqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3274C4CEC3;
	Mon, 14 Oct 2024 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919723;
	bh=C/kJkLs6lvNjcUsQIJoGzImYSry0Mj9QOSnRFRmTkSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/adQCqPlwwILoRMcca2Zl+Qv46QVVnv8qV6QRxCh46i55q/t8ePKr3t1SbhUSzDQ
	 avf5jOdDIYCEMcXv+IvV7Kro9/KYj4Jt9pjUT4JBtWb6YwvHKE3xvVMdYLGVNH2aJI
	 CPbeKf4ZUXNlxrUCgEl7IcGaTkMUnATUE913fnBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 689/798] s390/mm: Add cond_resched() to cmm_alloc/free_pages()
Date: Mon, 14 Oct 2024 16:20:43 +0200
Message-ID: <20241014141245.140440318@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

[ Upstream commit 131b8db78558120f58c5dc745ea9655f6b854162 ]

Adding/removing large amount of pages at once to/from the CMM balloon
can result in rcu_sched stalls or workqueue lockups, because of busy
looping w/o cond_resched().

Prevent this by adding a cond_resched(). cmm_free_pages() holds a
spin_lock while looping, so it cannot be added directly to the existing
loop. Instead, introduce a wrapper function that operates on maximum 256
pages at once, and add it there.

Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/cmm.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 9141ed4c52e90..02e030ad38c5f 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -95,11 +95,12 @@ static long cmm_alloc_pages(long nr, long *counter,
 		(*counter)++;
 		spin_unlock(&cmm_lock);
 		nr--;
+		cond_resched();
 	}
 	return nr;
 }
 
-static long cmm_free_pages(long nr, long *counter, struct cmm_page_array **list)
+static long __cmm_free_pages(long nr, long *counter, struct cmm_page_array **list)
 {
 	struct cmm_page_array *pa;
 	unsigned long addr;
@@ -123,6 +124,21 @@ static long cmm_free_pages(long nr, long *counter, struct cmm_page_array **list)
 	return nr;
 }
 
+static long cmm_free_pages(long nr, long *counter, struct cmm_page_array **list)
+{
+	long inc = 0;
+
+	while (nr) {
+		inc = min(256L, nr);
+		nr -= inc;
+		inc = __cmm_free_pages(inc, counter, list);
+		if (inc)
+			break;
+		cond_resched();
+	}
+	return nr + inc;
+}
+
 static int cmm_oom_notify(struct notifier_block *self,
 			  unsigned long dummy, void *parm)
 {
-- 
2.43.0



