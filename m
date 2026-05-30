Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417463AA195;
	Sat, 30 May 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160166; cv=none; b=eQ6wgLUF+JGkMYN7dq8MbL3A8APd0uuGkUN6GxZlzqKzITOBUk2IcOLZbIavb/EXy2wYceiM3grn6BT8w+ZabyNJHJUHRDE5/B6C5Gw43tDnSGbiclRS5W97y+ME2vHXgydHxGbRSjI88Yz1qiWIOPx92lmDaz0LDGiD74OJcEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160166; c=relaxed/simple;
	bh=1dww9ixGLu3yL8/IMDJ8nU7cJX5ezrW6yNwpc3mkv84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egLlygXA8X5j0RbOD94etUNtyUC54m4BvCdY5yM/0Kg3YQyNVPqI3KZlPkqh4DSaHGo1bcU9dEekGKHdleHCreTQTqNYOva79WvGxe/+MRBR+HZBl49y5GkgD+TvOmZJ0hzr1YkTI19cEU0+ulv2pkB+FNhy9vaNxxL2F8s8Jtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n291KGsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n291KGsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0271F00893;
	Sat, 30 May 2026 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160165;
	bh=ewmOZDA2B7YE5LaRcM/ak8WhNg0bzDf5ZAH0JufRW3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n291KGsFl7cKbZdYb3QtNcqT3TJh3eQV1mTgG270u33sVYciL3Mj2OBoxQTczMtCd
	 T3M5rjitpvGGCC3F73cb6QfKw/X93JkFnHtMvE1lbTGlCU5lUXiDeg+VXFijaVJfi8
	 nvMCE0ctBOjo1EqoKKMMswssh3QJhLQz0D8xR9CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 262/969] dm mirror: fix integer overflow in create_dirty_log()
Date: Sat, 30 May 2026 17:56:26 +0200
Message-ID: <20260530160307.715557488@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 4c788c6f921b22f9b6c3f316c4a071c05683e7de upstream.

The argument count calculation in create_dirty_log() performs
`*args_used = 2 + param_count` before validating against argc. When a
user provides a param_count close to UINT_MAX via the device mapper
table string, this unsigned addition wraps around to a small value,
causing the subsequent `argc < *args_used` check to be bypassed.

The overflowed param_count is then passed as argc to dm_dirty_log_create(),
where it can cause out-of-bounds reads on the argv array.

Fix by comparing param_count against argc - 2 before performing the
addition, following the same pattern used by parse_features() in the
same file. Since argc >= 2 is already guaranteed, the subtraction is
safe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -978,13 +978,13 @@ static struct dm_dirty_log *create_dirty
 		return NULL;
 	}
 
-	*args_used = 2 + param_count;
-
-	if (argc < *args_used) {
+	if (param_count > argc - 2) {
 		ti->error = "Insufficient mirror log arguments";
 		return NULL;
 	}
 
+	*args_used = 2 + param_count;
+
 	dl = dm_dirty_log_create(argv[0], ti, mirror_flush, param_count,
 				 argv + 2);
 	if (!dl) {


