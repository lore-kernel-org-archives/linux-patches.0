Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830A534CFC7;
	Fri, 21 Nov 2025 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732387; cv=none; b=IlaMlmOg2W/vgfmhmt4dBFeeezmY643Sb/ssW5daJkBMzUzNL7Cjw2Q//Wum6bT/TVlj/IHbm/QoQUNU3w7jdTEqI8yrFcfXd7DY6Ks+ulm+HRDghg9J/y4DlxdMxlrnBiW+6lt82Y+b77t28UIVN0bO1KZZxgtjktOS27Yrydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732387; c=relaxed/simple;
	bh=6fEvEaHN0E4F1Unj0DuChPeUXhhc50Es839cJ0eGsxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JidBDvKR2gGsCtwOqp8Can5tKERCgwUdkKx9ibjWIVBUJX/2T9lLdb5aYanl6BPgoG2/dqc7YeefFUClac8K/72hFKgs/YgOnheUzalzQMtbeBbyxQ/C5ITE0XEN7ld63miBo3x6VCnWZE174zYizJef4+oVPDvuBc5AY2SATis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwJhZQy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwJhZQy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA26C4CEF1;
	Fri, 21 Nov 2025 13:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732387;
	bh=6fEvEaHN0E4F1Unj0DuChPeUXhhc50Es839cJ0eGsxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwJhZQy+LgH8Wah8v7A2flyzz3eUgBvXKCd2L5uIDQgZri2DPPF0XYf29BIcT7zkY
	 bGw9xQwtu7y4XUfi5KGkTc+v0+7/xGyutQ/+ZW0fPBpkgmsBRu9CxUEcS3kbVidtzR
	 t70c6WDYmbXdz0Vqri90ELPOzRqPwpaEx+O/jk/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/529] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Fri, 21 Nov 2025 14:06:43 +0100
Message-ID: <20251121130234.724927482@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index a554f43d3ceb9..6304238293ae1 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2255,6 +2255,13 @@ static void handle_swbp(struct pt_regs *regs)
 
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



