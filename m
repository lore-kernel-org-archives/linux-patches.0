Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEB8386C1C;
	Tue, 21 Jul 2026 20:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666088; cv=none; b=bBTSQPz68yhDs7zAIcEurjEag6Kzj7Do+ZvlQsEtAISl9CvIPLBCEcm3MfERQhVwm55TiROd6TqxCxO9Yub7sZOirwaCvXhuVjBl12THlGM6YuRa0nthlGzurcDZwHCVDQsZaH/K3XYrnIrT2uONhJ5J/6S0kxKKz34yvKHvBM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666088; c=relaxed/simple;
	bh=0n3jTfFRZgGFgxFSy9zd7hGidHsb1zILgPc+wzam7+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2U90pKxlicSutVeSWJrbcSzjGplVVuO+iKu0T0bFcZuhlrlBQp6tHAocmLatCdgUNAPfaDdMyD+YSklDiKojaYVMf5WXSWcXIbem0WzwXGHh1JDOmKtXulhFhdA6NTF1tSSi7wjR6RSHr3eg+DHdkeZBzn1Gs6XFNpWdNbS/qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1GmOWTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1GmOWTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0FC1F00A3A;
	Tue, 21 Jul 2026 20:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666087;
	bh=RYTAvdtC6OtNOGFuMF0rwj0ffnUJxrARujnoXY95nvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1GmOWTsfAxZqQy3EHgT2My28IEAESCGRJM431OwLb+vNWAmkSqX3uzoVa8G7LjXJ
	 SWe9lAXnrU0TV2pjkcas+wnjUfXQDPiq0DZDJGIVoMiIgGS+PfYkuW/lWYTFgrqn5+
	 6zTgzGKSF1m8A+owMVeuLi71/cvkiNaWp/DroUG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0548/1266] s390/process: Fix kernel thread function pointer type
Date: Tue, 21 Jul 2026 17:16:25 +0200
Message-ID: <20260721152454.129606229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2580004177248b..4055359fd54ffa 100644
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



