Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C883346A6;
	Tue, 21 Jul 2026 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659304; cv=none; b=WfamjJmZq3yjty+ud8MxacGqUHYss/UIH82p05Re1uXwLQFUgF5y3oG8bq8dXImsuK3/uSFMG8v2d9Ts5E0NW+dUJroITVWUDtT6QzAR0T6f1flNjMORoxJF89DjACyNJ3+tQe0XwChKvQ1E7jfOhTgaJxBKjzb48cLmctcVhtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659304; c=relaxed/simple;
	bh=N0uo/Bhe4YLpBqI+++3wazCVzcCArrETRZOEoqLh9NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAmP1nAaDG8l/q7KA3aePc+MtW856xvG/e81G1UW3e8d54is2u6CojKMEa2HlCfE9l600uo4m1KbvgTXrijCD0gFN+lZQ38TL1g5nfxksn75WwoqiZNrc+b13im978cBb3OPY8hKRmKL0DJTT0hw59fy5QICRhGU3E1kv1Caq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2NxzHyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2NxzHyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DAE1F00A3A;
	Tue, 21 Jul 2026 18:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659303;
	bh=trGBpsLuFswNKDdsHcGg4ZY/H6Nky6Tz/zpuTFFuZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2NxzHyQCpqP/p3owQ8/MteRL4p2xvk4Tnqev3ynTDBGvhwnys+P/Nus9JMHlsAaj
	 DpvTI5TH8V4I12xlI+uG6PDDzRzm/Uy7fXfGFaWjS73bviaKGTR8JS5DgGK6kS9+RC
	 aGf25cWEVELvXueDCM0kDypK2t6smitJR0zTTE/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1469/1611] s390/diag: Add missing array_index_nospec() call to memtop_get_page_count()
Date: Tue, 21 Jul 2026 17:26:25 +0200
Message-ID: <20260721152548.488673532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit b7577fe4c47a31ca7c99714c53244a44af03cdfe upstream.

'level' is user space controlled and used to read from an array. Add the
missing array_index_nospec() call to prevent speculative execution.

Cc: stable@vger.kernel.org
Fixes: 0d30871739ab ("s390/diag: Add memory topology information via diag310")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/diag/diag310.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/diag/diag310.c
+++ b/arch/s390/kernel/diag/diag310.c
@@ -190,17 +190,18 @@ static int memtop_get_stride_len(unsigne
 static int memtop_get_page_count(unsigned long *res, unsigned long level)
 {
 	static unsigned long memtop_pages[DIAG310_LEVELMAX];
-	unsigned long pages;
+	unsigned long pages, idx;
 	int rc;
 
 	if (level > DIAG310_LEVELMAX || level < DIAG310_LEVELMIN)
 		return -EINVAL;
-	pages = READ_ONCE(memtop_pages[level - 1]);
+	idx = array_index_nospec(level - 1, ARRAY_SIZE(memtop_pages));
+	pages = READ_ONCE(memtop_pages[idx]);
 	if (!pages) {
 		rc = diag310_get_memtop_size(&pages, level);
 		if (rc)
 			return rc;
-		WRITE_ONCE(memtop_pages[level - 1], pages);
+		WRITE_ONCE(memtop_pages[idx], pages);
 	}
 	*res = pages;
 	return 0;


