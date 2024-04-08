Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B91C129A9A;
	Mon,  8 Apr 2024 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582419; cv=none; b=pWYEdHsXOuVBaiOxovBovGyqVOEYGIgg273TgdlvKs8FqkaIqXPJicXMyQEo1j+mFe27V8SS/YZzBp2ezmfSbwARsUcLcTVlVMQL/n0fnnlZkjc63bQ+Tf/OoFaN1GakfHAszkWra/s2Vp2emc5BhManFpjiVIsLEX8qPg5H98Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582419; c=relaxed/simple;
	bh=cVCGXuC8ktMc+7DoRCNezGmjF2Hzq9FURdrIvYql9Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aZbHhvfhYtNTfTMRfaqCNNvjalkYjx97oQFfdoH6nL+8hD96QJnZ3eoqO9CZKFHE6sMdR2GPUpzL9RgVtBQ7JXMB2/Zr4qWETPXWsst/3gIsjSclFZybYiH+nklmvSZy47AngKPe++u5RA5ABrAimCkar7jA5okZ/B3ETYXqBu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmfRDRmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmfRDRmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D84C433F1;
	Mon,  8 Apr 2024 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582418;
	bh=cVCGXuC8ktMc+7DoRCNezGmjF2Hzq9FURdrIvYql9Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmfRDRmOfXM/tFRs2+61NcLLJL9IsApB/Ug8jLW4HCYq5ZmB8Gi1rJlbVaUhaYoxK
	 DBEdaVgKHf6HtWJtPlGaxBvwLa9+/PRKccWDw5boP6d92oskJZ6cRJ/djv+0tO/gWe
	 KlTGRr4DJIhs9y8WKkx+9e6kuk9V8fbgqsb52kUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20R=C3=B6sti?= <an.roesti@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/690] entry: Respect changes to system call number by trace_sys_enter()
Date: Mon,  8 Apr 2024 14:50:06 +0200
Message-ID: <20240408125404.594765008@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Rösti <an.roesti@gmail.com>

[ Upstream commit fb13b11d53875e28e7fbf0c26b288e4ea676aa9f ]

When a probe is registered at the trace_sys_enter() tracepoint, and that
probe changes the system call number, the old system call still gets
executed.  This worked correctly until commit b6ec41346103 ("core/entry:
Report syscall correctly for trace and audit"), which removed the
re-evaluation of the syscall number after the trace point.

Restore the original semantics by re-evaluating the system call number
after trace_sys_enter().

The performance impact of this re-evaluation is minimal because it only
takes place when a trace point is active, and compared to the actual trace
point overhead the read from a cache hot variable is negligible.

Fixes: b6ec41346103 ("core/entry: Report syscall correctly for trace and audit")
Signed-off-by: André Rösti <an.roesti@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240311211704.7262-1-an.roesti@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/entry/common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index e002bea6b4be3..d11d4047a0ca8 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -73,8 +73,14 @@ static long syscall_trace_enter(struct pt_regs *regs, long syscall,
 	/* Either of the above might have changed the syscall number */
 	syscall = syscall_get_nr(current, regs);
 
-	if (unlikely(work & SYSCALL_WORK_SYSCALL_TRACEPOINT))
+	if (unlikely(work & SYSCALL_WORK_SYSCALL_TRACEPOINT)) {
 		trace_sys_enter(regs, syscall);
+		/*
+		 * Probes or BPF hooks in the tracepoint may have changed the
+		 * system call number as well.
+		 */
+		syscall = syscall_get_nr(current, regs);
+	}
 
 	syscall_enter_audit(regs, syscall);
 
-- 
2.43.0



