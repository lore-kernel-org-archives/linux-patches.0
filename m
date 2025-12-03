Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E9632D42D;
	Wed,  3 Dec 2025 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777574; cv=none; b=qPteRjcYRKcMj6cQLNaIEMnmny6Grue1IZt5coJHjCc6rohPbmfTPkLM1N7pjieAncl+aX+T8eGjf7JQd0ZTcHNOJQo246AWbzD+0IuyNhypp26/LiUuiKjt4T1McsZJk3i2e7/eeyT+1OOPcMc1RHGo1MRsIEtMuBVn3S5IRok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777574; c=relaxed/simple;
	bh=M3sX12S2DfwKyJ0ScVtOjHbbdiorVBkHeqUPSRpI1KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMphrrSPHECl7PCSL44flnpo0N5uUoOYNfLT0kYzMa2MH8MXe18McFKBbtgiVVxt2ulOh2TsRJ+FiFIgSPIFuHesxio2wpm0ktDBwI+XkNAmXdMwm/1Lo4p/6WHCezL/BQDjhOD1HNSLu9RYCoG0FFqoiFsZyV7wxwyiUEc6pRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpdiMnlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpdiMnlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25EAC4CEF5;
	Wed,  3 Dec 2025 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777574;
	bh=M3sX12S2DfwKyJ0ScVtOjHbbdiorVBkHeqUPSRpI1KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpdiMnlh5nfIkXLaF8+k8D+L2UgYwaQMUoG4ucArTnkjOJUQoASt2fzki84y2Np3H
	 u4WCJtC+vUZbB/oM3kE7GRRU1ksIJe2lDn8Kg+/3YgMIoRvfJVj7+5n7P11jCdcTaa
	 CVHVgmCILo9iGIroYJbXAWdJB5pBokjXsCR60FTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/392] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Wed,  3 Dec 2025 16:23:50 +0100
Message-ID: <20251203152417.048226672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4363264111e1297fa37aa39b0598faa19298ecca ]

If uprobe handler changes instruction pointer we still execute single
step) or emulate the original instruction and increment the (new) ip
with its length.

This makes the new instruction pointer bogus and application will
likely crash on illegal instruction execution.

If user decided to take execution elsewhere, it makes little sense
to execute the original instruction, so let's skip it.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20250916215301.664963-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b37a6bde8a915..4e6ada6a11c7e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2241,6 +2241,13 @@ static void handle_swbp(struct pt_regs *regs)
 
 	handler_chain(uprobe, regs);
 
+	/*
+	 * If user decided to take execution elsewhere, it makes little sense
+	 * to execute the original instruction, so let's skip it.
+	 */
+	if (instruction_pointer(regs) != bp_vaddr)
+		goto out;
+
 	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
 		goto out;
 
-- 
2.51.0



