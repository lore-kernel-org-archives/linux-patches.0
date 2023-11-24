Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B107381D6;
	Fri, 24 Nov 2023 18:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3knKpqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E83EC433C7;
	Fri, 24 Nov 2023 18:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849130;
	bh=JpX57ZJyskPqoipRBcCeIPC/nk+Uv/egKHvirD6I1fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3knKpqUecCa1UxJALjhERIsyGEDKAXAhGMtUz80h/IR1t9ybCG5dFzt9uvSNw+lO
	 cMGOfu9RDjsrw2/YXFxHL3HkZCTxPPgsiqbnSghngV/qPrOcfeueVWu7STXFTnzpa4
	 wAmLD0YcZErd6XcXxwWyiCBA1KCJQSPqhOlMRgtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Airlie <airlied@redhat.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Zack Rusin <zackr@vmware.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/530] kernel: kexec: copy user-array safely
Date: Fri, 24 Nov 2023 17:43:46 +0000
Message-ID: <20231124172029.886369270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit 569c8d82f95eb5993c84fb61a649a9c4ddd208b3 ]

Currently, there is no overflow-check with memdup_user().

Use the new function memdup_array_user() instead of memdup_user() for
duplicating the user-space array safely.

Suggested-by: David Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230920123612.16914-4-pstanner@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 107f355eac101..8f35a5a42af85 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -247,7 +247,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH_DEFAULT))
 		return -EINVAL;
 
-	ksegments = memdup_user(segments, nr_segments * sizeof(ksegments[0]));
+	ksegments = memdup_array_user(segments, nr_segments, sizeof(ksegments[0]));
 	if (IS_ERR(ksegments))
 		return PTR_ERR(ksegments);
 
-- 
2.42.0



