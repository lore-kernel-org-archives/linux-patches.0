Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06833469E7;
	Mon, 18 Aug 2025 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525440; cv=none; b=HdnO8/D/tILZEHToAxYj3XejnzT7ZegJOUVPuuS+022qpf8Zv3Fhs0GrN9bqtAw3coYoiOepWpvhLooHM8n7cMiUsNZVtIbZXuIj113vOM+y0P9k7lwgptDCQO5FAnOrygA1X3lt5J51ybuZAftPdAnl4/Iivu7ZN0l6sV/R5YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525440; c=relaxed/simple;
	bh=w7SpEizt4FKwknpOnqsqg4BDQU5obeLh0qtA7CHLya0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcZOuag6hMq3GpX4NT0cOqytfiQkE1OEai6HZx9BAXzAmm9s9bWfJDAE7TcbvhqfzrxOFalb72JYhYL9I/Gr56c3AqbIgAJP+mYUIUJx7PXTF7gMAq9Q1Ic8lw3jGgYk0XpJ4ynzjunFT7LFVRJWCcEKWzvOJm4OZByoLl5+Kns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8b05fpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8b05fpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0F2C4CEF1;
	Mon, 18 Aug 2025 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525439;
	bh=w7SpEizt4FKwknpOnqsqg4BDQU5obeLh0qtA7CHLya0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8b05fpYf/oEKa7vt6d2jyPe+J3rb7c8pi+ltjLF2C5244WA6u0HIqvKCq45RvZe9
	 HgP+KS5QWPTMet5CNxjweq6o5SNtWeom1S9jLupEqvP4Yt+Ep4ukmxLSIr/10QyoAi
	 PvldVhhl9NoZhZgGzGmrNPi/rlX/BLGM8g81pR+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 263/570] s390/early: Copy last breaking event address to pt_regs
Date: Mon, 18 Aug 2025 14:44:10 +0200
Message-ID: <20250818124515.964066083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 7cf636c99b257c1b4b12066ab34fd5f06e8d892f ]

In case of an early crash the early program check handler also prints the
last breaking event address which is contained within the pt_regs
structure. However it is not initialized, and therefore a more or less
random value is printed in case of a crash.

Copy the last breaking event address from lowcore to pt_regs in case of an
early program check to address this. This also makes it easier to analyze
early crashes.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 54cf0923050f..9b4b5ccda323 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -154,6 +154,7 @@ void __init __do_early_pgm_check(struct pt_regs *regs)
 
 	regs->int_code = lc->pgm_int_code;
 	regs->int_parm_long = lc->trans_exc_code;
+	regs->last_break = lc->pgm_last_break;
 	ip = __rewind_psw(regs->psw, regs->int_code >> 16);
 
 	/* Monitor Event? Might be a warning */
-- 
2.39.5



