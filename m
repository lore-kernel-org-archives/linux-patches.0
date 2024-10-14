Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCE01AA797;
	Mon, 14 Oct 2024 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916771; cv=none; b=XpLlzbVOokZwBc7oN8Og7LWgELTjhqusaYOwe6xmyL+UN6Z40Y8AVJzHFIu6BJV1zZN3sPYG29ooyN+lYErm6J6FiiQS7uJc+RQfLy9L23hnv1oLv8JYYfFVT7tUBKGSkhLBZT58gN1NTH0mko4DwJHlVZurolz0Sv4e9F4hFbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916771; c=relaxed/simple;
	bh=yNlY/0KGjbvrG24CZCrxKDPdJx3RfA8pGW2f7GtgBU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxPWtoqs3M6lleJPBpFqjvRjpkXa8P5JW2CFTZpTfMzPqU23+LCPDliR+mpmxdl7+Q796iP7F/b05+JpNbKVlv0horECKNRFe/0Wc7gsCcDkOyVWTdLN9pVKUCkoIVXEDpGB5eTxK80ZCnUpO9biYJ7uupkkuQPjxmhZHLGbpm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMTPf0BK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMTPf0BK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC03CC4CEC3;
	Mon, 14 Oct 2024 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916771;
	bh=yNlY/0KGjbvrG24CZCrxKDPdJx3RfA8pGW2f7GtgBU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMTPf0BKUwLuk3EYsSPJa0qWaaTrpUqS4TdQwLJfQoF0ZqdLj+qZ/wwq1DNGP3Fq+
	 xMvDFP7oeM/4rE9bYhH4D2j+SJ9cacpIlXM0Li5Ipp2fp7LgS4K9yEx9uDdUqz2Cho
	 zI3hLDCva5qClmdIzXhiUP/0WoW6GlBgyv6jR/Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/213] s390/mm: Add cond_resched() to cmm_alloc/free_pages()
Date: Mon, 14 Oct 2024 16:19:26 +0200
Message-ID: <20241014141045.331969903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f47515313226c..9af4d82964944 100644
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



