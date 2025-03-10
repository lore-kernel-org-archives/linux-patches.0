Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83F417CA12;
	Mon, 10 Mar 2025 17:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629103; cv=none; b=ZBmtG3v4B2rbcljaVlNAjOwLBrNqzPvsPogQUucW8xTDUz9s+1Q09TCYN8WnZ1Q3cUTCBA2LkX7GbGb+HollSB6OZEPAselxqOezlg7956KKvjm0TOs4YR+55OmvMYKxOZQzFS7iIWZiPdxkPItn92jdpXOOJUoqi3MbrdV08T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629103; c=relaxed/simple;
	bh=twfnwIJELsY2pYYOAyFtNCxL54+nm5J4zKNInH9RFto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHx4t1sX5o2EwW/hKoSXX9zGqZxFAYmy94egRKmoanxOqQZUmDjzsFSYVmMJqZg6pkwcDpk+wQWQwhA4fPLhz0Ym0biY1f8oijOViI1WX5V7SSbgQ4leLy+cQbuiooahBXxp92LWCDddxZMgnPPXG55EaloyIulRIFpkeIRPKLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQjni5IU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQjni5IU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F98C4CEE5;
	Mon, 10 Mar 2025 17:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629103;
	bh=twfnwIJELsY2pYYOAyFtNCxL54+nm5J4zKNInH9RFto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQjni5IUaBZY2hoawKISR6PxoDpJ2IUyo/lQPZs8k/E62LhassxvDShWWOd/kuQ47
	 QSn2ckkkv5Ra2H/LLxjZc6H3HlRO7gWuOkXyjFaZRSAk7WVwBvVE8o0b8IrUbkRvbS
	 FrZ/hxY+7pfZXE8+HPgHfh6M8hQuAeFwfpZ0oVCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/620] kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST
Date: Mon, 10 Mar 2025 18:00:23 +0100
Message-ID: <20250310170552.610178606@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 797c8bad3837a..469450b0a5176 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -384,10 +384,12 @@ int conf_read_simple(const char *name, int def)
 
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



