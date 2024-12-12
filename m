Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C27A223E93;
	Thu, 12 Dec 2024 16:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022710; cv=none; b=qdpuRBQZg3ZMFIjtozjlfzD2+Y2BQYv6JG9z66kuBwKgUuwjcj7pRz8q2/aycLPxA6y5dHivqLMkkWXDNa/ANDmAvPqsAcZ8kjgftDxPMMRa03JVez+9CoeuKqCgwjIairQphIm/5P5uQ0WAhKeWoqPjs6d+nIG/YcNA5RyoSSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022710; c=relaxed/simple;
	bh=kAHpfcfswwhTUVNBpzC6GRGOMIHWHOgJ8Wp27rw7z3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AR1dFkw7mXVMqg34A52dwomP7AI8xY/hDvDA3RNbpnVDtXjISQCOzx4dZZwOZd20lW7OMezC3JMD2tXkpdhgty37FWJedd5XzPweV95qaB2P/ZHVS8Ko2gA3v6zxCr0VMGtU+xD0kfmh4cS/DPfCcX41qiLe5qDorVpRipAd3lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcKzTa8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcKzTa8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8C6C4CECE;
	Thu, 12 Dec 2024 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022710;
	bh=kAHpfcfswwhTUVNBpzC6GRGOMIHWHOgJ8Wp27rw7z3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcKzTa8wLyvuf53cPwcEyYtMlbwuTypOF6qT5dH1P4Yqs5noLAKJEUrO4UNnpSC0Y
	 ophbatTVTkGMtIFMKVNf9PumLjN0TTmYRaUJ+ToTDmFDLs5V6N+RRKWuz7Ex28oJW+
	 NUkd1xXC9Ghp0qd0isqsC8zmjnnZxLsS7giUW7kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.15 314/565] comedi: Flush partial mappings in error case
Date: Thu, 12 Dec 2024 15:58:29 +0100
Message-ID: <20241212144324.019818266@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2402,6 +2402,18 @@ static int comedi_mmap(struct file *file
 
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


