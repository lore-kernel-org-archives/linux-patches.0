Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCDA811;
	Tue, 23 Jan 2024 01:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972136; cv=none; b=hEusK7V9tjndLg1jc9f66AOdEP/+XALUWf9vJSH4OsUsm+mT1AQStPSwWSKgNljWGFwW068RxVQGMk7GlAqjgNbYgXbdL77E0nQIGX7YcaMVkzdHs/B4kByTTsSlXeOQI4fKhQb1wx59tP0YYolX4nTlxVoxVCJ0qVQsQTsZXs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972136; c=relaxed/simple;
	bh=os+ABS+x3eGK53OQ3TQedJMZwjYh6u9F6aIbMLa6JLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlOHOCP4snDwJMTd+WiqphYf5Mnpj8kdgRYlqw0tsoTOW84TG6R1WoYd4yBMNxWUvtXEFlUOwmUqagPr2/OHCp1V1zhIhLQB0hSSG1P3KSuCSElsk1F25KKW6T2OOiqlzJwsKaq1xfi5P27LrV+kABD9nkSmKjIqDTc717SshJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwXx3yFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwXx3yFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F394C433C7;
	Tue, 23 Jan 2024 01:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972136;
	bh=os+ABS+x3eGK53OQ3TQedJMZwjYh6u9F6aIbMLa6JLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwXx3yFTR5VAoLquTsNN3jBlI63WQKPfcKXPAlle8ZlnOWICZpgOR92t1Amq/NmyX
	 hxRNaZRnNWutIMQNYqdVVvao+3yH3rTJolEXPGaS/GN/3p15eAJuTj0076gO+FdBV3
	 N9c6Z+AWbDe3sw1TRAQ/ZBdDOetwhUTIZqFLPC+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/374] powerpc: Mark .opd section read-only
Date: Mon, 22 Jan 2024 15:55:23 -0800
Message-ID: <20240122235746.942965373@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 3091f5fc5f1df7741ddf326561384e0997eca2a1 ]

.opd section contains function descriptors used to locate
functions in the kernel. If someone is able to modify a
function descriptor he will be able to run arbitrary
kernel function instead of another.

To avoid that, move .opd section inside read-only memory.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/3cd40b682fb6f75bb40947b55ca0bac20cb3f995.1634136222.git.christophe.leroy@csgroup.eu
Stable-dep-of: 1b1e38002648 ("powerpc: add crtsavres.o to always-y instead of extra-y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vmlinux.lds.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index d4531902d8c6..d8301ce7c675 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -148,6 +148,12 @@ SECTIONS
 	SOFT_MASK_TABLE(8)
 	RESTART_TABLE(8)
 
+	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
+		__start_opd = .;
+		KEEP(*(.opd))
+		__end_opd = .;
+	}
+
 	. = ALIGN(8);
 	__stf_entry_barrier_fixup : AT(ADDR(__stf_entry_barrier_fixup) - LOAD_OFFSET) {
 		__start___stf_entry_barrier_fixup = .;
@@ -346,12 +352,6 @@ SECTIONS
 		*(.branch_lt)
 	}
 
-	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
-		__start_opd = .;
-		KEEP(*(.opd))
-		__end_opd = .;
-	}
-
 	. = ALIGN(256);
 	.got : AT(ADDR(.got) - LOAD_OFFSET) {
 		__toc_start = .;
-- 
2.43.0



