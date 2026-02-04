Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A01018859B;
	Wed,  4 Feb 2026 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219307; cv=none; b=UvNsGh13BR2Yu4fFHYcAY6/FnMzRVA87gwIoTcIIJtCSn2EyrJlnkJ4r0K0H5+ZNTk8fD3iRuL5D7/K+ftNGwQdCurE2yLvmLkz4rSqPzgsXX7sW+HBgFojk8upEcYOA72KFeFh86Cz97OmaLOMzebXIvAheUOb5W2nYMef1gjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219307; c=relaxed/simple;
	bh=u/Hxs4YRf/pTi0oLOo5Eu0FWIdqnqsXUff0+PgPs+ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSx5O/hP5YBBMSC4E7psYkSe9sKnl0PbVr2kuPlbBUT3XJlE9O5g+mIlf4L1Zx+q2zlyOBLAnNzGNATkAQdldUQJnBU68hK3Lal+5zms0rkTU+R0gM8ZnSpLXEzzJLwMUD/hIMIdxtBngDjcDo+MKzIFJbr+KDIONbJD8IbOcTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5ZOKmqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5ZOKmqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD82C4CEF7;
	Wed,  4 Feb 2026 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219306;
	bh=u/Hxs4YRf/pTi0oLOo5Eu0FWIdqnqsXUff0+PgPs+ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5ZOKmqFaqgFtD2qvxAOUt9xDfgvoUjzLzjA4qMECNg13SDlMnmMV7fwR2LcW0Di3
	 9qRZW1POms94iv9eYckRrWuGMmnCltRGYYISMPnAMHPH1W+o/YU7dXReAmY4jLzf8f
	 cc9oYiB9bb47l2QuhsM8dKKQCW5dLQZDvWGtfQoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 102/122] drm/tyr: depend on `COMMON_CLK` to fix build error
Date: Wed,  4 Feb 2026 15:41:24 +0100
Message-ID: <20260204143855.519621613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit b0581f6ab952ffd135ca4402d2ee3da641538d6b upstream.

Tyr needs `CONFIG_COMMON_CLK` to build:

    error[E0432]: unresolved import `kernel::clk::Clk`
     --> drivers/gpu/drm/tyr/driver.rs:3:5
      |
    3 | use kernel::clk::Clk;
      |     ^^^^^^^^^^^^^^^^ no `Clk` in `clk`

    error[E0432]: unresolved import `kernel::clk::OptionalClk`
     --> drivers/gpu/drm/tyr/driver.rs:4:5
      |
    4 | use kernel::clk::OptionalClk;
      |     ^^^^^^^^^^^^^^^^^^^^^^^^ no `OptionalClk` in `clk`

Thus add the dependency to fix it.

Fixes: cf4fd52e3236 ("rust: drm: Introduce the Tyr driver for Arm Mali GPUs")
Cc: stable@vger.kernel.org
Acked-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260124160948.67508-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tyr/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/tyr/Kconfig
+++ b/drivers/gpu/drm/tyr/Kconfig
@@ -6,6 +6,7 @@ config DRM_TYR
 	depends on RUST
 	depends on ARM || ARM64 || COMPILE_TEST
 	depends on !GENERIC_ATOMIC64  # for IOMMU_IO_PGTABLE_LPAE
+	depends on COMMON_CLK
 	default n
 	help
 	  Rust DRM driver for ARM Mali CSF-based GPUs.


