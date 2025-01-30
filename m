Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979561E522;
	Thu, 30 Jan 2025 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247300; cv=none; b=B3fPTxbllGUDn3jaj5J3zgEODmWn1eAGRY7JaYLKWymvR60Qm8tfAFMv+13WUlL67OQXs7+Y19diiq1CFIDY1+k2twHeHiyYCxCOz+l+CwtgJAU/8xzEKdpNqWGhc422AfMLM8B/bhz8PHPGu+4AbkTjgmxpG/8rcFNepw8TcEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247300; c=relaxed/simple;
	bh=W0kOuUbum31y2JTChW65NnK2kRC/jozW4rIiOnfzvik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8FpD35ssgipd5cHkafWdzavj2K7FnjxhFkwb7/FcjbV66x0Yc8CSUTusUs0jPR4kD0GrFVJIse59GPYuPrJTxcroGBY+aaL8w3397R1PcXz/NxwnL02G1+/9BeXSsawl+BzwKGxXiy+9UTrwwOmgiG0jqKRdDQW7OB0DUQRdtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkIC+Dme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkIC+Dme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3A6C4CED2;
	Thu, 30 Jan 2025 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247300;
	bh=W0kOuUbum31y2JTChW65NnK2kRC/jozW4rIiOnfzvik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkIC+DmefKJTwHWHcPZWHQKHkbV5Dj0z5Wh3QRD0BhBcj1d2ISIWDfti448O343pr
	 194A3DNAXWJx3u0oP1es2iNgpwUXwbPQYg6SYrUk3N5Eq5Wqc1imhQskXgzsGRnMmQ
	 MBoOUToJ0JHluEAx5mz5+gHyqvysD72n6rn96Jz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 5.15 09/24] gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag
Date: Thu, 30 Jan 2025 15:02:01 +0100
Message-ID: <20250130140127.672374688@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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
@@ -257,6 +257,7 @@ static int do_gfs2_set_flags(struct inod
 		error = filemap_fdatawait(inode->i_mapping);
 		if (error)
 			goto out;
+		truncate_inode_pages(inode->i_mapping, 0);
 		if (new_flags & GFS2_DIF_JDATA)
 			gfs2_ordered_del_inode(ip);
 	}


