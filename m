Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B45B255F2D;
	Mon,  1 Dec 2025 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588783; cv=none; b=gJr00tPvCdqO8yods5LOCiZ2nmoVCMOZ18ADTus/6PpiIeASLr8MNTLXJarXTscgkbUSbvjQfSRbR/bluKv36AV4SAJqHxuMHOA3aT+NjBs7EQXlJIaoaD9awLsjusMAQPYCdiLkbAnGtYs4t3QuB0vTCmmWqYuBogR/BiZRdow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588783; c=relaxed/simple;
	bh=8WeuEmz3GjqJZ5w4t+UK5nPezIO9jgejjoTqTkZUVA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSyarsejO80Jl7kNjATP+j94f+OVSId8vj5sJkiCx6JnOJbMF0vdWbfObYeNoH3tMbxBUf6gBBWVqq5hTQ7cj43OzgcGt90feADJCt5eBauosqYPGiVRN169DWH4mrn0kQrcHDrIFmZy+mVFXcWBWar83V0DzFcOtcFme5SfZ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XT7jeAaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XT7jeAaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BF5C4CEF1;
	Mon,  1 Dec 2025 11:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588783;
	bh=8WeuEmz3GjqJZ5w4t+UK5nPezIO9jgejjoTqTkZUVA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XT7jeAaNw/o13EL7DO6NJmo30wRaFCldEa+q15i6+iZji0ipZlsRIEcF9lSBntzIn
	 GHhpXJScM/RhqOf+gIcNkKMjwiUXoiMPSC7gk3BRpf5r1HqgP/7IqbkAizSXIyDxrZ
	 GjBwXVDC+MUVxLEGa11zdrt6l/9IXcsGWhXpAWVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/187] kconfig/nconf: Initialize the default locale at startup
Date: Mon,  1 Dec 2025 12:24:38 +0100
Message-ID: <20251201112247.352306150@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Horký <jakub.git@horky.net>

[ Upstream commit 43c2931a95e6b295bfe9e3b90dbe0f7596933e91 ]

Fix bug where make nconfig doesn't initialize the default locale, which
causes ncurses menu borders to be displayed incorrectly (lqqqqk) in
UTF-8 terminals that don't support VT100 ACS by default, such as PuTTY.

Signed-off-by: Jakub Horký <jakub.git@horky.net>
Link: https://patch.msgid.link/20251014144405.3975275-2-jakub.git@horky.net
[nathan: Alphabetize locale.h include]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/nconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index af56d27693d07..7c126569e6cb5 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -7,6 +7,7 @@
 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE
 #endif
+#include <locale.h>
 #include <string.h>
 #include <stdlib.h>
 
@@ -1478,6 +1479,8 @@ int main(int ac, char **av)
 	int lines, columns;
 	char *mode;
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		/* Silence conf_read() until the real callback is set up */
 		conf_set_message_callback(NULL);
-- 
2.51.0



