Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0FF279345;
	Wed, 23 Apr 2025 15:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422323; cv=none; b=JdzmE6xbK9SiNbSBfUTijF3FkqUzF3608wH3vdvjgRKyugPl+fv/cNyqgPb/QSMtp3hYq0nEYLk1OJgKJ+LvISrwALNWSz3X/0/JFLpEQUfANXWOqpV5SrgiHQ006ax2eT8dFdSi4Y5rH4GZSDOEAJz0PFNC18nANRVwMcRtif0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422323; c=relaxed/simple;
	bh=hKL2cpoJQq5do5Y1DVzKZ0MRnT2ptu7JoGZ9XvNaFwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gele+x1LYuW2ivbPqhKqn0LaOZ4kSMUZlwW/xV0RrFvZcVKXuuJqYP7DcRjDt2NYrfKTiVHDz9jZXPRhCLBKV/2r0aGFCxJnEx85AfyGXGSnbeBIa+P0BoE2EQLRZO3zrRrwAECVjj7f0+B01Ed4NmQ2Y5Ir1qkkPYqUw6H5XpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPSUULTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPSUULTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F338C4CEE2;
	Wed, 23 Apr 2025 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422322;
	bh=hKL2cpoJQq5do5Y1DVzKZ0MRnT2ptu7JoGZ9XvNaFwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPSUULTps56Jd5fGLhjMY05l40/iP8rEjbZMCkLj7wXlb37YWL3OmE0TfDiQiKrgC
	 xmuYOAKhdPiYNlUglWSIC7v2SJE5ScF39q+sau3gLSWQw4oxLafcuU9aDcAPOfo8Ak
	 sHpoqu8gh9Dg4Lix6hxhn5DoVntqsvgFWyVolqYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	"Yanjun.Zhu" <yanjun.zhu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 320/393] mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Wed, 23 Apr 2025 16:43:36 +0200
Message-ID: <20250423142656.558126305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Baoquan He <bhe@redhat.com>

commit 8c03ebd7cdc06bd0d2fecb4d1a609ef1dbb7d0aa upstream.

Not like fault_in_readable() or fault_in_writeable(), in
fault_in_safe_writeable() local variable 'start' is increased page by page
to loop till the whole address range is handled.  However, it mistakenly
calculates the size of the handled range with 'uaddr - start'.

Fix it here.

Andreas said:

: In gfs2, fault_in_iov_iter_writeable() is used in
: gfs2_file_direct_read() and gfs2_file_read_iter(), so this potentially
: affects buffered as well as direct reads.  This bug could cause those
: gfs2 functions to spin in a loop.

Link: https://lkml.kernel.org/r/20250410035717.473207-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250410035717.473207-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Fixes: fe673d3f5bf1 ("mm: gup: make fault_in_safe_writeable() use fixup_user_fault()")
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1871,8 +1871,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);


