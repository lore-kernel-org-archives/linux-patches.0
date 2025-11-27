Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66D232E130;
	Thu, 27 Nov 2025 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255095; cv=none; b=sF/0GxRy8UeKFqYkgJFQW7sW5G7uGF4tz+AVuM0jUieTh9ZgH65P5K5mZIuJt2GYylrOxpmbQ4U7IZFFdGRZZprV588Q5pYpgCZtRmJzJXOXafOeMJO8l8EwX4fvj2shI8n6AxUdz1IzQHQD5IlVz4xwb6QLN6OpUeLUnO8ID48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255095; c=relaxed/simple;
	bh=/nC5nkTNmDGiQ5+FdGdE54TD7ql+hETFuOE+TkHyzQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LgJcqrBwBVGuIuuuBH5Tef5JxBlnql1t4B5FTYIb0LBDgnVYpEjm6goDdoBqFR4sVrR+mN5Gp24usKbzLvqibS3NNvD7eNuyR/xA+bSA8t76hMYRWYeWl6wrrmtDfLsJDgMHJZWoK2yVl4thCP19LFqFOFMmzaJnyMJlhZvj7c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YReW2CS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YReW2CS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3DCC16AAE;
	Thu, 27 Nov 2025 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255094;
	bh=/nC5nkTNmDGiQ5+FdGdE54TD7ql+hETFuOE+TkHyzQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YReW2CS43yGkBjaVvUUogNx1K5FNoGPro2dOjX5+FLQPBaEVl+GUUMPHiFFXKrmMK
	 6h9YRDv86+YTGee3GeJoYLE9BJ2evossnZd+hc7+roe/Qq4+Py+W+2GSP20R4/4YY5
	 o9sP3Dv/Nru6spiedkh5h9fqSkUchDSZDwQngzTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 65/86] kconfig/nconf: Initialize the default locale at startup
Date: Thu, 27 Nov 2025 15:46:21 +0100
Message-ID: <20251127144030.207799985@linuxfoundation.org>
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
index 7a17c94a15941..a7cfa6813c63f 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -7,6 +7,7 @@
 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE
 #endif
+#include <locale.h>
 #include <string.h>
 #include <strings.h>
 #include <stdlib.h>
@@ -1569,6 +1570,8 @@ int main(int ac, char **av)
 	int lines, columns;
 	char *mode;
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		/* Silence conf_read() until the real callback is set up */
 		conf_set_message_callback(NULL);
-- 
2.51.0



