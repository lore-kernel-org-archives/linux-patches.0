Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A0B17FD;
	Thu, 13 Jun 2024 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283049; cv=none; b=MJNRimqfc1QCS9gvTUigBuZm7eLJKz52qeuvftOiRVvJrzhkDi+wKgOpU+dNnK0kJFaz1UIhaPzKyjtc+mMQeGccz8J+MYWCHt4A+hkhM1UeGQtpHLL6Pn1oMbMW2QXA2THoxMI9jmZV5dE4UpDac/dYVKJBxZ0fyKU8VsWAT68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283049; c=relaxed/simple;
	bh=UQiLNQUYeS2ITX7dpPqlC8Er1w90p5E4qgEPBBPsr90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mwal/u90joJqNrUUYV2YhKupc+B1DQdajdTm3F3rhykmclOzeR1neGS9Y6glzumIxiFqtN4BIRTc5FG8Vhu/gh8qwX1qvXiaepg+9IYtMERZ2/Vn6ago2oKlygRr9f++hk3sl4bk3VpTMXaVBiz6JMgWEyo/c0Bn5lCkvAOanq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfDBlQjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfDBlQjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85716C2BBFC;
	Thu, 13 Jun 2024 12:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283048;
	bh=UQiLNQUYeS2ITX7dpPqlC8Er1w90p5E4qgEPBBPsr90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfDBlQjKxNRgq0g4n7Y/wOb7le+IKrLjZbMgenC0g1GaIZOvDaFqMmFgyNMJlVkv2
	 KHpmDAP1SAte36HvDtcqpHuM0SaQ6xLDqLbdgVFycSVqqGgZTanILWrO1zrVABpY5J
	 OqVt9C0ojTM0aQ4hdYt5IFj4clI/0A8V9x6f97ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.1 81/85] nfs: fix undefined behavior in nfs_block_bits()
Date: Thu, 13 Jun 2024 13:36:19 +0200
Message-ID: <20240613113217.261320722@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 3c0a2e0b0ae661457c8505fecc7be5501aa7a715 upstream.

Shifting *signed int* typed constant 1 left by 31 bits causes undefined
behavior. Specify the correct *unsigned long* type by using 1UL instead.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -695,9 +695,9 @@ unsigned long nfs_block_bits(unsigned lo
 	if ((bsize & (bsize - 1)) || nrbitsp) {
 		unsigned char	nrbits;
 
-		for (nrbits = 31; nrbits && !(bsize & (1 << nrbits)); nrbits--)
+		for (nrbits = 31; nrbits && !(bsize & (1UL << nrbits)); nrbits--)
 			;
-		bsize = 1 << nrbits;
+		bsize = 1UL << nrbits;
 		if (nrbitsp)
 			*nrbitsp = nrbits;
 	}


