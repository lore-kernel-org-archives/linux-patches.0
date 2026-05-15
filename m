Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C7834DCD9;
	Fri, 15 May 2026 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860825; cv=none; b=KtXadomK/A5CZSQQ1fKzPdkA1fuQrvvN0FbFKbHBXHTLlRvTQcK487Yz0TARfJ9LMWlvCrZHURtBdSGu1Zp5snhgtongW1f6vK23w3gbQe9rQeUA/JYjJLtTPpk4zyyC9nsvV8OAnkXKmwrl39AQmZDPAKl8M04YUsx4ip3hl/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860825; c=relaxed/simple;
	bh=tHYB3h62lCHSl3co7DNbS7Gm5Rh4VA7rXcvKZdnxMA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC0Du02i+HjSHL50CyxJdQAgotp0HeYT3XGnLc7xWKOvAI71eQ27xCkumG7w2FOW+gTA7Nc0cizDROWAFgMTH+P9bfXydjbqvxr9PdCcr3je6NBjGJb2+cFHf678CtGjBr7iCmA1Nrcvx/5BqmLS9B62Dw6luUs2EqAK+dcCDfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCLancN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCLancN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45133C2BCB0;
	Fri, 15 May 2026 16:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860825;
	bh=tHYB3h62lCHSl3co7DNbS7Gm5Rh4VA7rXcvKZdnxMA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCLancN0DLeN8Z4qN0XIWk3R70598QjCxoEQM2abAh3XUPMSevikmBEhkvUEry9cN
	 ocNd4Bz+v39kPPzgVtJ2wolPQ+OuYK6cLfoEj/a62TGDmcvJkim8BwGH0EtQ4IVcPM
	 2Jiiu+9mQG8SHLHzONuOt2zhEAQvKK9PROFi2gv0=
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
Subject: [PATCH 6.6 093/474] userfaultfd: allow registration of ranges below mmap_min_addr
Date: Fri, 15 May 2026 17:43:22 +0200
Message-ID: <20260515154717.052095395@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1295,8 +1295,6 @@ static __always_inline int validate_unal
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (start < mmap_min_addr)
-		return -EINVAL;
 	if (start >= task_size)
 		return -EINVAL;
 	if (len > task_size - start)


