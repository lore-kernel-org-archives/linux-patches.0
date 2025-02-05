Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0BB1A83ED;
	Wed,  5 Feb 2025 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768466; cv=none; b=GzM0dinP/5IBCi7YRUMWxO7q1R5yXC3Zx8K47M0jm61vIDpZQWuumNs+rZtgammigAVxopyPWePhKUmSBw6uEMhd+8tNdWfneDwmOW7R4i6vVvTTzRuuYiJP7Y+srx9SR3hKOHiAS/Y7kKqvCBMp0upFR/7oFPFx8hRAr5jG8U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768466; c=relaxed/simple;
	bh=ny448OW3qZm7FLB5sKTWKgEE0jb0kSZMFzaoe5ZHmho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWfSALe3WfVUtGIekxl5d5LH0ImRlDE7SABe0r1QGbnuj9IUqeSLbplE1Ex/0u1qNfXt+KHbW3pSIY+e6KnoD61mWjmq4VDTOts3ZG2AoVRReYCfHkYJ8LExNa5jKMEDuKU1GP1jTSrXOGdoUn5YLI9zZN7kyQ08dvnBmQS3r2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMP/xZAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMP/xZAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF2DC4CED1;
	Wed,  5 Feb 2025 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768466;
	bh=ny448OW3qZm7FLB5sKTWKgEE0jb0kSZMFzaoe5ZHmho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMP/xZAcYJSxLLEeCGC87oq5w4uyRwvMNKB8y/9BJYQFLS9U2GO8fTnlpmAiOI0G+
	 Zh5QNV4V3sguwnIkfm7M9dh4fNBbeOQmVuQl9Io1xAdSRrUqpzUhze+jdD9XoaJ9+o
	 H9quSzSvOCNrZtOdr027JKLaT7QWQApxAcwZpjIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 566/623] kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST
Date: Wed,  5 Feb 2025 14:45:08 +0100
Message-ID: <20250205134517.871221884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit a314f52a0210730d0d556de76bb7388e76d4597d ]

Most 'make *config' commands use .config as the base configuration file.

When .config does not exist, Kconfig tries to load a file listed in
KCONFIG_DEFCONFIG_LIST instead.

However, since commit b75b0a819af9 ("kconfig: change defconfig_list
option to environment variable"), warning messages have displayed an
incorrect file name in such cases.

Below is a demonstration using Debian Trixie. While loading
/boot/config-6.12.9-amd64, the warning messages incorrectly show .config
as the file name.

With this commit, the correct file name is displayed in warnings.

[Before]

  $ rm -f .config
  $ make config
  #
  # using defaults found in /boot/config-6.12.9-amd64
  #
  .config:6804:warning: symbol value 'm' invalid for FB_BACKLIGHT
  .config:9895:warning: symbol value 'm' invalid for ANDROID_BINDER_IPC

[After]

  $ rm -f .config
  $ make config
  #
  # using defaults found in /boot/config-6.12.9-amd64
  #
  /boot/config-6.12.9-amd64:6804:warning: symbol value 'm' invalid for FB_BACKLIGHT
  /boot/config-6.12.9-amd64:9895:warning: symbol value 'm' invalid for ANDROID_BINDER_IPC

Fixes: b75b0a819af9 ("kconfig: change defconfig_list option to environment variable")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 4286d5e7f95dc..3b55e7a4131d9 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -360,10 +360,12 @@ int conf_read_simple(const char *name, int def)
 
 			*p = '\0';
 
-			in = zconf_fopen(env);
+			name = env;
+
+			in = zconf_fopen(name);
 			if (in) {
 				conf_message("using defaults found in %s",
-					     env);
+					     name);
 				goto load;
 			}
 
-- 
2.39.5



