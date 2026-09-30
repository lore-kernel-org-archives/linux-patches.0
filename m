Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B444251B196;
	Wed, 30 Sep 2026 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792682; cv=none; b=NrPX4hH5Q2ToE0P3Fhu/aIWgMmL9Rx4gNq4TuLDb+8xe5tFt9Ldz+v4UZnbM/1oDEML1gW/XnHsBEC8gaRLG7To1blX7zg81mySjIL/59RVwifB7OfsP8Xtxa7F8ruJtcHkRbQrouTZP1xJANHagYb+Q06jNt5CtW8Abgx65TlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792682; c=relaxed/simple;
	bh=Hb1Mb3vewossXIUcwjToAQE71XPnMD+h8KvD3HutuFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deWSMKlWeirjTde/Embe0aeB03+Nl/kxbS3ue/3g3x/ptxvDDFzMCwT1XT99JFnD5B9PejA1zflytJCo9B9BTTVSrRuPu6PYvsmPf80OOg+cbJnw/pwTkRidMDmtv5XJ++laIVJHuzyT24i4685ZX5VhJf+0VKYa7QEuOUdpvq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vheo4tnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vheo4tnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4571F00898;
	Wed, 30 Sep 2026 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792681;
	bh=AiRH2wXjuja6lIaXpCz3hUoodwLMYHVEBsougu/LFso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vheo4tnwEwh64DAvWq9HJkBskspsDA00kP1NVJONOc5qFYadwVa9ztNx6/KK+1ikB
	 xH1eQWM6yk2XaFn5487rDNbIlOBTqaJN6uQ5X4eAOucmwda4GBIR5w+auHsgTfU0rS
	 3bHbBzPIt93jWNfQvFM15mWKSM+XzS4zgSrYCi8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 740/752] file: add fput() cleanup helper
Date: Wed, 30 Sep 2026 17:30:10 +0200
Message-ID: <20260930152414.231027657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
(cherry picked from commit ac275934626a85285cca43405e876566daa10533)
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/file.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/file.h b/include/linux/file.h
index 6726240b9279a..fb8a5d22531e0 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -11,6 +11,7 @@
 #include <linux/posix_types.h>
 #include <linux/errno.h>
 #include <linux/cleanup.h>
+#include <linux/err.h>
 
 struct file;
 
@@ -95,6 +96,7 @@ extern void put_unused_fd(unsigned int fd);
 
 DEFINE_CLASS(get_unused_fd, int, if (_T >= 0) put_unused_fd(_T),
 	     get_unused_fd_flags(flags), unsigned flags)
+DEFINE_FREE(fput, struct file *, if (!IS_ERR_OR_NULL(_T)) fput(_T))
 
 extern void fd_install(unsigned int fd, struct file *file);
 
-- 
2.53.0



