Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBF51A00DF;
	Thu, 15 Aug 2024 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730449; cv=none; b=DLinVY3Pm1XTC1tR0Ytyv3mQyrta4Hz/FSS7O629LSy4iwhFWHXA1fSTMGZ7Irn2+Ew/9YeFlDG2QQQyNMFCEpMEC+ovvMWes0HmdizVR9cCMKf4/GyAgPsuv2kPzWob3xw8WLsesz4dywab2Jn8QunSWzlnClXV8mdlyNc9RbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730449; c=relaxed/simple;
	bh=Zm3GFrM/RFdF3gp5azbbS0wXHgW6vBTK61JIqAD1tpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOWKNx1kNFywR1DJVpLRgPGhw6U+dfcMmthxUtlg/JT80XBzdVuqoxQAbTtnNN6Q5YiZGH9MMyNLQG3q+3q+YLTW5+piRP1w7LkHeEM0mn55x7IEi83v0Vc7xDH4qrSrb3AdGmcHH3BFvZcm4UsKki/m/KiK2Zi4HawnJGizPHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwcUe/CH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwcUe/CH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D82C4AF0D;
	Thu, 15 Aug 2024 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730449;
	bh=Zm3GFrM/RFdF3gp5azbbS0wXHgW6vBTK61JIqAD1tpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwcUe/CHKIznYU5sAM2CvCsN5U6fjVQ+G0i5qH7UAPOe1FSq19Dx7FFmgxTZO0Qt+
	 SB4VznmHU19YiBJeidOrLOLi/zNgtdPhxcLBmlFnfFRL9Q9QfOk4FuAnvY+kIFvxyA
	 1XJFM26xfu5N0Coz2QHXq28lMtOvdqDa4qEF8ebU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/484] kprobes: Fix to check symbol prefixes correctly
Date: Thu, 15 Aug 2024 15:24:30 +0200
Message-ID: <20240815131957.368656218@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 258d425b2c4a5..0d463859ad329 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1545,8 +1545,8 @@ static bool is_cfi_preamble_symbol(unsigned long addr)
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



