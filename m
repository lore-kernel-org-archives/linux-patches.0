Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5512BEEDE;
	Tue, 20 May 2025 14:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749665; cv=none; b=X0O6dJb8V9lylDG1SdvGYFjxVqZWRu/iNbwtZOl4RMDY6ZlP9aF4huOAM8PHLa2EsSQXkSTzuBsAJ0ly/7yCIoRDZjPVo+X8rEC8IdZS7ft5l3ARi7HVIUYmJql4mKlUslq3rwn4wdSDsi8vSiZtOe9xw/+zx/V0GPXIp+YTYYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749665; c=relaxed/simple;
	bh=YfUieMhGPQLT1eFeU2oDcujaubrlKn1Uq5n8P54pjsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1Q8DL3RYxM1cBbn0f9kADzFUGA7/tB3bbFS4Q29R/84Rw8pjwlJN0FR6DaYcoZuOyJuJTbt1xzew61EBlp6qpQhCGFPee11mgcD1iIXSQrOb5D+/I4DHl2XLWkal3XRJQBVVcDImZ17O+0YXf9RcTKrgp8UP4v+8i3TFHupgb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mw20hpj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mw20hpj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EA5C4CEE9;
	Tue, 20 May 2025 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749665;
	bh=YfUieMhGPQLT1eFeU2oDcujaubrlKn1Uq5n8P54pjsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mw20hpj4eARrlUpW5EhK2im2m2alcFQEWmynbfQXkOAWYIfNohh5iIVlQ02vGMINp
	 sPWBc7AIXsxf1ufWaz+e/YWLfZscmb0RmqsJw4cOShexYMEnVREfc5n7u7dL9D9+6h
	 a0joWij+YwYmy0omhBuJZSToPVYxd09bde6PkcMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/117] binfmt_elf: Calculate total_size earlier
Date: Tue, 20 May 2025 15:49:32 +0200
Message-ID: <20250520125804.280519130@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 2d4cf7b190bbfadd4986bf5c34da17c1a88adf8e ]

In preparation to support PT_LOAD with large p_align values on
non-PT_INTERP ET_DYN executables (i.e. "static pie"), we'll need to use
the total_size details earlier. Move this separately now to make the
next patch more readable. As total_size and load_bias are currently
calculated separately, this has no behavioral impact.

Link: https://lore.kernel.org/r/20240508173149.677910-2-keescook@chromium.org
Signed-off-by: Kees Cook <kees@kernel.org>
Stable-dep-of: 11854fe263eb ("binfmt_elf: Move brk for static PIE even if ASLR disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 52 +++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 700d93e73f6e0..58c43a572df8b 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1092,7 +1092,34 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * Header for ET_DYN binaries to calculate the
 			 * randomization (load_bias) for all the LOAD
 			 * Program Headers.
+			 */
+
+			/*
+			 * Calculate the entire size of the ELF mapping
+			 * (total_size), used for the initial mapping,
+			 * due to load_addr_set which is set to true later
+			 * once the initial mapping is performed.
+			 *
+			 * Note that this is only sensible when the LOAD
+			 * segments are contiguous (or overlapping). If
+			 * used for LOADs that are far apart, this would
+			 * cause the holes between LOADs to be mapped,
+			 * running the risk of having the mapping fail,
+			 * as it would be larger than the ELF file itself.
 			 *
+			 * As a result, only ET_DYN does this, since
+			 * some ET_EXEC (e.g. ia64) may have large virtual
+			 * memory holes between LOADs.
+			 *
+			 */
+			total_size = total_mapping_size(elf_phdata,
+							elf_ex->e_phnum);
+			if (!total_size) {
+				retval = -EINVAL;
+				goto out_free_dentry;
+			}
+
+			/*
 			 * There are effectively two types of ET_DYN
 			 * binaries: programs (i.e. PIE: ET_DYN with INTERP)
 			 * and loaders (ET_DYN without INTERP, since they
@@ -1133,31 +1160,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * is then page aligned.
 			 */
 			load_bias = ELF_PAGESTART(load_bias - vaddr);
-
-			/*
-			 * Calculate the entire size of the ELF mapping
-			 * (total_size), used for the initial mapping,
-			 * due to load_addr_set which is set to true later
-			 * once the initial mapping is performed.
-			 *
-			 * Note that this is only sensible when the LOAD
-			 * segments are contiguous (or overlapping). If
-			 * used for LOADs that are far apart, this would
-			 * cause the holes between LOADs to be mapped,
-			 * running the risk of having the mapping fail,
-			 * as it would be larger than the ELF file itself.
-			 *
-			 * As a result, only ET_DYN does this, since
-			 * some ET_EXEC (e.g. ia64) may have large virtual
-			 * memory holes between LOADs.
-			 *
-			 */
-			total_size = total_mapping_size(elf_phdata,
-							elf_ex->e_phnum);
-			if (!total_size) {
-				retval = -EINVAL;
-				goto out_free_dentry;
-			}
 		}
 
 		error = elf_load(bprm->file, load_bias + vaddr, elf_ppnt,
-- 
2.39.5



