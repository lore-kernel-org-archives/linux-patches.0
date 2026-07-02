Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363D246BBA;
	Thu,  2 Jul 2026 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010887; cv=none; b=FPmhsVnb2QSLk6ZGIBVnUeMdB/FGPL2AN/bVndo/3Kj2GKCfBjUxc6O5mWuYf7S6lgvY9S5pWs+zvV3hr2RSmzq+xnpc1i2KeZzvwMN8XqzBrxwM1Bp5L4DfC9AYQ+FTZqovb9UuLKhR1uUsgnQP6/cmH60EjG+B4L1I4MqWmcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010887; c=relaxed/simple;
	bh=+EUXEWX5oApghztd/FcDbn6ijeEsPJ1usPYGwv9MhSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dduYEpu5JOvbBEb7b7viu7uI/XGoVr9+iqSTyrSF/ed0cjICzL5WU1KhZ4PLhoIxqhSgM2Yn6LQqm4rovICHJGBn7BhBtIu1KlHyQDZglA431K9YDsXdgymg0Fb2PxFx4QfPu+iJTpFIAEKLZHeEQ0WLFHGewZoVcQox359RNsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofAu72BQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofAu72BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556651F000E9;
	Thu,  2 Jul 2026 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010886;
	bh=v6a4DL3hhYeqqGdoSuyXk55V62253ulSZ13x9PiUB0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofAu72BQuFJaUKHhKUQpHaJyEOUsEWzXR3lEVuFVxem+xCwAGeCjpmHhnAgGldcJt
	 FQQSZTF/lUya3bMbzhL1WqrhjyFpc7hKeab2T12hQPpyud4A7RzHq7b2XUCcmAsAk3
	 lvhmZGLX1/GT3NATnRLIZAVmPSkpYyJPlPnTrOrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/175] file: add fput() cleanup helper
Date: Thu,  2 Jul 2026 18:19:36 +0200
Message-ID: <20260702155117.369800031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 257b1c2c78c25643526609dee0c15f1544eb3252 ]

Add a simple helper to put a file reference.

Link: https://lore.kernel.org/r/20240719-work-mount-namespace-v1-4-834113cab0d2@kernel.org
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
(cherry picked from commit 257b1c2c78c25643526609dee0c15f1544eb3252)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/file.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/file.h b/include/linux/file.h
index 6e9099d2934368..221ba0888107a0 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -11,6 +11,7 @@
 #include <linux/posix_types.h>
 #include <linux/errno.h>
 #include <linux/cleanup.h>
+#include <linux/err.h>
 
 struct file;
 
@@ -93,6 +94,7 @@ extern void put_unused_fd(unsigned int fd);
 
 DEFINE_CLASS(get_unused_fd, int, if (_T >= 0) put_unused_fd(_T),
 	     get_unused_fd_flags(flags), unsigned flags)
+DEFINE_FREE(fput, struct file *, if (!IS_ERR_OR_NULL(_T)) fput(_T))
 
 extern void fd_install(unsigned int fd, struct file *file);
 
-- 
2.53.0



