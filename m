Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01301443AB3;
	Tue, 21 Jul 2026 21:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668080; cv=none; b=nlNGE8jGVVyx7g/Sz17MLY1NY3A/7u6/Am6WA6fFh+Gekda2tOCqw3poA/Mv8pu32Mynat4WGs5yYRhMKbq4HV1rZPpXESwAi9ScSRUmr1TAnJte6ShTlWxKYu1HY957EbSbOkFdrgjv+RVoxtLJbocSDo6HjReQw1ewirTH5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668080; c=relaxed/simple;
	bh=EbIRrbbiQK06m/0g8SvjWRtKbowwFjbm51paS+Jct3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNiCwhh5q75VczjFkKKS4P9nzhSPLKeTTOKMjZqb6d5VbDuywhqNM7IlYoi6u1Nnp7PKX7cPTyY7rw/8tMV8knRE3yBJfwSp561FICszbsuE+3CiM609DBuW/B+/TIbhLMEZdqn0vd7aqgaCaB2XAApQ1XQliTP7noRfk0oa8Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQ1nXgB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQ1nXgB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680711F000E9;
	Tue, 21 Jul 2026 21:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668078;
	bh=2d8PhelC6I3HPMeVu2WT0DcjD948WkFl6zFTsc/kWRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQ1nXgB3wReGEbNUqB2mk66ksXBnFkKXL2YrJKaNCMXPC6LRhKrXtJmgEsGPI1Oc+
	 Hg/3xoDUtOdL/2Ss1nS8238iOX3KW87pWnV/9si0XmYnT7NEmRxj61r3AsV1ratI/N
	 RDpLwyPCnPAE4kVMxOQtliqw9IRDkoyxRKG7id24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	carnil@debian.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.1 0039/1067] file: add fput() cleanup helper
Date: Tue, 21 Jul 2026 17:10:40 +0200
Message-ID: <20260721152425.431323327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 257b1c2c78c25643526609dee0c15f1544eb3252 ]

Add a simple helper to put a file reference.

Link: https://lore.kernel.org/r/20240719-work-mount-namespace-v1-4-834113cab0d2@kernel.org
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/file.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -11,6 +11,7 @@
 #include <linux/posix_types.h>
 #include <linux/errno.h>
 #include <linux/cleanup.h>
+#include <linux/err.h>
 
 struct file;
 
@@ -93,6 +94,7 @@ extern void put_unused_fd(unsigned int f
 
 DEFINE_CLASS(get_unused_fd, int, if (_T >= 0) put_unused_fd(_T),
 	     get_unused_fd_flags(flags), unsigned flags)
+DEFINE_FREE(fput, struct file *, if (!IS_ERR_OR_NULL(_T)) fput(_T))
 
 extern void fd_install(unsigned int fd, struct file *file);
 


