Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFBD1AA1E0;
	Mon, 30 Dec 2024 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573563; cv=none; b=VoM9eMN8fLLbZCrpS8AqBMwt+Zbqzk31FjGbTwjRXF+H6OaeV1tX++kc/y5P4M2HngJCZQAJoroo/4XbB7g+oLxrAINPZMifrpi/xXO1QrSsTG3YFb6wYjamKBNQBgONQuY4rT1RP9Kjhnld7OG8CXhA7ybndgvLBKywORthAfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573563; c=relaxed/simple;
	bh=sUGY4VJciUVgPulLt4Uuj8L3NoJpn/4WESWwf7Z7P8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFVtf8m2DebghHULULF102qeHlQ8pZynh8il70YRSx7xi8f5DWA7EEQURwaKvKwRS/PshFj9sINXatULBnRY1YSITFlUgayZi9RhfBudQ3FS6OeFSphxZI/diza7rjmuCvdQ9V90q1RnVghJ8PF3p3f5VJcDXVnGyfXnGmsW9wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpaqDyHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpaqDyHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03691C4CED0;
	Mon, 30 Dec 2024 15:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573563;
	bh=sUGY4VJciUVgPulLt4Uuj8L3NoJpn/4WESWwf7Z7P8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpaqDyHKaps6ISA97FPXnLpd2p1KuPf873uSPyTnb0ghA9uYTW5qsVJPmfqN8Hkb7
	 kd+uP81710CpAi/mgElQBfPMwvEXhbE43ubRYEUs8o6fJqhZQbXRDr93XGo2WRAmKK
	 kDUejnUYQpuH2xUFxRXbHP780dYmYjXK9UuDgrAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/60] smb: server: Fix building with GCC 15
Date: Mon, 30 Dec 2024 16:42:41 +0100
Message-ID: <20241230154208.464391170@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

From: Brahmajit Das <brahmajit.xyz@gmail.com>

[ Upstream commit e18655cf35a5958fbf4ae9ca3ebf28871a3a1801 ]

GCC 15 introduces -Werror=unterminated-string-initialization by default,
this results in the following build error

fs/smb/server/smb_common.c:21:35: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-ini
tialization]
   21 | static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

To this we are replacing char basechars[43] with a character pointer
and then using strlen to get the length.

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index bdcdc0fc9cad..7134abeeb53e 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -18,8 +18,8 @@
 #include "mgmt/share_config.h"
 
 /*for shortname implementation */
-static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
-#define MANGLE_BASE (sizeof(basechars) / sizeof(char) - 1)
+static const char *basechars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
+#define MANGLE_BASE (strlen(basechars) - 1)
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-- 
2.39.5



