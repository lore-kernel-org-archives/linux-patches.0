Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B2B4266A5;
	Sat, 12 Sep 2026 10:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210795; cv=none; b=jMGpipZOj+e5yOKlupKKrgnObEJcOey+rmDbDDScFJeMUx5wlurHM012rK0BSNwY8fLu35/RG+khXFr6Rn6lvi9CQDdB1hntTWwDuDUV8kEq/WwH+x7ugnJ9SZCgPyfyL8l1279RWOUYthkmcapXn/GGIWeDfrilGPpkr7LOWtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210795; c=relaxed/simple;
	bh=eS3UxLAAYVY5F+RbSk+CKL3FRjw2n0+SSyksKYWn4eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orI8nXYeH9hIhXuvfMg6pTWZ35kZIZ4a5KEi/SMUpOe+lcH46pk65YKuXNMbXTJlc+nI7r+S34+uSnXs59/zRscSegOYEcqZ4far4kEXk4dRqFMT/COXiJCwGkp1IJO+rrDZMIiWuJT6LdZQDmNNAZaCcywxEEE/EAVZF1MER+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUag0BKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUag0BKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C401F1F000FF;
	Sat, 12 Sep 2026 10:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210794;
	bh=z12+xZzo3TaCyRTOU0asir88scDE7Dz5hNsLnjy48xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUag0BKqTY8CUQxjKhJyWeQ07Rg8oW7QMKn+HBKJLveK3RB6KOVTOwR1Lk+LkZh4h
	 VnKUpee66OFiVRChcNiFMKlrbWXICAGvih3Fy8fIWvSh1+vyJD0FryC0Qc/hsiNide
	 s1TiOk7irjAkuHE1UUvIV2ZjFZNgSrVn5EgfqB8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1097/1518] rust: uapi: replace direct asm-generic/ioctl.h include with linux/ioctl.h
Date: Sat, 12 Sep 2026 08:54:26 +0200
Message-ID: <20260912065648.268037468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

[ Upstream commit cdfcaa36ac93aa96df8310d7e57860f7600b2861 ]

rust/uapi/uapi_helper.h was directly including <uapi/asm-generic/ioctl.h>
instead of the proper <uapi/linux/ioctl.h>.

On powerpc, <uapi/linux/ioctl.h> pulls in <uapi/asm/ioctl.h> first, which
defines _IOC_SIZEBITS, _IOC_DIRBITS, _IOC_NONE, and _IOC_WRITE with the
arch-specific values, before falling through to <asm-generic/ioctl.h>.
By bypassing that chain and including <asm-generic/ioctl.h> directly,
the arch-specific overrides never ran first, so when other headers in
the compilation later brought in the full arch-aware chain, Clang saw
those four macros being defined a second time and emitted:

clang diag: arch/powerpc/include/uapi/asm/ioctl.h:5:9: warning: '_IOC_SIZEBITS' macro redefined [-Wmacro-redefined]
clang diag: arch/powerpc/include/uapi/asm/ioctl.h:6:9: warning: '_IOC_DIRBITS' macro redefined [-Wmacro-redefined]
clang diag: arch/powerpc/include/uapi/asm/ioctl.h:8:9: warning: '_IOC_NONE' macro redefined [-Wmacro-redefined]
clang diag: arch/powerpc/include/uapi/asm/ioctl.h:10:9: warning: '_IOC_WRITE' macro redefined [-Wmacro-redefined]

Fix this by replacing the direct include of <uapi/asm-generic/ioctl.h>
with <uapi/linux/ioctl.h>, which is the correct arch-aware entry point
and already maintains the intended include order.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608050618.9dekfjtF-lkp@intel.com/
Signed-off-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Fixes: 4e1746656839 ("rust: uapi: Add UAPI crate")
Link: https://patch.msgid.link/20260811063345.685884-1-mkchauras@gmail.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/uapi/uapi_helper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/uapi/uapi_helper.h b/rust/uapi/uapi_helper.h
index 06d7d1a2e8dab..1c4aa4292dcec 100644
--- a/rust/uapi/uapi_helper.h
+++ b/rust/uapi/uapi_helper.h
@@ -6,11 +6,11 @@
  * Sorted alphabetically.
  */
 
-#include <uapi/asm-generic/ioctl.h>
 #include <uapi/drm/drm.h>
 #include <uapi/drm/nova_drm.h>
 #include <uapi/drm/panthor_drm.h>
 #include <uapi/linux/android/binder.h>
+#include <uapi/linux/ioctl.h>
 #include <uapi/linux/mdio.h>
 #include <uapi/linux/mii.h>
 #include <uapi/linux/ethtool.h>
-- 
2.53.0



