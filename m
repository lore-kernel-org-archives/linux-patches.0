Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E6F145353;
	Thu, 11 Apr 2024 10:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830620; cv=none; b=Tkwy+0wTElHsqZs2AFbSfIx6P5j9zAaHayp13kuLUoY7z19VTAQgiCdBIOeRp1AcVlBurIqm4seEjjHtibPxjmGWfm2zNb8e4DQvYDkX2NJZzx5jnXRE/DsOeNhmbkPB7yGv/NBrLJ8b2VxEFFGUCHsn60EZU7+Ms3LvYoSE8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830620; c=relaxed/simple;
	bh=o78f7YRO4Qj19Xpah9nxaUompouEIWGQhTH4xhgeI7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCQLpDnz15ihygsH5IzK9yMFUuUi7h0Iw32Ui5Zd1TArGpPgAXADIOfgwQQKIIkEYvs2qnTU9hSySIML+9LNmmENtzaq0O4JWpWKfGXTdaY1h0g9FzzyVOTv+X0qpfFq89sN8TfTzuGmbETf+zQFFYowNUu5/loUM+VwL9Nu2uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDNBgFf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDNBgFf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97661C433C7;
	Thu, 11 Apr 2024 10:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830620;
	bh=o78f7YRO4Qj19Xpah9nxaUompouEIWGQhTH4xhgeI7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDNBgFf5Vu/b6KPnWe/M0nIqdLp6KtzsRQ9f8ggBO7Ix9JAeIGUu0sJB0leSPmo5y
	 5XdwV8NBwaH8y9AJ4kwfNcQrKveeDBlGQsVRWS8f94bdzkSpEWxXN1a6dtoJhn0T5A
	 pFdbItCG/oEXe+S3LSP0Ev1OF/g6pTU03oiC/ANQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/215] kbuild: Move -Wenum-{compare-conditional,enum-conversion} into W=1
Date: Thu, 11 Apr 2024 11:54:29 +0200
Message-ID: <20240411095426.701000032@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6a78afc6f13b4..a51193485c50f 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -51,6 +51,8 @@ KBUILD_CFLAGS += -Wno-format-zero-length
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
+KBUILD_CFLAGS += -Wno-enum-compare-conditional
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 
 endif
-- 
2.43.0



