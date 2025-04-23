Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB67E1A23B0;
	Wed, 23 Apr 2025 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422112; cv=none; b=YNd5bPRaULGXrOaQ9Td95ERFNHJQc5XXW06/6LXGXfCwU6+/v3KcsSTvvxDs20eNiglcjC0ZMnH12JW9LMYu9bOB8XBpw3wSU5TO8wMeOkEIDOKNG6GTdTOhduLT8wVf64cjBQbYMKQve6W/J+9AGB5rRwe80mGciMkKM2DG/3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422112; c=relaxed/simple;
	bh=H2jOTV2f2pjWpO+84FpwV5FqaiuDu2/pHecGkc/U2OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h00MLVdoD4cOXn5iVxFt852YxJ4pTENF15t0hjjdzdXaFIKlgJpBDH/pu66JhA86wQjSB3UCrzeazA+f8sIzlwFuKEt6oZ3+fjn5FnoiCSgU+7nr8uYBrY63Gs5Qi9wTJv6rb9Lt2jOW1YeHc1K26T3lyVHjtH9L+PlC05esQC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRS2Ao9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRS2Ao9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F866C4CEE2;
	Wed, 23 Apr 2025 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422112;
	bh=H2jOTV2f2pjWpO+84FpwV5FqaiuDu2/pHecGkc/U2OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRS2Ao9JrWPURmdl5R+3I1eKqa/cBqPa//+rXuncgt2vjQeK2j09BwNcHufMSGksg
	 7BREFNXtcL+ZrPEAylI3uX4X2d2sJDVr4pGsNb8fWBlLyCv8h4erfz62yl35f3txFf
	 4UJ5UBfvH5fY9Uf3zL+voSaHE3mkvil0wx084KKk=
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
Subject: [PATCH 6.1 214/291] mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Wed, 23 Apr 2025 16:43:23 +0200
Message-ID: <20250423142633.131310644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1881,8 +1881,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);


