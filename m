Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E4C32C8B;
	Fri,  6 Dec 2024 14:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496668; cv=none; b=NeT17mFR6qy0IikBlscJFkes2n6oomvgSn91yOAXLOK930rKURrLyLmIBlp/eHe7OsflqIKpwSZ68JHXgKUql2bB4brmUwJafISyxEv81Bgtt65bkB7ZVtwiyvMonemiWXfrETsMUR9tRCMikzVxI5+jKQuOB3Y/p6HMD1E8TTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496668; c=relaxed/simple;
	bh=60PtAAM1vASlRxycmQkEBN3F0LdVmVlPRQLXuJIE+6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxUEQhXGdvXtgtPkg+5bf2xBC8wo/6zcx5RFE0AFxloEbKnurRJB88lCPBXhlR0Cwc6ZQYdlI8rEZz9mKg8iUCiI9CGdhebsZUPjldzSN7Vk4wdTdZmjxWaO+KwSCOyM209X7WwJJddR5TCLgkOzU7HfRxjA7RQLXMjyT58FOfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiGXyxDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiGXyxDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D8C4CED1;
	Fri,  6 Dec 2024 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496667;
	bh=60PtAAM1vASlRxycmQkEBN3F0LdVmVlPRQLXuJIE+6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiGXyxDh1cJM6TnE6uu8E1tfoeh0NWwy7uYVDs/kWQuvHWWWv4iMCBXGfKlepftIS
	 YFY23+dGy4hHXVlKkg2u9drZWXe6Mkg9pPQR9xunfxeXVEOdZtmf7exv/gssV1ejF9
	 Zny1/lpRRe4M3u5qJcQ2YikvIuiZreulzEsB4ddM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/676] s390/syscalls: Avoid creation of arch/arch/ directory
Date: Fri,  6 Dec 2024 15:28:08 +0100
Message-ID: <20241206143656.055095135@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 0708967e2d56e370231fd07defa0d69f9ad125e8 ]

Building the kernel with ARCH=s390 creates a weird arch/arch/ directory.

  $ find arch/arch
  arch/arch
  arch/arch/s390
  arch/arch/s390/include
  arch/arch/s390/include/generated
  arch/arch/s390/include/generated/asm
  arch/arch/s390/include/generated/uapi
  arch/arch/s390/include/generated/uapi/asm

The root cause is 'targets' in arch/s390/kernel/syscalls/Makefile,
where the relative path is incorrect.

Strictly speaking, 'targets' was not necessary in the first place
because this Makefile uses 'filechk' instead of 'if_changed'.

However, this commit keeps it, as it will be useful when converting
'filechk' to 'if_changed' later.

Fixes: 5c75824d915e ("s390/syscalls: add Makefile to generate system call header files")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20241111134603.2063226-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/syscalls/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/syscalls/Makefile b/arch/s390/kernel/syscalls/Makefile
index fb85e797946db..2bd7756288df6 100644
--- a/arch/s390/kernel/syscalls/Makefile
+++ b/arch/s390/kernel/syscalls/Makefile
@@ -12,7 +12,7 @@ kapi-hdrs-y := $(kapi)/unistd_nr.h
 uapi-hdrs-y := $(uapi)/unistd_32.h
 uapi-hdrs-y += $(uapi)/unistd_64.h
 
-targets += $(addprefix ../../../,$(gen-y) $(kapi-hdrs-y) $(uapi-hdrs-y))
+targets += $(addprefix ../../../../,$(gen-y) $(kapi-hdrs-y) $(uapi-hdrs-y))
 
 PHONY += kapi uapi
 
-- 
2.43.0



