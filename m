Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4465019E802;
	Mon, 14 Oct 2024 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915866; cv=none; b=BBzqQCU5O4EsApNj7sYK8X/Es+ybQ/EbhOojDC6GKNyitYSyvGWwNiTFr5DFNoWdUew4IXHApJ01CREaYN2GicHQv0MQSE0AavJrrKlCjKGUaStR8bJXE3CKasNqSkFBzA1EBscSDX+DdXptrZM9GB1hOanEjJpBZfmEpn8Nkuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915866; c=relaxed/simple;
	bh=LC5dEXaHYJ3O7ht/kmp26PYpPne6B7xWk6C5+8YN70s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huqDmcijB7OfgullW7SV+rE1Q56A4AhIF0MautwE60f7AzxPR6P17x3YcnKNYpRpZ0VSlsoJRag14+217R9aJiDi6ZGcz35BAxI2VUc6Cj6nOuxXznkSy2akHS8Z0+vmU8F6/30LBHeEIsAGR4IJomty/e8g5dUIZdkmah8iZuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiWsWhq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiWsWhq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2778C4CEC7;
	Mon, 14 Oct 2024 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915866;
	bh=LC5dEXaHYJ3O7ht/kmp26PYpPne6B7xWk6C5+8YN70s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiWsWhq+TkM0VzORGlFC1zDARJmTntgzb6qIPI1Yjmbke9OAKe0dMH0pehmrEmHPV
	 tZ2ywZmOOfdAXbO4AM+rGBuz01Gfee0POQhTw21VJYheQz2zR7YfS35aGPqu2IT1UY
	 wcH0I9KwtQ713iJE8ahf2Nk2iwAe0RQYiq0heKOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 021/214] s390/mm: Add cond_resched() to cmm_alloc/free_pages()
Date: Mon, 14 Oct 2024 16:18:04 +0200
Message-ID: <20241014141045.820093753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 75d15bf41d97c..d01724a715d0f 100644
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



