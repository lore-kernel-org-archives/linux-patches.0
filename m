Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22C1376BC5;
	Tue, 16 Dec 2025 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888046; cv=none; b=VUSDvNTzZmEFsaoa0nfV2s0716xndp6Pe55vbPv15HiuDXqs/fnImWFG2Hn36tv2wEFRT6mf+XQVlw4zPcUZb3ObystrkU73D04wPBBhnRQfyW4BtmTgQXghymYh3uzNlnX/UC1C1D10drvekse6m6CWCgOKvGBz+1N7C44nTvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888046; c=relaxed/simple;
	bh=slCMW259RdwYcOSwG43n9QWEC14c/IkERMdnt4FWoW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVvSmDHtHtUc0pCcGHJvHYln6jQLgPqTWX0f6on3jatG+eutWvf6OrIJQP7amBebbDUopxP1sRPjUXJvtYfnDOX9IihCwjzebE6mInnOrVOoZ43inV/pqYn06jZjrCuiZArXiInMHvAiVLRd3EkcaxzbrSfHvgviuo4Kb5v3/QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zpaeb6ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zpaeb6ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1045AC4CEF1;
	Tue, 16 Dec 2025 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888045;
	bh=slCMW259RdwYcOSwG43n9QWEC14c/IkERMdnt4FWoW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zpaeb6ZTyIEX8MU9ag5FWo1VDbnXhPtx+pR9m/+qHXHRn17WdfYw2cAVH2u951X/E
	 QGmkixk8JN6RDjhHRxi85pbcsQAVuGpicYf5oJak2rcvsg5C+AB5/GlucHy3OvqJql
	 V3ULNLE/d0d7ABcCSMhY6Q9ujL62gOfsi0WlBteM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 414/614] um: Dont rename vmap to kernel_vmap
Date: Tue, 16 Dec 2025 12:13:01 +0100
Message-ID: <20251216111416.371823467@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: David Gow <davidgow@google.com>

[ Upstream commit a74b6c0e53a6df8e8a096b50c06c4f872906368a ]

In order to work around the existence of a vmap symbol in libpcap, the
UML makefile unconditionally redefines vmap to kernel_vmap. However,
this not only affects the actual vmap symbol, but also anything else
named vmap, including a number of struct members in DRM.

This would not be too much of a problem, since all uses are also
updated, except we now have Rust DRM bindings, which expect the
corresponding Rust structs to have 'vmap' names. Since the redefinition
applies in bindgen, but not to Rust code, we end up with errors such as:

error[E0560]: struct `drm_gem_object_funcs` has no fields named `vmap`
  --> rust/kernel/drm/gem/mod.rs:210:9

Since libpcap support was removed in commit 12b8e7e69aa7 ("um: Remove
obsolete pcap driver"), remove the, now unnecessary, define as well.

We also take this opportunity to update the comment.

Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://patch.msgid.link/20251122083213.3996586-1-davidgow@google.com
Fixes: 12b8e7e69aa7 ("um: Remove obsolete pcap driver")
[adjust commmit message a bit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Makefile | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 7be0143b5ba35..721b652ffb658 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -46,19 +46,17 @@ ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
 ARCH_INCLUDE	+= -I$(srctree)/$(HOST_DIR)/um/shared
 KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/um
 
-# -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
-# named - it's a common symbol in libpcap, so we get a binary which crashes.
-#
-# Same things for in6addr_loopback and mktime - found in libc. For these two we
-# only get link-time error, luckily.
+# -Dstrrchr=kernel_strrchr (as well as the various in6addr symbols) prevents
+#  anything from referencing
+# libc symbols with the same name, which can cause a linker error.
 #
 # -Dlongjmp=kernel_longjmp prevents anything from referencing the libpthread.a
 # embedded copy of longjmp, same thing for setjmp.
 #
-# These apply to USER_CFLAGS to.
+# These apply to USER_CFLAGS too.
 
 KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ \
-	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
+	$(ARCH_INCLUDE) $(MODE_INCLUDE)	\
 	-Dlongjmp=kernel_longjmp -Dsetjmp=kernel_setjmp \
 	-Din6addr_loopback=kernel_in6addr_loopback \
 	-Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr \
-- 
2.51.0



