Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452671A706F;
	Thu, 15 Aug 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732825; cv=none; b=M9eTQSxZhmS4NvJAq6ZT+YuW+HTplZpwB2fv8OiD91iY1z3wzUko/aD3By6d2OWvQ6DYYpB9+2NsT44Wi7IMV/Imxdlhgfu4ON4D+CRxmlVBetZGiCecAA9AERhAI1RyUbK3lvJLEYtWTU5eP0+4ubAyPCu5KiJV9ViEiiyjBlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732825; c=relaxed/simple;
	bh=WLRLD5j1IPMcR5z2DtBbD3dOv8pYXs456uGiURFPc90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtaqbBtdBy44gUqZUI+oyn310eJaLpvrS6hrFNGombQzdGlGYKghvHV2v/X7fkhgpu5TBuKNoWoAauZto55BaqsdO6jX2w+TEBDwwuqvzO9tp4cc5x3Zf4WVNnUpk58iHiWbAibtoNb1/9qkgldUUVYZhD3z5qOxYtQ5SJdHdRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLcGET9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLcGET9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC941C32786;
	Thu, 15 Aug 2024 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732825;
	bh=WLRLD5j1IPMcR5z2DtBbD3dOv8pYXs456uGiURFPc90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLcGET9afhkKjnoeReFgwuabpCq8ISmqqo0IdO0Eh2tr0k4W8vuK+ZXe1eRwQShd+
	 3FiN89oxhpxjlAugAn44lblH/5zjvIOGQGvLNbFo2wn8OCIIzVT/IGbTZ5JEuztpBP
	 fgvwehBK1kmw1RXiHwK6Z8AdYuScFqTRSei5MZNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/352] kprobes: Fix to check symbol prefixes correctly
Date: Thu, 15 Aug 2024 15:26:04 +0200
Message-ID: <20240815131930.971824720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dba6541c0fc3c..c8e62458d323f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1632,8 +1632,8 @@ static bool is_cfi_preamble_symbol(unsigned long addr)
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



