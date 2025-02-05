Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D016DC28;
	Wed,  5 Feb 2025 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766401; cv=none; b=Pbe3fKxNrEiVNa4AvHwSe3iKMMNIRSGtGhDDWuJA3p/Tti/dQGbRI2vLfSW4afLKtqNPeSmzo5aOFDNWXbS2sc+9wPKd2BqKWa8I3h7YVukiprAlMO3EfCVD/vF8GEQ1oGQuUwbpTE8kByCyseiMXspzn0rhYj9B1+DcrtfZeM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766401; c=relaxed/simple;
	bh=oNmyMeYYwX777UQO22Lqk0nuIvO9GyybcFhlXCh2rjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unIAHpIeXG6bYVKVv9Agnmc3YlxQJO+gLKqLogPQX7y7kwvYKwxtUI0sPBTDyhvnx71HAF3/OUYcaxxcOt50doXOCsubzIZDKlYm5cTAL6qw9Z54ROmwvG+zLd1z7xZpOreywASf3ksHaF/YA4nzjltc8jGDq5aBRJNsSEEsQK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onjp9U1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onjp9U1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3DFC4CED1;
	Wed,  5 Feb 2025 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766400;
	bh=oNmyMeYYwX777UQO22Lqk0nuIvO9GyybcFhlXCh2rjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onjp9U1sal9B1Ky/9+QhcECTe1eurxMiVXmGQa3vf5yHc57V3Zh7g0FrYCvMldzQU
	 jBoNhf/1EuLC7zGW0ZdQM7qGA0h3ot4zaBeAtZHnvdK6plDTr6UmJg/ZNr//EQbmTe
	 CbFAssMvsnl6K9lGiTjHXqZj4Ph7jdhvH0y1NizU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 359/393] kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST
Date: Wed,  5 Feb 2025 14:44:38 +0100
Message-ID: <20250205134434.036200504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a6811d77d182..02ac250b8fe9e 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -386,10 +386,12 @@ int conf_read_simple(const char *name, int def)
 
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



