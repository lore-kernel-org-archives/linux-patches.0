Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F7F1CA8F;
	Mon,  1 Apr 2024 16:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988367; cv=none; b=Hrh8w2N7lVExB5tzXKjyfIqSAtTjN9p8JC20CaoHzRm3yfYE9tG+waFh2Ierd4s+6LvlEDI6XTkJOLeacMFi33Le/PWpMyaj91YIR1JuSKDZtr7hZlFA4KHiJ0FHQRpsudGp2eZBN3mAOGjIAdkVzeIax20+3M/Ph/3eDFJ/eyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988367; c=relaxed/simple;
	bh=pr+KYDa1mMM87Wy+PiYOx1ou3NdZueaH2nsdWMRyaJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGJ3giMuXXqfpZvMJy215FLQj+V5TJtDOI3Zcz0Fn5VPLEz6a7uQlKVECtJdXjv4uPNdcPzBtY4AqgusjwDAlRYVYsEpphgaJ+tVpPAwApW1mEV/y68ShxH5z5x4yLSeczHQ3dkAvY+oyZrc8wfFnpXMe8LuomP0ohezYlgBork=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhMvwR+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhMvwR+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F84C433C7;
	Mon,  1 Apr 2024 16:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988366;
	bh=pr+KYDa1mMM87Wy+PiYOx1ou3NdZueaH2nsdWMRyaJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhMvwR+jePzBqoI1F51gJWZ4iMBAhDCvpSbwfkhEftcmHXQ53ylHjKeNZuOTeS3BC
	 22r5aetrL2gqPfySeT+C2iHDjq+CnAmLfUkBjfS0EDkfp7ynKlhZDk/7y1Wwr5Pd9h
	 kPoz4P1WnguHYwhqYOo5sfc9SO+uYu475F6xvyzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 135/432] kbuild: Move -Wenum-{compare-conditional,enum-conversion} into W=1
Date: Mon,  1 Apr 2024 17:42:02 +0200
Message-ID: <20240401152557.159641303@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 2fe6f2828d376..16c750bb95faf 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -143,6 +143,8 @@ KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
+KBUILD_CFLAGS += -Wno-enum-compare-conditional
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 
 endif
-- 
2.43.0



