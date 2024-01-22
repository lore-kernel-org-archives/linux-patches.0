Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45AA77F2F;
	Tue, 23 Jan 2024 02:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975551; cv=none; b=T4ME6VQ1pIDCPG+0rt28hJlSV9YKtuQ9NddCvv57tFDhY4NJ4ut4imGawO+n66t/a/eZZmhk9FX1D1KPeFwl1OvP/FMJkWSe7oX+SQCmxw4WU2uUqJZev4IJQB9FJgd7UGsEqSFdGJPVmtph2asfpE25HanZNRG8oVPtQ3R1yFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975551; c=relaxed/simple;
	bh=aADtaHShiJIGCPcaUSdPT93hP2gCtx3r84UKCNxQRhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5DsKQNq28ib4t8c6xOpRA76KiicEA9eFGc3UV1HehlX3sQrcEWu6XRBUBDiKi+h3MCM9KtvGAQdvCIG7nRi0UeHLW/woAe5ZRXOOXreCNVtmBROoS5Aj90RNGGxVTXlish8RzFioxbRxreUfg2YVAorVFM4G94pgrzJzdwxgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chcJlI6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chcJlI6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A941EC43390;
	Tue, 23 Jan 2024 02:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975550;
	bh=aADtaHShiJIGCPcaUSdPT93hP2gCtx3r84UKCNxQRhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chcJlI6s+iXs6KHgqqB9XSN77Et7wCSnK9H62C1kR44Bkv5nIPNK+vjhKtyONHqaG
	 xWcXzjxNR1DR7Dj6675YoZJ4Jk20BiBoWI58F6y4pD1XL+ghAYxeyDv84EFeS/Kuy5
	 w6gdo+HRwIlsMhSAm6ONFWjBLwloQrNl6NYD0RBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 502/583] apparmor: Fix ref count leak in task_kill
Date: Mon, 22 Jan 2024 15:59:13 -0800
Message-ID: <20240122235827.405352296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 2cb54a19ac7153b9a26a72098c495187f64c2276 ]

apparmor_task_kill was not putting the task_cred reference tc, or the
cred_label reference tc when dealing with a passed in cred, fix this
by using a single fn exit.

Fixes: 90c436a64a6e ("apparmor: pass cred through to audit info.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 6fdab1b5ede5..366cdfd6a7ba 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -839,7 +839,6 @@ static int apparmor_task_kill(struct task_struct *target, struct kernel_siginfo
 		cl = aa_get_newest_cred_label(cred);
 		error = aa_may_signal(cred, cl, tc, tl, sig);
 		aa_put_label(cl);
-		return error;
 	} else {
 		cl = __begin_current_label_crit_section();
 		error = aa_may_signal(current_cred(), cl, tc, tl, sig);
-- 
2.43.0



