Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF7015AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CC4C433C9;
	Tue, 25 Jul 2023 10:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282459;
	bh=GTCHyTQOwTUqsgZC3Hg9NJPwxHOsATwyKUY4Sl2bHCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yosW7KSukog6R8DI9TDNepiCV2faR++8yu29xtCY+iyC4w5fNaofUyXxf/DIolM9
	 R08Gs7SrIYOvK8rD2kggOSUaFevvfJqgrkPk34HyVVFBuJEK9VUGUAy9ll7BGhaATE
	 9JUGHtjIGWhR1B/ON7YRWMS2YNkFGtU3WsBkZImI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 138/227] iov_iter: Mark copy_iovec_from_user() noclone
Date: Tue, 25 Jul 2023 12:45:05 +0200
Message-ID: <20230725104520.571667614@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 719a937b7003933de1298ffa4b881dd6a234e244 ]

Extend commit 50f9a76ef127 ("iov_iter: Mark
copy_compat_iovec_from_user() noinline") to also cover
copy_iovec_from_user(). Different compiler versions cause the same
problem on different functions.

lib/iov_iter.o: warning: objtool: .altinstr_replacement+0x1f: redundant UACCESS disable
lib/iov_iter.o: warning: objtool: iovec_from_user+0x84: call to copy_iovec_from_user.part.0() with UACCESS enabled
lib/iov_iter.o: warning: objtool: __import_iovec+0x143: call to copy_iovec_from_user.part.0() with UACCESS enabled

Fixes: 50f9a76ef127 ("iov_iter: Mark copy_compat_iovec_from_user() noinline")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lkml.kernel.org/r/20230616124354.GD4253@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 960223ed91991..061cc3ed58f5b 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1795,7 +1795,7 @@ static __noclone int copy_compat_iovec_from_user(struct iovec *iov,
 	return ret;
 }
 
-static int copy_iovec_from_user(struct iovec *iov,
+static __noclone int copy_iovec_from_user(struct iovec *iov,
 		const struct iovec __user *uiov, unsigned long nr_segs)
 {
 	int ret = -EFAULT;
-- 
2.39.2



