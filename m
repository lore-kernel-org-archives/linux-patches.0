Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0E6363C4C;
	Wed, 20 May 2026 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298941; cv=none; b=dPVBxpyAdPGiudUTGD/JiDCoNCmEKeoa3k7e/5KifMpx8PmalHQV6CX3EgCFskQarO9vDrzUd8mD/KFRVgXW9qZMY3DWlNBjAiz4vXe1PUcTaZZbvpdqGgxPTBU93KiRAsbUCjO0eIE+0WzKkwz//7r77PosQAdUqJPGeQl6INw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298941; c=relaxed/simple;
	bh=wtJMp9R/69P15EB1VyjsAk/PQVA6ZgS2gajrqTWbJbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsfMP4zWPAh7fuTpbaTjyfh9CymU6BVsqKfCxnJmTpFVxy5EYOvF2t2equOaj5vwjc536eFny05jmdtQ/Dz2Nkx3or53dQ6qNUHeU6CMJU/hSu90f6c4RqlGhL51wxv8NBw3i+Bacv8eSZrILb2JrCg0zdeNaAvbdYa/igVKlO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1qDhGvn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1qDhGvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E16C1F000E9;
	Wed, 20 May 2026 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298940;
	bh=2qcygfMToQIc94eRDESvjE72LE0BoNTBIKAnWuZ3nfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1qDhGvn3/Nnu5K4UcH4CNYZAPBI2dWULdKUkMu5CgqNlbEE6nvjC6LgMFghMLR2/
	 63Yo75gvfm9Q9DARo+9TAl3djM3yi8OyQlLu+k5ZmiNlXV5KPkzLmFF48LArHBCaok
	 8+KyNS8QlscvzXoFlcj+0LxYrQyRxFsDlLE4T1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 575/957] x86/um: fix vDSO installation
Date: Wed, 20 May 2026 18:17:38 +0200
Message-ID: <20260520162147.001076939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit d1895c15fc7d90a615bc8c455feb02acaf08ef1e ]

The generic vDSO installation logic used by 'make vdso_install' requires
that $(vdso-install-y) is defined by the top-level architecture Makefile
and that it contains a path relative to the root of the tree.
For UML neither of these is satisfied.

Move the definition of $(vdso-install-y) to a place which is included by
the arch/um/Makefile and use the full relative path.

Fixes: f1c2bb8b9964 ("um: implement a x86_64 vDSO")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20260318-um-vdso-install-v1-1-26a4ca5c4210@weissschuh.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile.um      | 2 ++
 arch/x86/um/vdso/Makefile | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
index c86cbd9cbba38..19c13afa474e9 100644
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -60,4 +60,6 @@ ELF_FORMAT := elf64-x86-64
 LINK-$(CONFIG_LD_SCRIPT_DYN_RPATH) += -Wl,-rpath,/lib64
 LINK-y += -m64
 
+vdso-install-y += arch/x86/um/vdso/vdso.so.dbg
+
 endif
diff --git a/arch/x86/um/vdso/Makefile b/arch/x86/um/vdso/Makefile
index 8a7c8b37cb6eb..7664cbedbe30f 100644
--- a/arch/x86/um/vdso/Makefile
+++ b/arch/x86/um/vdso/Makefile
@@ -3,8 +3,6 @@
 # Building vDSO images for x86.
 #
 
-vdso-install-y += vdso.so
-
 # files to link into the vdso
 vobjs-y := vdso-note.o um_vdso.o
 
-- 
2.53.0



