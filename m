Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D687A285C8D;
	Wed, 28 Jan 2026 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616083; cv=none; b=DBywEfS68BzBvloyn6lXoYuTC4zh7OGBdtkzc9yZc4eucQRBfl4THBQvKm9GzYiLVPSUD2kQb+9A6hYZ4nxcuY6/xM9wWktQ6D5CZTyi8nfPsILPyHka7VSgeLhFnWfW7ozQHSWykvn30hhVhk6DqcUhTfkJnx3c91TzMmQNj5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616083; c=relaxed/simple;
	bh=6/Sy2wkZdfk46CA9d2COyinjQIeRwbW+LQNNh6j7XBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhv081PzSJsuVbYXGEm6SKjJF/pwmzePl+Hf7fvvfSlemZlF5OWQQCiIOxaTQjPeLonm4CB8QuF9VxCMnQj0PJUTyaIVzLn8KLVUwfSxjCTi5m1xIqgOWNigTAMlVHo70T4zWgdqoZrVxIvQtBnYh3xV8T33KdoY/8elQy+WPbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx2m86Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx2m86Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4038DC4CEF1;
	Wed, 28 Jan 2026 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616083;
	bh=6/Sy2wkZdfk46CA9d2COyinjQIeRwbW+LQNNh6j7XBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xx2m86CcuVXO2omU6fH1Rau4NXJZ4+2aY+TsoKFxFh/spo7BaI0/nVL3UXoGLTrXt
	 yWO97SuwDE+8aeZslzrpnsmSOfyS+nmgJ7JeTmDkVjx3UTfaFHKgKduhjorpDZjAmu
	 eptvAZ7TKZoOWGtXKL2CKQUo8CMDO8E10ynRoMp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 200/227] rust: irq: always inline functions using build_assert with arguments
Date: Wed, 28 Jan 2026 16:24:05 +0100
Message-ID: <20260128145351.638533447@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

commit 5d9c4c272ba06055d19e05c2a02e16e58acc8943 upstream.

`build_assert` relies on the compiler to optimize out its error path.
Functions using it with its arguments must thus always be inlined,
otherwise the error path of `build_assert` might not be optimized out,
triggering a build error.

Cc: stable@vger.kernel.org
Fixes: 746680ec6696 ("rust: irq: add flags module")
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20251208-io-build-assert-v3-6-98aded02c1ea@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/irq/flags.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/kernel/irq/flags.rs b/rust/kernel/irq/flags.rs
index adfde96ec47c..d26e25af06ee 100644
--- a/rust/kernel/irq/flags.rs
+++ b/rust/kernel/irq/flags.rs
@@ -96,6 +96,8 @@ pub(crate) fn into_inner(self) -> c_ulong {
         self.0
     }
 
+    // Always inline to optimize out error path of `build_assert`.
+    #[inline(always)]
     const fn new(value: u32) -> Self {
         build_assert!(value as u64 <= c_ulong::MAX as u64);
         Self(value as c_ulong)
-- 
2.52.0



