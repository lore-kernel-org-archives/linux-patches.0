Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50962E62C;
	Mon,  8 Apr 2024 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581782; cv=none; b=co/cRrJhgQzufqe7HBsE5cpdwP9/lTBmHcOADT85D6HteU1lGIiIPbBTqkB1L05YYelLWB8DL3ljenk8Ainng6yZ44EM4pG0CUwMWn3CThFjGGoIdtUeOG6NPTYNKAr9rUHuDw0v76Eqnb3tdK6OIpiyECrAZwFMDSf0Yjqfljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581782; c=relaxed/simple;
	bh=bsFgKWUoSEljY6GmjPHmbtPWCjcU3e61z2qxpbPI7j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=se+vs/AUWrkOODNYrchV5KKEF4fx42M55lZLESnFP53FJKiXhFlvMwWVczdHDovRDfdDEKzNTd7MLtleeA46FGfn/Kx8Itc076tq7A7QOUqk+dfBccK2yQKBitIjdVtsUAH2U7ln8Zi3cYKmopVQNHZYY11GLwan8VWANhRMqKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKsVQ0VJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKsVQ0VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDD0C433C7;
	Mon,  8 Apr 2024 13:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581782;
	bh=bsFgKWUoSEljY6GmjPHmbtPWCjcU3e61z2qxpbPI7j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKsVQ0VJ2pp9V3QKNbIW8NGMSmWQCxKjsdiVw02gnryxCBSyA1HIdyWbVhv9qysrr
	 sMbdw93P3ZP3xuWFil1iRb/B7U1qCwD98fqU4fFQH5DpXAaQnbQE9M/FTAvQKr6NGY
	 jsN7Ddn6zCbHIAWqBcbRGL7ODdSU8waSpsR6U0hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/690] kbuild: Move -Wenum-{compare-conditional,enum-conversion} into W=1
Date: Mon,  8 Apr 2024 14:49:08 +0200
Message-ID: <20240408125402.469169413@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f182700e0ac19..6881a0c96bc13 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -53,6 +53,8 @@ KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
+KBUILD_CFLAGS += -Wno-enum-compare-conditional
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 
 endif
-- 
2.43.0



