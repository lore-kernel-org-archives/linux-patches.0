Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9B5248BAC;
	Wed, 15 Jan 2025 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937898; cv=none; b=Oqgpktg2Q5t3aBPVZWIPmj3qeCz/yK+hGObhh0jU7nLfrtjNe4j/ebyx1jPUAPeogHBp7R+je7MfacguYmDZUuzpasbECCVXn1Yf0pd1fY/Z52ZWTbqgT8NSMFEWDC7gh+3W4ofAZU7/4VL1i4s8JAzuF12Va47MKYqyBNtIgw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937898; c=relaxed/simple;
	bh=N++E2hW5eE4sU3ABfZJcDYU6NqWIP1zPBNs1Q6hSMrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seuwcIkjPFc3/bQwfRMOxHPQJGDTagvIkbwmCzA4s4j8SD8XyYyTjllDMndSuOAvo40ptihr7qrwfdXUqu/sSd6LeVlVsZD9iGL7WCDUv2lBaCt1qz4cKd+nHl1CwDVtxrpQY4Nw5dGCd8IbHCjoA3G3gXW4UihtNpXdtEn9EcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwS6TbMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwS6TbMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805FFC4CEE2;
	Wed, 15 Jan 2025 10:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937898;
	bh=N++E2hW5eE4sU3ABfZJcDYU6NqWIP1zPBNs1Q6hSMrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwS6TbMo1zHzOOxhaQidmRxddqWwzrjYiTuHq7/Tx/oMpJdahzCL5nwapuKvfesoL
	 pqp9/S7NPMnvJKK9BbDSQ/Sn464M9xDU60S/Zb+RNCm6qhbt1++Nt+a2RWxITqBMD+
	 VWX096wpDo32bEVpYqYwXMwiC4H7T8rx2Aayj6/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/189] selftests/alsa: Fix circular dependency involving global-timer
Date: Wed, 15 Jan 2025 11:35:19 +0100
Message-ID: <20250115103607.288414581@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 55853cb829dc707427c3519f6b8686682a204368 ]

The pattern rule `$(OUTPUT)/%: %.c` inadvertently included a circular
dependency on the global-timer target due to its inclusion in
$(TEST_GEN_PROGS_EXTENDED). This resulted in a circular dependency
warning during the build process.

To resolve this, the dependency on $(TEST_GEN_PROGS_EXTENDED) has been
replaced with an explicit dependency on $(OUTPUT)/libatest.so. This change
ensures that libatest.so is built before any other targets that require it,
without creating a circular dependency.

This fix addresses the following warning:

make[4]: Entering directory 'tools/testing/selftests/alsa'
make[4]: Circular default_modconfig/kselftest/alsa/global-timer <- default_modconfig/kselftest/alsa/global-timer dependency dropped.
make[4]: Nothing to be done for 'all'.
make[4]: Leaving directory 'tools/testing/selftests/alsa'

Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Link: https://patch.msgid.link/20241218025931.914164-1-lizhijian@fujitsu.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alsa/Makefile b/tools/testing/selftests/alsa/Makefile
index 944279160fed..8dab90ad22bb 100644
--- a/tools/testing/selftests/alsa/Makefile
+++ b/tools/testing/selftests/alsa/Makefile
@@ -27,5 +27,5 @@ include ../lib.mk
 $(OUTPUT)/libatest.so: conf.c alsa-local.h
 	$(CC) $(CFLAGS) -shared -fPIC $< $(LDLIBS) -o $@
 
-$(OUTPUT)/%: %.c $(TEST_GEN_PROGS_EXTENDED) alsa-local.h
+$(OUTPUT)/%: %.c $(OUTPUT)/libatest.so alsa-local.h
 	$(CC) $(CFLAGS) $< $(LDLIBS) -latest -o $@
-- 
2.39.5



