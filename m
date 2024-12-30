Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE26F2AE68;
	Mon, 30 Dec 2024 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573805; cv=none; b=MhklIUVilAyvTmQKyhzObzGjo4oh/nqJpwrqNJf1PblIS9jcBhPHrqnijprTwPSM9v+i6rcrYiLI4klumNW7w74olAe6IQP5dyA5Ycovov79G7bIbyebC9KR6GqHvkD5o4BibKyi95qg+MUGiau0qBwT4cGVvxsqWpKVuQwOSgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573805; c=relaxed/simple;
	bh=OT1HJaZAQPNKwBcxEK0A1tXThEKV68kPi5ijI/w0QSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsxUQ90ON6xBZUbyvz/+5VHXisD43TRC1MJS1EGzlURGHuq3ANbJjm8SJgVqMXVrSQphuZ6no/L/8FdWet5W1xoX8vdPG7Uibka6fO7Xzxfx6PUAbHLQpQ/XRoO6cHxa1zWg8ScZXCCE8qBTspflgQrNRWJvd/zd0oXofyBcekQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3eEEibr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3eEEibr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6E3C4CED0;
	Mon, 30 Dec 2024 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573804;
	bh=OT1HJaZAQPNKwBcxEK0A1tXThEKV68kPi5ijI/w0QSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3eEEibrI6s3IcVuxwHITvegEVxGZUuIzblOaCMXWmy+Izm7Z/LfjyhVC5iLD4IRX
	 5uE85JsoZscGh5GyUpbCUcpLccZ6I6rs09LWEJFHrYTwNaVb5m65U7KdNGwKCl42L3
	 J8nTDzjrgrn3ZOUj9lIHKILl3DgvuhoNEhkXUPAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 39/86] smb: server: Fix building with GCC 15
Date: Mon, 30 Dec 2024 16:42:47 +0100
Message-ID: <20241230154213.203214595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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
index 663b014b9d18..23537e1b3468 100644
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



