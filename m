Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3D63B4E9B;
	Tue, 21 Jul 2026 20:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667185; cv=none; b=mcnQAVl6ClRweT5ADlJYUT3TPOfgHmcGl5rzo2vKvqXtRjeInhYJPxw50wataJQxd4UmjonwiY1mnpHuSQMVtF42P7x5TIqYaPY4PPiVjoQnJnA+wQF6EhH1tsCYEP/Il6+PJPWMIT9L1pvH4rg7c7WEgFDaR9IB6xPVEGRTlic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667185; c=relaxed/simple;
	bh=Y9q9TLpgo44fNsxMKZ42gZstTWqle0AT+CazzgHamEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFryWrdkCYOw2rPgGjUPUwxlWPeHlQH/A9vnYwQA7v6T++kPUU01fHI0PawE3geZkBnQEJJ+Yjtlyo0zPLesUYOk2995y4eEjD9H80eBiNRpIsaA0KmV+ZA59BL5HJpwZTjZqJZ+ROXyxNudwoF/4X2bRzubHbFz2OQ9XrkN80A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sln367uc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sln367uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CCF1F000E9;
	Tue, 21 Jul 2026 20:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667183;
	bh=NH5hKyoFyubvVC3BgT87/d+0UtznOcW+/w8cjwiLtKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sln367ucpdZkN/5Rn0u/tkGpC5HuXUQ6Gp5wqKwnvszhe5N+MF0Q0NMCpOWc0Nimn
	 FGScYfS6ge1uR8kz+j481n8ZIBgJMm7kv2wl7BwDwANHQ3OMad5H6wGMIChvH9mb9R
	 xTKNkn7SN17OgunbSe9Q6GHWaLE9D8WsKh2W4qA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 6.6 0963/1266] nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
Date: Tue, 21 Jul 2026 17:23:20 +0200
Message-ID: <20260721152503.380059773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 13fe4cd9ddd0aacb7777812328be525a11ea3fea upstream.

Memory allocated by btt_freelist_init(), btt_rtt_init(), and
btt_maplocks_init() is not freed on some discover_arenas() error
paths. This leaks memory when arena discovery fails.

Add the missing kfree() calls to release the allocations before
returning an error.

[ as: commit message and log edits ]

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260519-nvdimmleaks-v1-1-592300fb7a43@cse.iitm.ac.in
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -923,6 +923,9 @@ static int discover_arenas(struct btt *b
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
  out_super:


