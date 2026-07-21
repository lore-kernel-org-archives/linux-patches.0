Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13730437111;
	Tue, 21 Jul 2026 22:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671671; cv=none; b=PmcCXGFtAAAaULnokdc3kKyz+8uhX+KlNcBN7ed9ubu4p0xDseHSO5RR1/4+8OCYZ6Ejsa0bjHBGd/JsJ0fohYd3taDAuR+M1zlFeD+ag9Ow936geXB1StR81eswZDNVQ576qq3b1m+/q0gSyAokGxjCkBNB3HPzWajpHiraynY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671671; c=relaxed/simple;
	bh=oZoSR9e+BdqQjVT/CY+IhduDU4RFATfdz6G2U+qkTyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEsCkkQYXgTDzfAGTeR/xKA+5Hyn/K/Y3ZlVV0fMOlhxa+ywqyfSasJewt97dosmGsTKfhgcLcSkd5ZioGheePv5nUuZlg+HMnZtTKvBLEfwKafBobSubqCRuuIH5B3n56p9/k4+3OeqmrpOyMxX5u2OD38U1bXtFUzQhD3UfXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3vKaiXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3vKaiXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648AF1F000E9;
	Tue, 21 Jul 2026 22:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671669;
	bh=PgGr6MEOk+exTR6me24wPkDi4xthvhHLC6Y4er2xiWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3vKaiXMW3kqZpOlhjPXLbDtOZTdtaE7bc7DgNTv3f0YYdybHtFOtA6cS01AyIUuH
	 vafASKSk/T+KfOS9IDphGR9MioJLqdKyr3QzLhTGgOSK6DdQ1+KYn5ssBEN7mYZnd/
	 tyv4Ti2LcdIvEF8aSQgm5lTJqsYZQEzvD5x7PvRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 334/843] s390/process: Fix kernel thread function pointer type
Date: Tue, 21 Jul 2026 17:19:29 +0200
Message-ID: <20260721152413.533198733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit d0478f5d3cba1095bfdeb43a9b063c10cdebef14 ]

In case of a kernel thread __ret_from_fork() calls the specified function
indirectly. Fix the kernel thread function pointer, since kernel threads
return an int instead of void.

Fixes: 56e62a737028 ("s390: convert to generic entry")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 1143e46d8683a1..cb831eedbe7af7 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -48,7 +48,7 @@ void ret_from_fork(void) asm("ret_from_fork");
 
 void __ret_from_fork(struct task_struct *prev, struct pt_regs *regs)
 {
-	void (*func)(void *arg);
+	int (*func)(void *arg);
 
 	schedule_tail(prev);
 
-- 
2.53.0



