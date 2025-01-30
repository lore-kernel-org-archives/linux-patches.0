Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D231E6DCF;
	Thu, 30 Jan 2025 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246868; cv=none; b=iDfNJSy0dFnru6JKgSjMIgiQLSqz8t1ftJi6sQ3jdPVVyqLS5UL3UYC9bzwVrQ8fa2K9tA31zCTaXkB4RkCpaIe9GJnc1C/dvmd00gtC3lClAe1JP13ySomDJRLXae0a9ZkGqYdPf7//2aC3qfIWzoA6qUjt0HF0w0F8EQVKrC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246868; c=relaxed/simple;
	bh=aqEiMxijSkQDggqZ84uLc8hhTev68leIndFP1pC02GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8yzeGBwJTXPxW2OeSFuV5mcFTR4YFdjAhQBip5SOxuOrsQT28asmn6D7dLyJWr2ykjGSzBYu0YajzK5a16IsdeXbU4zLdWqdoP3gO1HOhb4WWsN+0cn5lWWZvxu05P+9o0QEgLI1L5TTrgTPUTjRfWx9BQsVnLeHhAcVHwPmAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0r+z3R6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0r+z3R6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8CBC4CED2;
	Thu, 30 Jan 2025 14:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246868;
	bh=aqEiMxijSkQDggqZ84uLc8hhTev68leIndFP1pC02GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0r+z3R6tBHf32zQKKHbOAyP0yIb6X11MwbLom65bQagYYczILt6jksk61euenk03e
	 zPHxOaqp/pNZZwTiPZpV2EgiuFoyLbbmQX9xCz6NwG2LWs2vpO5Qx1LCPe5WQytk8/
	 mF2ddVUg2MleIKknTUz2rPrucwQ2+6OIOs9AilgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 5.4 80/91] m68k: Add missing mmap_read_lock() to sys_cacheflush()
Date: Thu, 30 Jan 2025 15:01:39 +0100
Message-ID: <20250130140136.899327961@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Howlett <liam.howlett@oracle.com>

commit f829b4b212a315b912cb23fd10aaf30534bb5ce9 upstream.

When the superuser flushes the entire cache, the mmap_read_lock() is not
taken, but mmap_read_unlock() is called.  Add the missing
mmap_read_lock() call.

Fixes: cd2567b6850b1648 ("m68k: call find_vma with the mmap_sem held in sys_cacheflush()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20210407200032.764445-1-Liam.Howlett@Oracle.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
[ mmap_read_lock() open-coded using down_read() as was done prior to v5.8 ]
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/kernel/sys_m68k.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -388,6 +388,8 @@ sys_cacheflush (unsigned long addr, int
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
 			goto out;
+
+		down_read(&current->mm->mmap_sem);
 	} else {
 		struct vm_area_struct *vma;
 


