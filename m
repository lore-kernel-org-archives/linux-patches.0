Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB4F18454D;
	Mon, 12 Aug 2024 16:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479579; cv=none; b=N4jgWdV1fq7nZ8qfVs4KvcE6kjAtzKXskra857wJ0+oF4LfLMfGDKvYMrBs97vvBkOfbNxafrZi4OH2y4VMTF6FlJ9kFaOW7Ip5tgHsEw8DPMQHi7lnx5ZD2I8xCzF5ocf/c5zS2PwYYihdQf/arZKkk2/tJv5i5T5XVzkD/4WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479579; c=relaxed/simple;
	bh=ELAZvREwBpoUgH6CYSOtrf2fh/1GPV29zfHdRYVmP0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptTQ/jeoMZ7eU9JAtCKspU/nHPBGv++kp96ZhsgfJSeFcnD8wtjAXPNw3sQG+yVADQAAraj/GSeu8rJ+SwVokunld9T2tQB7sdZrZlLujMsiBz5ZSpYeL08TJs1MVaa5VC71Gnl2MG+CjuswT2198dbK3LEN9fGoOyHCkqU+Skc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtJD0mYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtJD0mYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7480EC32782;
	Mon, 12 Aug 2024 16:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479578;
	bh=ELAZvREwBpoUgH6CYSOtrf2fh/1GPV29zfHdRYVmP0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtJD0mYdklJHBY1Wt0lV5W9ainVRfBQWEuz+R5ecVEkO1nqOAG2T1HFuNHQ8Bp4KQ
	 HgvloGmbYmbGtpLostrs6U8SkHFKOJddVp+F5b2mUkWeJxa7yzdKyLLJJTFaoBHEkE
	 5/0d9AtJEhO4XyRwxClhT3t/5idY8V/IU0jO++lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/189] kprobes: Fix to check symbol prefixes correctly
Date: Mon, 12 Aug 2024 18:02:35 +0200
Message-ID: <20240812160135.953509727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 8c8acb8f26cbde665b233dd1b9bbcbb9b86822dc ]

Since str_has_prefix() takes the prefix as the 2nd argument and the string
as the first, is_cfi_preamble_symbol() always fails to check the prefix.
Fix the function parameter order so that it correctly check the prefix.

Link: https://lore.kernel.org/all/172260679559.362040.7360872132937227206.stgit@devnote2/

Fixes: de02f2ac5d8c ("kprobes: Prohibit probing on CFI preamble symbol")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index add63428c0b40..c10954bd84448 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1558,8 +1558,8 @@ static bool is_cfi_preamble_symbol(unsigned long addr)
 	if (lookup_symbol_name(addr, symbuf))
 		return false;
 
-	return str_has_prefix("__cfi_", symbuf) ||
-		str_has_prefix("__pfx_", symbuf);
+	return str_has_prefix(symbuf, "__cfi_") ||
+		str_has_prefix(symbuf, "__pfx_");
 }
 
 static int check_kprobe_address_safe(struct kprobe *p,
-- 
2.43.0



