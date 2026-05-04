Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF263DE431;
	Mon,  4 May 2026 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903352; cv=none; b=MVFi07EgZhiOr+nofRgUW8UlZAN922MNXayBP/vy8xWMx4SodEjg7Am2w043RNU4unXUcSdux298ZgqGXub4zVTBhQIdCeF2fqslTaEOzqw318yTHIWfBErBraZ9eeLiqoYx04L1yHBxHtljob2yNoG0UcKLqX1hyorUhnf/TI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903352; c=relaxed/simple;
	bh=Ku9tTrnA4cr971llWE+HMQMeB4EQvFutgZSmJ2+mmfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK7sOHRmmIZFxhshiEJRXyl6x6oU/Xtl0Wg1HIgd/33Gpsmtr6XPFqbCCCMa3idPPnZPAs/fDe9KRYqN/7e2uNYiQ8XQdP5JK2fgEmZsN0ewUX0njqX0DcFpgDTrUoNdNn6Cor6uXZR47+gNtgweXCwqK/McxisP7zhBkTuXtlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vyua7JY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vyua7JY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55514C2BCB8;
	Mon,  4 May 2026 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903351;
	bh=Ku9tTrnA4cr971llWE+HMQMeB4EQvFutgZSmJ2+mmfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vyua7JY4bhFCcAXV0k7FDMAyOkk4uvOh41CMRQaMfTslxRg9X6vw9JXQWwO6R1a0V
	 DU5hwKzWMY1WB7Op7hC7xgPSHoy7tuiw31+QkbHZ1B+3KEL3UmBWgg51sCCd5s1CWI
	 1tmwEoVED2QtZ/7QHIRGSc7wBsq5945Dm17qtCRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis M. Karpov" <komlomal@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 199/307] userfaultfd: allow registration of ranges below mmap_min_addr
Date: Mon,  4 May 2026 15:51:24 +0200
Message-ID: <20260504135150.371319056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis M. Karpov <komlomal@gmail.com>

commit 161ce69c2c89781784b945d8e281ff2da9dede9c upstream.

The current implementation of validate_range() in fs/userfaultfd.c
performs a hard check against mmap_min_addr.  This is redundant because
UFFDIO_REGISTER operates on memory ranges that must already be backed by a
VMA.

Enforcing mmap_min_addr or capability checks again in userfaultfd is
unnecessary and prevents applications like binary compilers from using
UFFD for valid memory regions mapped by application.

Remove the redundant check for mmap_min_addr.

We started using UFFD instead of the classic mprotect approach in the
binary translator to track application writes.  During development, we
encountered this bug.  The translator cannot control where the translated
application chooses to map its memory and if the app requires a
low-address area, UFFD fails, whereas mprotect would work just fine.  I
believe this is a genuine logic bug rather than an improvement, and I
would appreciate including the fix in stable.

Link: https://lore.kernel.org/20260409103345.15044-1-komlomal@gmail.com
Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1238,8 +1238,6 @@ static __always_inline int validate_unal
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (start < mmap_min_addr)
-		return -EINVAL;
 	if (start >= task_size)
 		return -EINVAL;
 	if (len > task_size - start)


