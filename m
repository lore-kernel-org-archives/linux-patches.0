Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA761448EF;
	Thu, 11 Apr 2024 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829628; cv=none; b=f5XFeENa/BJrzU4wRl/bZ59q86Gs7nvl76OUQxgFHoEB+06+bF9Hyi6fhfk4uMV7QMJoFiHExBu4WrChLx9cZlDPzfBmymwgOflCVFSzIr8wqABdyFJAU5KiGGzYwz8uAtc+KhrlnPTtGPiCbiQRwjAxuH/ivqtWQ6/obxbU/ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829628; c=relaxed/simple;
	bh=0wvt95ZKmLqg5yLw9U5lCl87GJMieU/GSUurwNEg0XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHIbZHip2tVp6Os8nUp5MPSXK8lANtA+ENJA01eX9O1L1jDYMgkmVYJR7pxgyGV4CPlB06KM0Qqw9ngnDESvsxph6e4q3XsPvzjA7+vERYL9OO2AKhOgTC2hFYxChI5MhQzr9Zt7jcO8UJm3qTMWTkEQCd8ISxhuajGMPLnUuNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N47t8XYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N47t8XYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A77FC433C7;
	Thu, 11 Apr 2024 10:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829628;
	bh=0wvt95ZKmLqg5yLw9U5lCl87GJMieU/GSUurwNEg0XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N47t8XYRJJBoRdDD1XkwLeYBc2vODZzMsFgDW4ZW025HbcexsCsG9gSuiJOpnUUK/
	 6qyp8kTjPlWZaMfKrbaaZDczFvTlXStpE6xDTF6y2kvtlqVdpSfGpzyHjRKUttMfPf
	 l2Jpcwu6yRbgChEYytPQV6a15WALzf9M2uiTxrhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/175] kbuild: Move -Wenum-{compare-conditional,enum-conversion} into W=1
Date: Thu, 11 Apr 2024 11:54:35 +0200
Message-ID: <20240411095421.134563921@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 75b5ab134bb5f657ef7979a59106dce0657e8d87 ]

Clang enables -Wenum-enum-conversion and -Wenum-compare-conditional
under -Wenum-conversion. A recent change in Clang strengthened these
warnings and they appear frequently in common builds, primarily due to
several instances in common headers but there are quite a few drivers
that have individual instances as well.

  include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
    508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
        |                            ~~~~~~~~~~~~~~~~~~~~~ ^
    509 |                            item];
        |                            ~~~~

  drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c:955:24: warning: conditional expression between different enumeration types ('enum iwl_mac_beacon_flags' and 'enum iwl_mac_beacon_flags_v1') [-Wenum-compare-conditional]
    955 |                 flags |= is_new_rate ? IWL_MAC_BEACON_CCK
        |                                      ^ ~~~~~~~~~~~~~~~~~~
    956 |                           : IWL_MAC_BEACON_CCK_V1;
        |                             ~~~~~~~~~~~~~~~~~~~~~
  drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c:1120:21: warning: conditional expression between different enumeration types ('enum iwl_mac_beacon_flags' and 'enum iwl_mac_beacon_flags_v1') [-Wenum-compare-conditional]
   1120 |                                                0) > 10 ?
        |                                                        ^
   1121 |                         IWL_MAC_BEACON_FILS :
        |                         ~~~~~~~~~~~~~~~~~~~
   1122 |                         IWL_MAC_BEACON_FILS_V1;
        |                         ~~~~~~~~~~~~~~~~~~~~~~

Doing arithmetic between or returning two different types of enums could
be a bug, so each of the instance of the warning needs to be evaluated.
Unfortunately, as mentioned above, there are many instances of this
warning in many different configurations, which can break the build when
CONFIG_WERROR is enabled.

To avoid introducing new instances of the warnings while cleaning up the
disruption for the majority of users, disable these warnings for the
default build while leaving them on for W=1 builds.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2002
Link: https://github.com/llvm/llvm-project/commit/8c2ae42b3e1c6aa7c18f873edcebff7c0b45a37e
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.extrawarn | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index e15cd63428ba7..c2e41daf373f8 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -75,5 +75,7 @@ KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
+KBUILD_CFLAGS += -Wno-enum-compare-conditional
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 endif
-- 
2.43.0



