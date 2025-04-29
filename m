Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A962522B4;
	Tue, 29 Apr 2025 17:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948932; cv=none; b=tDDvI+Sn7HsTIUSQo34wLFl/Aqc4N0tcrBKoYojY0DqO91p9WRJUTMXuJo2FOWn7AYRQeHmN2+fe3Cj3Gx+aoN16y+Nbwu9hx1kcpi17wcVT50OpcmQ2OxoLpYe6+coa11ngUsmOXdJqUkguMPrBb9T1EQmERnol9VGnSPjcWgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948932; c=relaxed/simple;
	bh=Y0JcT4uLNEXD5OcvlyBeUCLvuAgODgtzWJOaqRvZiVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lV2+5IATwmL4w/QygA6OroeWpGdlADmyKi1ZaGS7Y+EF4RRrtQ4S9ycg9g2kmL24PqI5d0fvSineTd0IWo3ynp0OMhoAE4+Nl2WZQyM1Hr05/eWBJ7qauDNE8aokMpPn7UD0oW7NCCxJfrCZ0oB9q9QN2LdhOJlMYgqxPH0fTOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebxmhpt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebxmhpt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39661C4CEE3;
	Tue, 29 Apr 2025 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948932;
	bh=Y0JcT4uLNEXD5OcvlyBeUCLvuAgODgtzWJOaqRvZiVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebxmhpt5Mn/lx3MuBN0D01poV1PGo4rrYmn/Tlk4XyZlH6DDgMYgNh0+r3Blbrw1i
	 pmimDkOSrTHs7LPAW7/b4L5p3UEvEfcxTR4hWgdZwp7N6F6cSvMLPeBPot8O92ht4q
	 932H/fgCThXujzbG8kC4vsniFB8NNHIL29yTuslk=
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
Subject: [PATCH 5.15 169/373] mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Tue, 29 Apr 2025 18:40:46 +0200
Message-ID: <20250429161130.126884175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1768,8 +1768,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);


