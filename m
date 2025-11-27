Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E542286416;
	Thu, 27 Nov 2025 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255092; cv=none; b=De76EiNvwDk3a0PEMTvAZqdzizGMFAwTKt7ZKV/zqJ3i0QDnaU04qeDo1LBqUaFTL91iz/2imXLTbG+c5HW/vvGaqdzxIyB/7ANCMIY3hxwPQ3uwBiQex3soufJsjbK3gRIeItIPpwk4eqN2V0UbQ+z+EILJH6eDRsdU0EmhjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255092; c=relaxed/simple;
	bh=oq9hMvJYFoqMC0/5jd2bAWrmLN3QKz0U/GrZfAZ5sS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnZ6j1cMqzWmU9iqJI9C1dwldKi1CGwnF/L7WkJMfsOL6CULWV+eBy5RbBiWz9lArUrd7v/wEpaw30lTLBMLpp9yMjTKaXvpn0NV3MdIUcVQvtEi4Zoc6ADuFoBwBBaNk6Dpzxb258mVCYJ8SriupDio+FuFZ1e3lSdxkUsZ6Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjJXUoOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjJXUoOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2B3C113D0;
	Thu, 27 Nov 2025 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255092;
	bh=oq9hMvJYFoqMC0/5jd2bAWrmLN3QKz0U/GrZfAZ5sS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjJXUoOKLXHw/BHYmQqr+7w6Ly9orjjkU3MVJWgMOl07uSUDT3owU1AgHXxF/aIW+
	 gmwaGRLOAx5wQK/jSeejfOs3jlDsQHbIGXQ90DGE5ilNRbuoOB1IRCECb8vB2QrSTz
	 uShcEE8VeN0w0V3mVX5VxfZmuOCGJ0wmwSrcgLdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 64/86] kconfig/mconf: Initialize the default locale at startup
Date: Thu, 27 Nov 2025 15:46:20 +0100
Message-ID: <20251127144030.170568399@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Horký <jakub.git@horky.net>

[ Upstream commit 3927c4a1084c48ef97f11281a0a43ecb2cb4d6f1 ]

Fix bug where make menuconfig doesn't initialize the default locale, which
causes ncurses menu borders to be displayed incorrectly (lqqqqk) in
UTF-8 terminals that don't support VT100 ACS by default, such as PuTTY.

Signed-off-by: Jakub Horký <jakub.git@horky.net>
Link: https://patch.msgid.link/20251014154933.3990990-1-jakub.git@horky.net
[nathan: Alphabetize locale.h include]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/mconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 3795c36a9181a..2364140596c5d 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -12,6 +12,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <locale.h>
 #include <stdarg.h>
 #include <stdlib.h>
 #include <string.h>
@@ -1015,6 +1016,8 @@ int main(int ac, char **av)
 
 	signal(SIGINT, sig_handler);
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		silent = 1;
 		/* Silence conf_read() until the real callback is set up */
-- 
2.51.0



