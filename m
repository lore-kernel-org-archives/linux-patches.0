Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49101449B23;
	Wed, 23 Sep 2026 14:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173050; cv=none; b=OkcW9PW9Lcd9n1UM+EOhbYR8EaF6jCF3oTXAp4nG3H9XNsN0wiSwCxHBAQNtOXj2SQW+RK0T6tWDwaRaBflOKTu7qqC462AzN7iZspL8td1JkCtdjB2s9HWT7e/2t0JioJ5GfTNgjYyimC2saXreKAl8tVGd9tc38+6v6vJYh+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173050; c=relaxed/simple;
	bh=gxbl0xjmywQqK+uzIGahHSTzXFdvpzOq6j3t7OqixEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaQ48IZoWh8fjdzGY3EKheyYZnS9DB2QG7WTjN0dJ4l95+noPfBfBBOgvPv7TNHSCkhOLaSPKcKxxQG2biqwlNxyEuqMsSZDPlBj0Mv3CcMefibJcvrbzzrzltjWVcXBfTZVno8oy/IHhwdBKRgIe3bXLp/lWzwrAP3X21XJpAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMH3WQpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMH3WQpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4525C1F000FF;
	Wed, 23 Sep 2026 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173048;
	bh=sJ8SizQuSOVff2WHNhi9Wu97RdKoIyHYHnRUKdtxq1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMH3WQpH3mEx/C9CiZehWa0hzdB+aVBhm+E0vP3pniWQ66M7/6a/mUDKOxPQOsP5f
	 DK9DdVNum/jP/YTcARGweJtuzT5d/AZSD3WoQ0Nlst46C7pBfHOhG465Olr7yRjUA/
	 Gcfuvl9+Aq52gmJ7goL3zfjm8/JosKbz5ADRdeX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Ulises Mendez Martinez <umendez@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 136/438] objtool: Validate disassembler headers in libopcodes probe
Date: Wed, 23 Sep 2026 16:02:37 +0200
Message-ID: <20260923140648.302654632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulises Mendez Martinez <umendez@google.com>

[ Upstream commit 7e61560628d17ea6b1d8ee370f6d42694cff8758 ]

commit 3f2de814c059 ("objtool: Fix libopcodes linking with static libraries")
tested for libopcodes availability by linking a test snippet with a forward
declaration of disassemble_init_for_target().

However, testing symbol linkage with an extern declaration only verifies
the presence of the library (.so/.a) and bypasses checking for development
headers (binutils-dev). On systems where libopcodes is present without
development headers installed, the probe succeeds, enabling BUILD_DISAS.
Subsequent compilation of objtool then fails:

  fatal error: 'bfd.h' file not found
    113 | #include <bfd.h>

Additionally, the probe invokes $(HOSTCC) without $(HOSTCFLAGS), ignoring
any sysroot or include flags specified for the host compiler.

Fix this by including <bfd.h> and <dis-asm.h> directly in the test snippet,
passing $(HOSTCFLAGS) so host compiler options are respected, and defining
PACKAGE="objtool" to satisfy the configuration check in <bfd.h>.

Fixes: 3f2de814c059 ("objtool: Fix libopcodes linking with static libraries")
Fixes: 436326bc525d ("objtool: fix build failure due to missing libopcodes check")
Reported-by: Alice Ryhl <aliceryhl@google.com>
Assisted-by: Antigravity:Gemini-Next
Signed-off-by: Ulises Mendez Martinez <umendez@google.com>
Link: https://patch.msgid.link/20260904150710.2997558-1-umendez@google.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index a4484fd22a96d..4cc2e756af840 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -89,9 +89,11 @@ LIBOPCODES_LIBS := $(shell \
 		    "-lopcodes -lbfd" \
 		    "-lopcodes -lbfd -liberty" \
 		    "-lopcodes -lbfd -liberty -lz"; do \
-		echo 'extern void disassemble_init_for_target(void *);' \
-		     'int main(void) { disassemble_init_for_target(0); return 0; }' | \
-			$(HOSTCC) -xc - -o /dev/null $$libs 2>/dev/null && \
+		printf '%s\n' \
+		       '$(pound)include <bfd.h>' \
+		       '$(pound)include <dis-asm.h>' \
+		       'int main(void) { disassemble_init_for_target(0); return 0; }' | \
+			$(HOSTCC) $(HOSTCFLAGS) -DPACKAGE='"objtool"' -xc - -o /dev/null $$libs 2>/dev/null && \
 			echo "$$libs" && break; \
 	done)
 
-- 
2.53.0



