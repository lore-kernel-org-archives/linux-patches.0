Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797CD2E6125;
	Mon,  1 Dec 2025 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588419; cv=none; b=gh6MjtEITzNEHmQeTLIGKtVHICTZLKH5RlCCDCETlVIpsojEcKOzb+MqLg0vDe/lIckoRjcDCxwctQb2GUf/b0C89vOPwBGSRXhO73a6h6V/nP7DPJnn2uINpCOAKwwbAomcR56eTrwjhcOBnxZqPSIGeQLOi4x7v6Aaje9GH7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588419; c=relaxed/simple;
	bh=Y8+LCEY/ku+ZP34FyHAEAKTYXaog6Y1b+0gJZnv6IJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4aEMOZL69VLkKchmupfSsr0YqvH6SDMtWsCXhNapTR92YWR8VW7xjflluWbF6QiUzPi6HO+5ZT4ia8yeNkGPGbferODS4qfmELqr65ZCQVEkAVbjwuhB4Wtwid0S10tb4r1FXQz0KmG7lIg3QyVC21rjlvhMslY9DZbbsuCDeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijgeE3Rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijgeE3Rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC2C4CEF1;
	Mon,  1 Dec 2025 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588419;
	bh=Y8+LCEY/ku+ZP34FyHAEAKTYXaog6Y1b+0gJZnv6IJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijgeE3RkrNc3LNtzspLYyTRJpcdk7m0QPkkJxQ+/BB+MSkgHGpY8tjSTCaoUFNtNR
	 X/Q5CW2d46ektmbvkPwwAwLkp8uTu6XM66zyADOgMYcMJVrqP5G/tnbdTszK7O3gvC
	 MAg7c9QEdN3cT3B94xY0L2s49pkUYmQF7bGFTV54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/187] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Mon,  1 Dec 2025 12:22:28 +0100
Message-ID: <20251201112242.696684094@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6285674412f25..2b809bc849dd6 100644
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



