Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7D91B87F8;
	Thu, 30 Jan 2025 14:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247414; cv=none; b=tu2MlWUckaTwkA73NzY3a7BwzsNPFAXfXbiN0vGUFxTTEAdijK327dAFvWWO92Lgx7japcaYYQ3GlA7YNa7YrR1Hku3vQt+VgxrIiT4jWRYieIvoZXXeLnT4F5AIRqtA2Le0Jkhxt+2h9N/9WpLfqNdJ46Kc4pqYIFMM5E28too=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247414; c=relaxed/simple;
	bh=WUSdxR8klIHhzKYWY2oadBNvmZ3S1pamPryOnQjX2dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImpHpTzgQlZmSDD6gJ/HjzDo5KS/coa2pMgGTLHrjYHwHAx0M0mSEBYeGx+jUTwNIKDDjJMGhpY7sXWHZOcRXi+SZ03umtVkJe2kmLt0PrrkztuKQWDKpV5cmJceGzLV/gDfhkOnMx8nHKc0vC4DXhsnr3cncrTxIXLPjo/9px0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThKbPDip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThKbPDip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9C2C4CED2;
	Thu, 30 Jan 2025 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247414;
	bh=WUSdxR8klIHhzKYWY2oadBNvmZ3S1pamPryOnQjX2dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThKbPDipk6sEHTov3/z9703AAa8Hal/FJ4OWRG/b1GSV7WzXhzmWVsa4nDsVe1Zsz
	 /LjNgHXE/Hf2s1YxErJiaMYOVEZuyM5R95Rqh/lkyvIQ5uQkZi5fO6t55pQxl3EP2a
	 v8NsNXjpjOKjNv7+Vswh8tCNP2qAj/g8t3gEr7n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 6.1 31/49] gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag
Date: Thu, 30 Jan 2025 15:02:07 +0100
Message-ID: <20250130140135.086970748@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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
@@ -250,6 +250,7 @@ static int do_gfs2_set_flags(struct inod
 		error = filemap_fdatawait(inode->i_mapping);
 		if (error)
 			goto out;
+		truncate_inode_pages(inode->i_mapping, 0);
 		if (new_flags & GFS2_DIF_JDATA)
 			gfs2_ordered_del_inode(ip);
 	}


