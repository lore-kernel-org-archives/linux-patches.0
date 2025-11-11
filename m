Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3605248883;
	Tue, 11 Nov 2025 01:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823030; cv=none; b=O8/1EcU1M8u3hICa2OWNfzJld9pAYkMHkbVHmaefatrsHLn9zmimihfyEAmnkyQfgzsToqueh6I7DEWo0ci7+XzGv0RCIgWOst0v7ayTI+oOZW/qW1wUZTsLo5+l0sBsq2W81dlbZvJy5u/RDjXKWzwCO552//nxHtgJ69ChUBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823030; c=relaxed/simple;
	bh=Yr8v0oOCgSHoSaMaGIkgEjtUmfeAsZSTmDBRiu0VHkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m66VtkKXT5pRV3SMAU7LV/6KWuYb6imWcFWJ4LH6HqxhigXYFGPTFj3dHJAJ0+/4AyGRYAA8QH6rEE5vVjYlwzBfzyT98kViCe76AtpSCO6xw70lNyxE/sTRUGQGtaD/GF7K7+UKcrzWDbQFhTvf0R1ikBvugjThqr8n6qnnB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0WgpRmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0WgpRmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD30C4CEFB;
	Tue, 11 Nov 2025 01:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823030;
	bh=Yr8v0oOCgSHoSaMaGIkgEjtUmfeAsZSTmDBRiu0VHkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0WgpRmhO0rq0A1q4MSAxWiqGlIbUuPwWOgc/U324O3VzmPn7dWrJ1NFOl6n6toHP
	 vI7ZsrgRNwjdsg4WYEoP1cq/A0HVFUvOZDvfO4xW2Mg3cdGqsky/ma1tl9dt4ugIy1
	 AgyPOd8hoNRaXLTPBnrZESLCqCTt7whtFC+kzdA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/565] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Tue, 11 Nov 2025 09:40:14 +0900
Message-ID: <20251111004530.491150183@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c00981cc6fe5b..e30c4dd345f40 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2338,6 +2338,13 @@ static void handle_swbp(struct pt_regs *regs)
 
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



