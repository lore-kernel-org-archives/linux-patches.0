Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6687E3BE175;
	Sat, 30 May 2026 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165831; cv=none; b=Cjcq6Qni9UrfFm/4ji6ZXWaXfd3eOOkKPhfKl6k/K7Laq7+awHCRIKbeh0hpGi9Um5S4V+SgQYgE9HhijHGDgYwStRFMZF3dlu9qptBtKFjDRydCeOwlvzmtsxJ/p08vBX4QxLxCWM1Quy1CRXoGv1AhgYJvxCcc0RIKSsL8fd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165831; c=relaxed/simple;
	bh=YH5ys/vdkTtQpXjwVkR+Lm0JdU11M3Od2/1plLvCOGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKtXqkgU6rIe6i9cKBX+f7IHESy4VFbFW1BBa76CSwqfzYzUYZme45o1SaZgIew+9msJ+ml5+E14RhSN81yfsQDTS/cUS1g62l5A1n84sSlJ6XoX7m3/F0/SBbP3vyqqP1dTBjksFlxspiMtFIoCFfqXMj32rlUXMB0cEKncb6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtLOlZ+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtLOlZ+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C461F00893;
	Sat, 30 May 2026 18:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165829;
	bh=Abt6f/S4dlZxBmQrA//XE+8n2wzWXdTa/s6Apo1SaDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtLOlZ+qRl0lJUy3mgabPH4wEoMCOJG4FW6tJB7owGFST/WNGbZSIShLYxiY/TAKx
	 f93WFUc4I5XdFjNhyNFG+0fhbpawiNuxRFZvwefgL4jep9FUy2YzPl5ohFvKftQ9xf
	 pfnW0vDBbW212DjVw9ezBj+kSuv5QzCTtDFcQAWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 194/589] dm mirror: fix integer overflow in create_dirty_log()
Date: Sat, 30 May 2026 18:01:15 +0200
Message-ID: <20260530160230.003067777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -981,13 +981,13 @@ static struct dm_dirty_log *create_dirty
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


