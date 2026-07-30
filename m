Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61B9382F01;
	Thu, 30 Jul 2026 15:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426813; cv=none; b=Fe1T4hiJxIgG8eYUJUipwR5+ahrEb9igfeKu3ziw7rzyPIXSldCBzklPq3VucNMkXD5+aZ4zpktR5AehpojbrLdzmPTYxcbUuy606WAWbbR1YKyWBKevdtZad+KI55O31HD8k4TDKPDeLb6OMnY3FmJAOQ6EVpcTS2lOHhEmZ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426813; c=relaxed/simple;
	bh=Rc6JnBtKEhWNpxJJRcxjIWnOZMrqhCV2rFLV5lglGSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv+bnV+6A+F+AzRMKcRMsV2vcYqT7QvMYhq9xwUWqx09XcZMmare4vbJ1g2uZBcf+r4aaQz/BxJUUCqcSqJ941spk/1LUPtSyZznoMoTbE2z268E6sWDyS+mSi8xcq63FmHyV1Jo6p/OtGb0C2HyOIObZXQapsvkViVfCoMnXR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU+WScZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU+WScZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DB01F000E9;
	Thu, 30 Jul 2026 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426812;
	bh=t96o+K+D2teKHZVkiRyU3g/dLfFSlcDTsMuExQ7noqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dU+WScZG8Y+c2l2kHE9mpeeWWgsF3peHnUlxguE9UyadEWk+fCVe76COb0rroZlMG
	 w2b9dSxY208cWaeA7etf8aqItHfiLjK/zkqZ0pg9HZFWW3eKkuQLh+WXyjgvyeKMJJ
	 JXn+JfRtY2XhnSEbHBLpfyIt6HdnDz/PnXUmnJlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 550/602] cred: add scoped_with_kernel_creds()
Date: Thu, 30 Jul 2026 16:15:42 +0200
Message-ID: <20260730141447.589876499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit ae40e6c65791f47c76cc14d0cce2707fe6053f72 ]

Add a new cleanup class for override creds. We can make use of this in a
bunch of places going forward.

Based on this scoped_with_kernel_creds() that can be used to temporarily
assume kernel credentials for specific tasks such as firmware loading,
or coredump socket connections. At no point will the caller interact
with the kernel credentials directly.

Link: https://patch.msgid.link/20251103-work-creds-init_cred-v1-4-cb3ec8711a6a@kernel.org
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 981ccd97f715 ("dm: avoid leaking the caller's thread keyring via the table device file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cred.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -205,6 +205,14 @@ static inline struct cred *get_new_cred(
 	return get_new_cred_many(cred, 1);
 }
 
+DEFINE_CLASS(override_creds,
+	     const struct cred *,
+	     revert_creds(_T),
+	     override_creds(override_cred), const struct cred *override_cred)
+
+#define scoped_with_kernel_creds() \
+	scoped_class(override_creds, __UNIQUE_ID(cred), kernel_cred())
+
 /**
  * get_cred_many - Get references on a set of credentials
  * @cred: The credentials to reference


