Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7911CAA82;
	Wed, 19 Feb 2025 09:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956600; cv=none; b=k20BRuoXdC+xq0twJDjyfysg/dGCUyWPTGtzm9EN9/bkzRGV38F9NemT2hlaHvjsyenMbFJzAu4p6PYwPnIiRmZnCImPzDsZvYRPDM+cR31/QgtH6abcwgYTAUr3qA4w/CuAg+H9oDjNG8iEVkx+rMGMHb0/fdFOokF1XujPdXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956600; c=relaxed/simple;
	bh=mkw0Zk1U/PZJmFipNN+5mGj/A0xBB+OhMZ70sysBvHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiO5hLPu8MqbdJ+hrkpqUs31pT/95nHIFas96d2frMDszNpZ4ONLV5U5YQmQ4xvapjUyeuKKAs9b+8ovACa29YF35cX7jRCqImyH8cv5TLl9mw8wexANZWAgOq2aBlH7HVhhnCD9bEHO1k9AnELSSXcmFKoeQzXkxAyk/fcSmYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqmRXflf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqmRXflf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46BDC4CED1;
	Wed, 19 Feb 2025 09:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956600;
	bh=mkw0Zk1U/PZJmFipNN+5mGj/A0xBB+OhMZ70sysBvHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqmRXflfdsONHxagK2Du6PvkOGWLPAhhajsuqg3Unf3Y8ixZL28Om4lLc5L+JhU55
	 xIBcRn60KlMw5pWKQ/CwGx6nH5ELPEyyOtyP4ptvMCLp6IWSA4ExQE0xpAZGgiOTKa
	 sWJ6n9nTrkXjtBF1kdABbTKvgR4rP9eHTr0yA/3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/578] kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST
Date: Wed, 19 Feb 2025 09:23:58 +0100
Message-ID: <20250219082702.249629827@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 992575f1e9769..886698a5afba1 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -382,10 +382,12 @@ int conf_read_simple(const char *name, int def)
 
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



