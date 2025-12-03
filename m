Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ECC35BDC2;
	Wed,  3 Dec 2025 16:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778992; cv=none; b=Cgn+nVD0ZxpflSTGmff8UWU2KaurHYo7pCCznW4YNvY3K/UNvqo3VlFmyuS2ERsfNfcZyfNu9GqhWJ1aoioOt9bIuB4pBC3D7ELUmcGYi5PfTHzsnpdwwlyk/q13H9FrpHXDwbsL2ss1OfJa8fUaeSPdAWYUR+gPPBNEQEm/vkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778992; c=relaxed/simple;
	bh=QKnsd67Ed0eCUeShYgN2x+QtimtwhX57AFO15v2Nlec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlMq4T8iKuNGCnwB4Ljb7p54fle0kDtc7dnYzRd1kJa2dHyeAvRs6XlqYAk9ttdb1ufcPb2WzRJ+rqXvULdXPyl54O+yMbmiz0R+R+9NjqKCQUJxefSuU4vlrRNbu7Yuv2AIBteAcBmIVdhvhoDwCVTZqAOAzxJZ85cbr9zX4DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUrnhM1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUrnhM1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F954C4CEF5;
	Wed,  3 Dec 2025 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778991;
	bh=QKnsd67Ed0eCUeShYgN2x+QtimtwhX57AFO15v2Nlec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUrnhM1OQosBFVBpLeKUUQXtM25Mm1DFpxEScUo5s+4rMklNMKX2U8AaZYXIXZOuF
	 mlsJGvBW9F2IcvdsaJCsV7/2pFTlAc+KIIP19A7f5o2ptSCGVCL2AqcJSHfegCmNgs
	 GfupNUVEf+i9+HElHzphMY1ZiUegU+S4K3SSf8lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/568] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Wed,  3 Dec 2025 16:22:04 +0100
Message-ID: <20251203152445.200277046@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c8fc82fc27a0..29c0e7c6a6d24 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2248,6 +2248,13 @@ static void handle_swbp(struct pt_regs *regs)
 
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



