Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB915266B4B;
	Wed, 23 Apr 2025 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420310; cv=none; b=hmbtaaR8TBDV9bEKBTbe1gVnezliMjtH0GPe36bjPkqPnps9ny9q41CyT12YyX5LyVro1xP/6gxORP6yUaZw2sPMUXkXoAVBVojseKQ5cD3Dkw0tUTHMPnZPZwKE620zCIiDZsIgCLuSUk98BYwmMCh/El/ja+mVyQwR6sO2Ah4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420310; c=relaxed/simple;
	bh=x5PRVn07n64MUNLdznUj5gQc8nUWubvmC2QuHsYjU4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZaI01eE2S3ClSjrbzyDxtTPj0g4A286cevuRGWv6YaDC2aV1L7PjWSFvnedd3KCQDzhr3ZGIFNXdBVhsIlUU0u0Dnd6XOiNznQNzgyuJm9cIA9FFpMffpxkYQE0162yQL124qRnctDHqrZ7s5pi7iUDGrkhd2NW8DTUaEOC8yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVqGI0zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVqGI0zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7CDC4CEE2;
	Wed, 23 Apr 2025 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420310;
	bh=x5PRVn07n64MUNLdznUj5gQc8nUWubvmC2QuHsYjU4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVqGI0zzLVzwxz1qlqsPPKK/SJG7C7UjQB9PFplCMY4DME3UAeR+UbkJObBpvGZsk
	 6RPkX2v/23hU5iciNszCrK79bdMX4IPVdtx0bpJIHVDYrM/wJ2u4PtsqASfW/0Jl8p
	 mjVQncazK6xb1lJOGQMxCWTOpSEekIawalPKrIp0=
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
Subject: [PATCH 6.12 118/223] mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Wed, 23 Apr 2025 16:43:10 +0200
Message-ID: <20250423142621.918473291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2213,8 +2213,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);


