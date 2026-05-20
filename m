Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDA13F39F5;
	Wed, 20 May 2026 18:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300076; cv=none; b=H2KiDoCBMp1QKZd5E+pEiESyZm3Sb0XKnu0ttgCFopsrGqtu2uXhlKhzVbT9JcltFgxUV2JBXw2LVoHuM1JDtGeRAt0nC8mowivOKG93kFM4WVDRX0w/dIDWriBvDOuyuQL3EL+XYOMeo8vzp9X6uXsFs1jSzqpiWeIETGmTjlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300076; c=relaxed/simple;
	bh=g/LbxD8S4KX8XEXhsi3VNl+ZoojpdXAmI6j9NTaSA4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljIqvLeVT9S1fqGtcaDu8V3inJuqVnBHuBXDJzvDAOj0op49J3Zk6+jFw9D1E2hJ7JW48yXlbenC9QrPKT29Nl1ETUJaVhrnI4vollRXry54pIGzzIvnzgoqMXTTpfCE76eGG6h5y7AIOvkRAowypRpnF7KnYsHd1iEZW58ZJ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ/J1FFK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ/J1FFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF90F1F00893;
	Wed, 20 May 2026 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300074;
	bh=jm80kvjjXhiVq0wWOYmujx1K6or16uYYhyIs12EfLZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ/J1FFKEQaoNoOVDNv264Me3Qzz2KDKDg/0D3u/bpnYV0I+bcgQbdw0WzdWUyC/2
	 rykk7mYJfhnOWIDVlrqhks1cGzWeSeQ+0cH+8loJJB0D2Lvoc56Sqobc0qko8+bxjx
	 Wz6nv6DgWR6OCFgyMeNJ8a/CgykukD5dQzynoxLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/666] sparc/vdso: Always reject undefined references during linking
Date: Wed, 20 May 2026 18:14:01 +0200
Message-ID: <20260520162111.887984871@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 652262975db421767ada3f05b926854bbb357759 ]

Instead of using a custom script to detect and fail on undefined
references, use --no-undefined for all VDSO linker invocations.

Drop the now unused checkundef.sh script.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20250306-vdso-checkundef-v2-2-a26cc315fd73@linutronix.de
Stable-dep-of: acc4f131d5d5 ("sparc64: vdso: Link with -z noexecstack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/vdso/Makefile      |  7 +++----
 arch/sparc/vdso/checkundef.sh | 10 ----------
 2 files changed, 3 insertions(+), 14 deletions(-)
 delete mode 100644 arch/sparc/vdso/checkundef.sh

diff --git a/arch/sparc/vdso/Makefile b/arch/sparc/vdso/Makefile
index 243dbfc4609d8..c7697884975ea 100644
--- a/arch/sparc/vdso/Makefile
+++ b/arch/sparc/vdso/Makefile
@@ -22,7 +22,7 @@ targets += $(foreach x, 32 64, vdso-image-$(x).c vdso$(x).so vdso$(x).so.dbg)
 
 CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf64_sparc -soname linux-vdso.so.1 --no-undefined \
+VDSO_LDFLAGS_vdso.lds = -m elf64_sparc -soname linux-vdso.so.1 \
 			-z max-page-size=8192
 
 $(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
@@ -101,7 +101,6 @@ $(obj)/vdso32.so.dbg: FORCE \
 quiet_cmd_vdso = VDSO    $@
       cmd_vdso = $(LD) -nostdlib -o $@ \
 		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
-		       -T $(filter %.lds,$^) $(filter %.o,$^) && \
-		sh $(src)/checkundef.sh '$(OBJDUMP)' '$@'
+		       -T $(filter %.lds,$^) $(filter %.o,$^)
 
-VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 -Bsymbolic
+VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 -Bsymbolic --no-undefined
diff --git a/arch/sparc/vdso/checkundef.sh b/arch/sparc/vdso/checkundef.sh
deleted file mode 100644
index 2d85876ffc325..0000000000000
--- a/arch/sparc/vdso/checkundef.sh
+++ /dev/null
@@ -1,10 +0,0 @@
-#!/bin/sh
-objdump="$1"
-file="$2"
-$objdump -t "$file" | grep '*UUND*' | grep -v '#scratch' > /dev/null 2>&1
-if [ $? -eq 1 ]; then
-    exit 0
-else
-    echo "$file: undefined symbols found" >&2
-    exit 1
-fi
-- 
2.53.0



