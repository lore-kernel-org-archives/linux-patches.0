Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934E3183CD4;
	Mon, 12 Aug 2024 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478931; cv=none; b=i/iVqHG9KXw6pxiLFMcoDG7cLB1usaSPNjUyIxGk7szITno/o9CkRkrZMD1Uj7moAx4tgLzJVIZxLgAPUKl9XRaub+HPhEVNuqyBlGbEtbjFfiBjeHsRaH/BICogcA182HtvR9A0e+4CbY0km3pR3HbNB8cP+Ts4GWBtj78/BVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478931; c=relaxed/simple;
	bh=iN2EqlQeUPMJDUPplO+XK+zlUidWFAZYnNIunvKnSqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIstniqrwbDlkez9aWLr2IcGfFnSnhGqP8Xbd6KxpMdPpjGNiS+80FaP231pHKYHWofdj1UMQIfKH0b7JW90p5Ydq1NnnEJfwndmeMV8RAJHt9ErfDjdd7vYte44EVWQ/gOo5SZUx7id3GudfbskqTbS6awVFHXoWeKf9OTXGd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgmmu3se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgmmu3se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF2AC32782;
	Mon, 12 Aug 2024 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478931;
	bh=iN2EqlQeUPMJDUPplO+XK+zlUidWFAZYnNIunvKnSqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgmmu3seukPNQ4nlvMzZ9YAjPNjN9c6C2FxsGjoi9bDHu2af9gUllHV5QrC/OgbRC
	 QtFWZeNr2j3FMq08CCg8VH4WIiLRJWWSI2rYLHLsy8Zqr5jmtqMyHjXSTcCnSO2ZZj
	 V3yh/TDdu0VNVtH2Thfh6/8DsynnQb1nIQo4nyPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/150] kprobes: Fix to check symbol prefixes correctly
Date: Mon, 12 Aug 2024 18:02:41 +0200
Message-ID: <20240812160128.262298439@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b5ee060a2db5..4c4fc4d309b8b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1552,8 +1552,8 @@ static bool is_cfi_preamble_symbol(unsigned long addr)
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



