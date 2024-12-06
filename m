Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B405A206F1A;
	Fri,  6 Dec 2024 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498654; cv=none; b=oejlpqdZH6U4RBiNOQseBPrJ+M/5vl9V2dBBrvOO+m19ZTA8MIuYAIFklLQHN8ijwCA0dV4DRfG6jeKBPJx1+JH5tylstusuv7J/wC8XdrGl+v91P9+qFvPLYmG44vbIwH16azZFPaQJW1ab6ocwsIQevV99V4GE7w/wiq6xszg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498654; c=relaxed/simple;
	bh=JXxrAiWFViuSH0PA0qEJIwdftgzrWy2bBBHHvZUKV5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMNzOCRZRDwgR7Rji9kNnXT7ExZBkBmVFdDClIOc5Lz8ZWHBURWLMvGiwcJi1LhlupDE9xbmrk2tTI9WZ8mmoMjEF+7s1E97Y5S0ITFTD2FUZx3YDb0MxhFoyyQnUhd/Z/aoTBJKKnuHvFHjdMK4DB7+B5l3z9sP+D/GZgQni0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGrTkcoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGrTkcoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA12EC4CEDF;
	Fri,  6 Dec 2024 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498654;
	bh=JXxrAiWFViuSH0PA0qEJIwdftgzrWy2bBBHHvZUKV5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGrTkcooKICS38g1lsxTW8uDfLAJERFk3ehPJ2IRxKdZ62xbjSAlZTDS29iYl0vo3
	 auefMmwOqOVkHBn/R0Q85bgQPJ9MYL0a1xvCNvBKJ1GY1t2dfFtJgfj2If3awp2Zhw
	 NRF/CWAmoQ1ej+5gJYt1d+CQNl88tQ4ap4pvOXFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 648/676] fs/proc/kcore.c: Clear ret value in read_kcore_iter after successful iov_iter_zero
Date: Fri,  6 Dec 2024 15:37:47 +0100
Message-ID: <20241206143718.678629005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 088f294609d8f8816dc316681aef2eb61982e0da upstream.

If iov_iter_zero succeeds after failed copy_from_kernel_nofault,
we need to reset the ret value to zero otherwise it will be returned
as final return value of read_kcore_iter.

This fixes objdump -d dump over /proc/kcore for me.

Cc: stable@vger.kernel.org
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Fixes: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20241121231118.3212000-1-jolsa@kernel.org
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/kcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -599,6 +599,7 @@ static ssize_t read_kcore_iter(struct ki
 					ret = -EFAULT;
 					goto out;
 				}
+				ret = 0;
 			/*
 			 * We know the bounce buffer is safe to copy from, so
 			 * use _copy_to_iter() directly.


