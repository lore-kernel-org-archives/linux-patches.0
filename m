Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8051A1E9901;
	Thu, 30 Jan 2025 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245769; cv=none; b=sqy4ahXLpiOQzORRY7ahSF5yya+4kk8c6ij+IxGEho6WIPJwd0nXylHE2VGXdqlE/DWKDdIHrFDJ9av5VUvaSOdNkVhjzY4cVwtS0j0Y0JPFPYplq3FyTc/sLTWEN4Xm8/53JSX+Ve/mWEeGKku5F2ooUj2Ev57j8UAsOiutM/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245769; c=relaxed/simple;
	bh=fAURZL/Fn/HsnjWgxI9CqxGi4cxj9vmGDKItVMQxAjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkAPtJrYgrn3vq8P64u3l4nn0WooGKRFKC6ssa+Y1sm2JPgDUgUqoI+Oco/haJqmGjNx/j1tzhYIdB288yuJJ9jClLA/bosSRveP1w5djQhOpebG8nO7vjRkV2dUWm4gLZ6Ur6IQZ8lL6fuf2xmzIZNjRtAEqiZVtZESHlZ+Kyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=In+4LUwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="In+4LUwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEC0C4CED2;
	Thu, 30 Jan 2025 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245769;
	bh=fAURZL/Fn/HsnjWgxI9CqxGi4cxj9vmGDKItVMQxAjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=In+4LUwO8K1RSkcYXaUZFwg3h2OoRDssp1b03ugR2Y+wmw1HATqlz3W5evZGgyFUe
	 53oodximpW7cPmqdLQyQx26Vr244ZAPezm/StMJDlfWDfVsFpHMyma81ouYO3B7Xuf
	 hbp4yQ19X6FZa0pd0bHnJuxGW1c7L76/0a3CMFdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 6.6 14/43] gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag
Date: Thu, 30 Jan 2025 14:59:21 +0100
Message-ID: <20250130133459.475292847@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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


