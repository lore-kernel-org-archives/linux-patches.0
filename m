Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B82F1E3DC8;
	Thu, 30 Jan 2025 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246862; cv=none; b=QzYP02/1qcQ7CBX6MrKmfuhYyNqsOJvEFO/X6Zpp50xJ+n/pyxUUIuvSFVpYJZgvLVgZYqcCl/Dla2aq9psBCtkkepdraFCqAQF75PdAw7yEHP98SofhgcNUAQwpTFAapVHDP6a/7GgDw9Zd1+MG/Ir5VoLrLpd3nnGr7QpG3/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246862; c=relaxed/simple;
	bh=rZJsnkTs3kn0eE/Nkc+gTi4+PwzDxfn7ubjMQuweSIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k58/paAvVxdw6NLJ5C2BPrX0sb9Pqw76SvgrWq8EcdakVjt12qcyNvnZUklBT2sifTnYnKY2ZqWjjXfLZv+zYPr8XRUeTkNWYnV6Daum2rJsC9BxXYJ5OyNpqkibzFtFo2G+wxwY5xrZ0FegVFBJxrZRTzI0Dz2O6vFU6q7jUTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqgmC00h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqgmC00h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AD6C4CED2;
	Thu, 30 Jan 2025 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246862;
	bh=rZJsnkTs3kn0eE/Nkc+gTi4+PwzDxfn7ubjMQuweSIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqgmC00hLgRlgj2Nr9i6xjngLHe7VVeY4s+WkZ3xozVZ3OJ4Jd1b04A6mQjdHKN4R
	 BXIX88g3DjGQNPFyii7pZMjOHUphG6ThSeEV80ZufDEUA+tnMRJMpT45GdBf5sGf7W
	 PuV/pFeUpUomtkZDF1pDCkArLBkC97Y3jEBue7LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 5.4 78/91] gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag
Date: Thu, 30 Jan 2025 15:01:37 +0100
Message-ID: <20250130140136.817423953@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 7c9d9223802fbed4dee1ae301661bf346964c9d2 upstream.

Truncate an inode's address space when flipping the GFS2_DIF_JDATA flag:
depending on that flag, the pages in the address space will either use
buffer heads or iomap_folio_state structs, and we cannot mix the two.

Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin <jjtan24@m.fudan.edu.cn>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -271,6 +271,7 @@ static int do_gfs2_set_flags(struct file
 		error = filemap_fdatawait(inode->i_mapping);
 		if (error)
 			goto out;
+		truncate_inode_pages(inode->i_mapping, 0);
 		if (new_flags & GFS2_DIF_JDATA)
 			gfs2_ordered_del_inode(ip);
 	}


