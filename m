Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC2D1F76BF;
	Tue,  3 Dec 2024 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242281; cv=none; b=mVIUeO/hIiL/TDaZR42hy1d7xCDmbPlw+kjknvJHuyM9GV0tbYdMlDOcImaskddW2iyKIfYRTLNg+Sixd87Vg8dH6GAAJnmNdS41QRjkAdlm+W5nbYdujNz2XyOvNXfUMAWnHw8AcEMor8tNxr6kckXxNC33ktEjN643xd5JSoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242281; c=relaxed/simple;
	bh=2El1YQMnWgR41JYs3LKSfGiXlq1pXqxi1eNGpahJVG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5RR9XXU0KM4LLMlSOu3byLmubevhijwM9xeDzVhoX+3mtrd2WT1AfH5CmotRw4IN2k4UeODPoTX0jd5XAnowAG1beh5m5KQD68zLRb84V9QA2rKEpcP9po/+YL/mPqJrXAY4YImOd9HsAGNgYWa5Gs9tzwVCbIqizYbBLixJVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGlrGKlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGlrGKlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13075C4CED6;
	Tue,  3 Dec 2024 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242278;
	bh=2El1YQMnWgR41JYs3LKSfGiXlq1pXqxi1eNGpahJVG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGlrGKlKkF62PgySUsNLTjTw5zK1zTJeeEdwFYG4ahrsZkm0ku/z+4Tjk6MLanjQY
	 BY3+csWAqmWp+22pmWd2upoSGTz0vgtHw0jJ2eyafmb7IA3+OoYdPK9VZvrQEkIbkP
	 ffma8wwqYIPLe6/USwYNsAe29m99EW7IzJrKS63g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.12 660/826] comedi: Flush partial mappings in error case
Date: Tue,  3 Dec 2024 15:46:27 +0100
Message-ID: <20241203144809.497664634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


