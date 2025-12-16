Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A408D34B1BE;
	Tue, 16 Dec 2025 12:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887628; cv=none; b=bztGlBrU80Rk4a9+5j9zhpKRnmizERr0WnoweTLdVcY/Q9mlN9sy8hlhFIDbl4wttWQKZrb/08wdM9zkiOHVTF3oxeaOpBMN9w6Jtvf2pN13Pwfe7cOe9diWoat/fgNhoE9u7tai1VRqZG6lSzTc1fl7GgTEZKpcgTBt+OE/qEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887628; c=relaxed/simple;
	bh=NWaFInxXgXVDH4n1Ouh/BRGieONpq2ruUMFnT2BxhYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2WFzrd5vDDQeIUGgF2/Nx05i5u3+pa6wsvoRvTj9JYiEaB/Ti0/FEbJ8KPfmVaLg6XU6DZMrjZ/VNxpDuL9pmpF4ECQKplcfmA5KUJrq41t9BqlrOU+syVlS52cJpp7hkzaBa3x87o21nmQ83Pfr2uK5qGzWMC3d86Py9HeVPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8AIQVcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8AIQVcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C432C4CEF1;
	Tue, 16 Dec 2025 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887628;
	bh=NWaFInxXgXVDH4n1Ouh/BRGieONpq2ruUMFnT2BxhYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8AIQVcAyAs2yc68R22F40l73qSbapfXie4+23s9hHTCDcyIBEmVrLJPyqPe/ekmy
	 gSxUU7zrH9mXZY5P+cT71l49ct467BD/frNfYv/496YK+NrPW3InRnjsnqCB0DVhbc
	 wyhv0rsk1o3w1e1/R1TPFtN8lUMpYnC4owAGyg7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 290/614] kbuild: dont enable CC_CAN_LINK if the dummy program generates warnings
Date: Tue, 16 Dec 2025 12:10:57 +0100
Message-ID: <20251216111411.879366724@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit d81d9d389b9b73acd68f300c8889c7fa1acd4977 ]

It is possible that the kernel toolchain generates warnings when used
together with the system toolchain. This happens for example when the
older kernel toolchain does not handle new versions of sframe debug
information. While these warnings where ignored during the evaluation
of CC_CAN_LINK, together with CONFIG_WERROR the actual userprog build
will later fail.

Example warning:

.../x86_64-linux/13.2.0/../../../../x86_64-linux/bin/ld:
error in /lib/../lib64/crt1.o(.sframe); no .sframe will be created
collect2: error: ld returned 1 exit status

Make sure that the very simple example program does not generate
warnings already to avoid breaking the userprog compilations.

Fixes: ec4a3992bc0b ("kbuild: respect CONFIG_WERROR for linker and assembler")
Fixes: 3f0ff4cc6ffb ("kbuild: respect CONFIG_WERROR for userprogs")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20251114-kbuild-userprogs-bits-v3-1-4dee0d74d439@linutronix.de
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/cc-can-link.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/cc-can-link.sh b/scripts/cc-can-link.sh
index 6efcead319898..e67fd8d7b6841 100755
--- a/scripts/cc-can-link.sh
+++ b/scripts/cc-can-link.sh
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
-cat << "END" | $@ -x c - -o /dev/null >/dev/null 2>&1
+cat << "END" | $@ -Werror -Wl,--fatal-warnings -x c - -o /dev/null >/dev/null 2>&1
 #include <stdio.h>
 int main(void)
 {
-- 
2.51.0



