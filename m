Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F419514F12C;
	Tue, 10 Sep 2024 09:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962208; cv=none; b=MzJhsUIJhwisCx96vASJfOuKLZcG6jXr9MCAzmFHnftQcIAArose+iUnSoXkGXxAfEbRTQLXPgRlrcbUxOy5CAhtYsorscDb0NRSeON042uufWKaYsZqMoKpcJxwf8zeEh145O7s08Mmy3eApPxJ52+EVmiViDr4wUeMpnBaiH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962208; c=relaxed/simple;
	bh=nBi0RoEanANkVfDIYBOAcc9VwdEvxpR4+Ck8UQyhtmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSe0iKpHM+v5cxPp3Tqc1xdTsdV35+gw+f3yBbbtFirNZfzzbxL+1yLj8mZim/rlQko+UULdWcq8FlWGR5NesQjN3FtJPmp3GZvVExRCaTi8SouD312I/pWch8iWTJ9LgIlW91Mtron2g/CQA5c1+tTjJevLh5v6Rlh3v8fasoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPEn92x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPEn92x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726B5C4CEC3;
	Tue, 10 Sep 2024 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962207;
	bh=nBi0RoEanANkVfDIYBOAcc9VwdEvxpR4+Ck8UQyhtmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPEn92x2pXnL4wnhk2+7J8eDE0VMMCW3Hq7Q76f6K676e966h38osR+PwALwFBwFg
	 TJxqqFsoiUnPlySuTqSuv1Ep8VkEiHJ8Gulgi6byAXZlCguLLLN9Mq6WnaWCLkRngU
	 BW4koZAG+Gld/0nMmgpeUJkEvHLmFAwV1MouLxV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 331/375] hid: bpf: add BPF_JIT dependency
Date: Tue, 10 Sep 2024 11:32:08 +0200
Message-ID: <20240910092633.700322735@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bacc15e010fc5a235fb2020b06a29a9961b5db82 ]

The module does not do anything when the JIT is disabled, but instead
causes a warning:

In file included from include/linux/bpf_verifier.h:7,
                 from drivers/hid/bpf/hid_bpf_struct_ops.c:10:
drivers/hid/bpf/hid_bpf_struct_ops.c: In function 'hid_bpf_struct_ops_init':
include/linux/bpf.h:1853:50: error: statement with no effect [-Werror=unused-value]
 1853 | #define register_bpf_struct_ops(st_ops, type) ({ (void *)(st_ops); 0; })
      |                                                  ^~~~~~~~~~~~~~~~
drivers/hid/bpf/hid_bpf_struct_ops.c:305:16: note: in expansion of macro 'register_bpf_struct_ops'
  305 |         return register_bpf_struct_ops(&bpf_hid_bpf_ops, hid_bpf_ops);
      |                ^~~~~~~~~~~~~~~~~~~~~~~

Add a Kconfig dependency to only allow building the HID-BPF support
when a JIT is enabled.

Fixes: ebc0d8093e8c ("HID: bpf: implement HID-BPF through bpf_struct_ops")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/96a00b6f-eb81-4c67-8c4b-6b1f3f045034@app.fastmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/bpf/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/bpf/Kconfig b/drivers/hid/bpf/Kconfig
index 83214bae6768..d65482e02a6c 100644
--- a/drivers/hid/bpf/Kconfig
+++ b/drivers/hid/bpf/Kconfig
@@ -3,7 +3,7 @@ menu "HID-BPF support"
 
 config HID_BPF
 	bool "HID-BPF support"
-	depends on BPF
+	depends on BPF_JIT
 	depends on BPF_SYSCALL
 	depends on DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	help
-- 
2.43.0



