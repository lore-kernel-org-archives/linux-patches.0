Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C60433E63;
	Thu, 30 Jul 2026 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424209; cv=none; b=cVclIQYLTWffC9SItQISMjQqQhpUT4NsiF+MuiUivN3lzhJ3l3CwUByVhEB9jnhjsA+2KP6h6De8Id4BX55Y4lqA9L02gU9H58Bp1BkQyxvQvBf8m0pK5Ix9mAcdRbnYLiIXykdRSRueCEIUb62p1omn5XlxordpgFXazbYCEYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424209; c=relaxed/simple;
	bh=0YYmjy+sfAswh1e+MAyzYSKw7KXNNypXfxHh03xue5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N351DRLmRqQh3KZuigwbtt8swNlT7p54u3SWelmKVyOPWsf/s3XWUmRxyVsi9BqXOnV7PwKRr5KkK/UFRU4Bzp8EWZLGyo0uRAsuHFLfIV0bVafEgNamthrPV1uQEihAsdXTAKerg6ydQNilb1lDSr5B5+HpKBwuRCV4ungXzsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/xoY4yZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/xoY4yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371181F000E9;
	Thu, 30 Jul 2026 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424207;
	bh=aSl6gI7l36gcyOHaw0bCmx4tRjwvzozqZCXigA6RQF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/xoY4yZICf0NeeglamngoC3+QujQw3zWRj+ngrY8niqay8BgJT46SlSZwoAAr2uQ
	 99wsTZEpQ/93ulLlWN6H0k2s5ex3gNFQMa0vdybq9ui7rPiyxk6W6pLxyaJWfPPWHe
	 qBfQWKYgb/P5LlM9V8T+VGcf/VspUwiuo+BfbG2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/675] cred: add scoped_with_kernel_creds()
Date: Thu, 30 Jul 2026 16:09:59 +0200
Message-ID: <20260730141450.848496876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: a1e0eb8f55cf ("ovl: check access to copy_file_range source with src mounter creds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cred.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 89ae50ad2acea9..6225c0cef3d779 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -180,6 +180,14 @@ static inline const struct cred *revert_creds(const struct cred *revert_cred)
 	return rcu_replace_pointer(current->cred, revert_cred, 1);
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
-- 
2.53.0



