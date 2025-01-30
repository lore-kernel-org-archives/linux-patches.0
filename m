Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608E2C13D;
	Thu, 30 Jan 2025 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245659; cv=none; b=jqGLuiyS3K8r8e6WOI/pvchYBfRQm3IhIm5JbMt9MtjMHIU9avf04Y8srYNogcuTVUm8wmI4JRQ2U+BabZ6Ik8Vs2AC1RdmxExWPk5r7X8krEq0sdY65DgUfAG4LqaKte3L08CuaBUqTuDzXDKrxBbBb+s3LjV60HAv+P+Av19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245659; c=relaxed/simple;
	bh=WbyHhzhP5EigAxA7upBSYemog9llXuteoZclOsdly3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvHK09k31Ps8yBkDCH9A/SsqgGnerrpPM2GglT3y2SJHcXdorvFk2GC+ZUXCDp9LmWj5rsFoFKT1Zqeoy3K0rNEVnYaJ5gpFlNoi9nFI6UC755J8eLzyoqFyTCLk43A0SdobRcAm9HXFdDcYEk/NmgoF4TKey+KIMWoJfMHA++g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shmYGXaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shmYGXaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37E3C4CED2;
	Thu, 30 Jan 2025 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245659;
	bh=WbyHhzhP5EigAxA7upBSYemog9llXuteoZclOsdly3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shmYGXaD3hyL+r4Wl+CIlxgw/TEaqsPB7sgA/f0L0ilJoHFQLbTK28wFV9ruvT8Eg
	 8n0hRlA0YgrwGItOcbNLL1UecjY4KH8HbaNKNHvEaHU605XiOKwxCQVxgdDRCZ9C9W
	 SlyArtP25ohUswQTtcb+H/T02rnTs2G2ujoz7/qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 6.12 17/40] gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag
Date: Thu, 30 Jan 2025 14:59:17 +0100
Message-ID: <20250130133500.400688715@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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
@@ -251,6 +251,7 @@ static int do_gfs2_set_flags(struct inod
 		error = filemap_fdatawait(inode->i_mapping);
 		if (error)
 			goto out;
+		truncate_inode_pages(inode->i_mapping, 0);
 		if (new_flags & GFS2_DIF_JDATA)
 			gfs2_ordered_del_inode(ip);
 	}


