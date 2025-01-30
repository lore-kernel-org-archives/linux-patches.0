Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281421E522;
	Thu, 30 Jan 2025 14:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247216; cv=none; b=nbseT6enXvN2QEzLOplDJtoooISALimS05rwzUJr7+I2rW8fQrTevy5ZlxZUQJZgwHbR/Ot7uXNv6cRfuPFbIuHAKLuOLFx48E2aSvqr37vPqLOXmEp3t4palsNkYGP8cddb5XRb1z6ZyB1082zkAmq823FnO1gWSv9zd2/Jm9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247216; c=relaxed/simple;
	bh=dY7txAotGSk4uxRSEnoiwp8toHI6JMp/OpGmPNt3ExU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2c1gNthzVp268H7jlb7iQtK2On1HBRZGk5yQ6DwJXfpLJWNqHZoqpV+hwg2qUDRjZka7CNPpanxcB/3aA2v2vJS85NnInlEnPOmpEcU/qO3vmOd5Kbdrw2KBL1sjj0n4WO8q8Qc9mOf9g2HkcQCBIfgTC7T+pCRkwc3VXzLTdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8T7YnaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8T7YnaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C77EC4CED2;
	Thu, 30 Jan 2025 14:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247215;
	bh=dY7txAotGSk4uxRSEnoiwp8toHI6JMp/OpGmPNt3ExU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8T7YnaRFzqfPeQ5UNafd2brE/VXpBLAWL4jqBL0Ce03RSpq4MonVoewG1UzBEL8d
	 r2fCyvCru5kIFEqVFdh2nastq0Je8+eBIrOEaZllI9eVTKq8ysQ0qoZTiJPHZPR8N6
	 ReoVuSpYNJ5vqFFpRnWqQanCp/FXPYSBVmsDihAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 5.10 121/133] gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag
Date: Thu, 30 Jan 2025 15:01:50 +0100
Message-ID: <20250130140147.400840280@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


