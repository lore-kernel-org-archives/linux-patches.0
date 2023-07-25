Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244AB1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0A9C433C8;
	Tue, 25 Jul 2023 11:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284266;
	bh=bjrSqabvemZeQb5iQWlfFvOhWAbQi2nX3Esbd/KhKbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6cJQ68Tlf+WJIW/9rcD5WjjXAZUOTZvVLY9xFFDn+GQMIFYuYeX6Lt/22sSCPLZF
	 sEMyq086hCe1kjvh+bxEdEpXD1Ya5T9OZnSnC6Xwu2uZhuQCSP2YwEIZt7F3/O8K0P
	 KBXueanIYxTYFJlFRoOAqp/oXO4d6aUJOEI02tL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 295/509] fs: avoid empty option when generating legacy mount string
Date: Tue, 25 Jul 2023 12:43:54 +0200
Message-ID: <20230725104607.251437580@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

commit 62176420274db5b5127cd7a0083a9aeb461756ee upstream.

As each option string fragment is always prepended with a comma it would
happen that the whole string always starts with a comma. This could be
interpreted by filesystem drivers as an empty option and may produce
errors.

For example the NTFS driver from ntfs.ko behaves like this and fails
when mounted via the new API.

Link: https://github.com/util-linux/util-linux/issues/2298
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Fixes: 3e1aeb00e6d1 ("vfs: Implement a filesystem superblock creation/configuration context")
Cc: stable@vger.kernel.org
Message-Id: <20230607-fs-empty-option-v1-1-20c8dbf4671b@weissschuh.net>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs_context.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -543,7 +543,8 @@ static int legacy_parse_param(struct fs_
 			return -ENOMEM;
 	}
 
-	ctx->legacy_data[size++] = ',';
+	if (size)
+		ctx->legacy_data[size++] = ',';
 	len = strlen(param->key);
 	memcpy(ctx->legacy_data + size, param->key, len);
 	size += len;


