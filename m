Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C1825783C;
	Mon,  1 Dec 2025 11:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588780; cv=none; b=qDleaT/hGxtfOou3eXCa5fK6eGKu/qfkL+J2iV0G+49w3IXIoHSUHg00DiyytqLthuE8NF0uECUDaAQKnCyaLKjpoZjvYkdRefr6VmtfUebUNCulPj76kJApXmu7P0lkDtmWLVKrfeiQugaNFDweu5VIEjSRggconEo/S/y//+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588780; c=relaxed/simple;
	bh=gCjLNC5syAzFvArPCYfyUyx1wDHtJoLYkYWT6O8OEkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbewoHEgw1VXcY6y6C2tHI4XG2jZbPC7CUlJjQQSqKKssVTtTT90z2wDmBrLp8pf0QSETC0BDetNB73CJuUI+9VdT7Nz0K0jxlTiOruBBCTV4mEZwQkIyslHRH2S9UQt9RR4elU92NNMR7oHoKg3fWimq1ND8tSDmKvSMZxBsFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yL6oDfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yL6oDfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465A5C113D0;
	Mon,  1 Dec 2025 11:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588780;
	bh=gCjLNC5syAzFvArPCYfyUyx1wDHtJoLYkYWT6O8OEkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yL6oDfgWq6O1wlOtn5AfYkbPrmJ4Q+fy08ZBZAg/ZcB9hQ65CR8EiwnVdXikb6An
	 w2qIE07K9OBizxNVPCVAzM9+DaGFTIkKq9cvzYVGZ4yETNqlBs74NoxBYB3WXhmh0x
	 5p/nbcpx6OwXuvi1KM+OeykVkuXOec6lslIameuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/187] kconfig/mconf: Initialize the default locale at startup
Date: Mon,  1 Dec 2025 12:24:37 +0100
Message-ID: <20251201112247.315908968@linuxfoundation.org>
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
index 49c26ea9dd984..fe57b4071e910 100644
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
@@ -1007,6 +1008,8 @@ int main(int ac, char **av)
 
 	signal(SIGINT, sig_handler);
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		silent = 1;
 		/* Silence conf_read() until the real callback is set up */
-- 
2.51.0



