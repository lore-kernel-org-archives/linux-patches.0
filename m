Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A991F7577;
	Tue,  3 Dec 2024 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239579; cv=none; b=cQfQqfCj+OS5ZNraN2ISwUxdvMOcO0FCNnYdfVz1m3HpVcTOiU97DIurbGciR3pI4hucisixNCwJOuyo4tUkQwPBX+cs/jFZen+64skqarei4wAVUcrvolqlsD0DpXcTp2g6kM+xRkGrAOFJ/mrg+LRKj1YJN4Nhj9vd/SpWU6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239579; c=relaxed/simple;
	bh=Irb24CWYwuPS4Zjt1yKB1rJAKAjJAVswIA+FO7/5mGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyYkHleDxNcMlChnwjxeIEj3KCSqSRWRK9dYtR3aAgaCylO8GZd+RuUuPYtMhW7bpueUHpZ/NEq2n4ePt1BsCosNW0/QCWG1lH/eww+FAV6l5Ro/239jXMUoY3xUvmvs1B/pCjrP9GwLOgzLzilgiRWn9SENsc1NceLadFe3ROY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNnM7CIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNnM7CIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E897C4CECF;
	Tue,  3 Dec 2024 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239579;
	bh=Irb24CWYwuPS4Zjt1yKB1rJAKAjJAVswIA+FO7/5mGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNnM7CIXq8mIUKR7wUWn66NWZ6GSS5Ub4Fou61U57GtEvUrilTYZgtZhN4X8JPOQa
	 YxduUzrHe8O0N2XmcBXss8bDxJcex0QT1o8c+a2lJ1j5PGO7pVNbxZyQhU+g1mdnaC
	 GBT60uBoDUZKAtM+iGFFP8wzskGOgAjY+5uhlxvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.11 662/817] comedi: Flush partial mappings in error case
Date: Tue,  3 Dec 2024 15:43:54 +0100
Message-ID: <20241203144021.799920807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit ce8f9fb651fac95dd41f69afe54d935420b945bd upstream.

If some remap_pfn_range() calls succeeded before one failed, we still have
buffer pages mapped into the userspace page tables when we drop the buffer
reference with comedi_buf_map_put(bm). The userspace mappings are only
cleaned up later in the mmap error path.

Fix it by explicitly flushing all mappings in our VMA on the error path.

See commit 79a61cc3fc04 ("mm: avoid leaving partial pfn mappings around in
error case").

Cc: stable@vger.kernel.org
Fixes: ed9eccbe8970 ("Staging: add comedi core")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20241017-comedi-tlb-v3-1-16b82f9372ce@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -2407,6 +2407,18 @@ static int comedi_mmap(struct file *file
 
 			start += PAGE_SIZE;
 		}
+
+#ifdef CONFIG_MMU
+		/*
+		 * Leaving behind a partial mapping of a buffer we're about to
+		 * drop is unsafe, see remap_pfn_range_notrack().
+		 * We need to zap the range here ourselves instead of relying
+		 * on the automatic zapping in remap_pfn_range() because we call
+		 * remap_pfn_range() in a loop.
+		 */
+		if (retval)
+			zap_vma_ptes(vma, vma->vm_start, size);
+#endif
 	}
 
 	if (retval == 0) {


