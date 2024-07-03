Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0210613B280;
	Wed,  3 Jul 2024 11:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006034; cv=none; b=kT30MgaWiWP81PCbzQSUcIA3lmqNKJBCSnA+E/oltd3Zmxy/kqjaSSI/l1hai6IvmzxcouZybVU96e1T1lC53zhNlvvSHisVrwhvICa9fziao+u3aYDSikCGnv61Ut4pq8SLg9xauZnBgkFivup65btbOpocbP1r4plo5132SkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006034; c=relaxed/simple;
	bh=tUVUW6ur5pi5Ck78zmCGGDl9bpv7rLPsAfNP7QM22q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZY8mA5CW7KUeGybkdrMPnJhNE4qSFbn31P0EsYWX5FXrtwlHus0lO/uVZvmF+0SUSZsv3zhtcmqEMjAnnaQ9UfCy9ho9l9OlWLnpgR69V6pMEgIgHI9AHGvhx2AMq+TITXyBVd3kSNuXJvuCQRRhpoFoH6dEHzahq+NtMu//Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MNFYrGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MNFYrGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BDBC2BD10;
	Wed,  3 Jul 2024 11:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006033;
	bh=tUVUW6ur5pi5Ck78zmCGGDl9bpv7rLPsAfNP7QM22q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MNFYrGI4t3Y1OBhJyGy0yaSBP++HQ8zkGE2IlZlt1grpfdiSmoC/bzoCrTjY7syt
	 fWKZLQPNqmnIdaF1Tw29btVPrH2Nj4hArtlpbQuWgfKZFCKj/6TVcuHq6FXpLyPfrC
	 yvqDWRNVuZB3CZGhFWo1yT2o6RU011wFOrtJ/UK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/356] sparc: fix old compat_sys_select()
Date: Wed,  3 Jul 2024 12:40:13 +0200
Message-ID: <20240703102923.593155419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bae6428a9fffb2023191b0723e276cf1377a7c9f ]

sparc has two identical select syscalls at numbers 93 and 230, respectively.
During the conversion to the modern syscall.tbl format, the older one of the
two broke in compat mode, and now refers to the native 64-bit syscall.

Restore the correct behavior. This has very little effect, as glibc has
been using the newer number anyway.

Fixes: 6ff645dd683a ("sparc: add system call table generation support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/syscalls/syscall.tbl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index c37764dc764d1..7925e762e7b7e 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -117,7 +117,7 @@
 90	common	dup2			sys_dup2
 91	32	setfsuid32		sys_setfsuid
 92	common	fcntl			sys_fcntl			compat_sys_fcntl
-93	common	select			sys_select
+93	common	select			sys_select			compat_sys_select
 94	32	setfsgid32		sys_setfsgid
 95	common	fsync			sys_fsync
 96	common	setpriority		sys_setpriority
-- 
2.43.0



