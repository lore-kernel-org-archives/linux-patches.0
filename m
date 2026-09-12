Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20901367B65;
	Sat, 12 Sep 2026 19:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242145; cv=none; b=gMT5RoNKHx8EFr3k72gv/lZG6oBBFdVsAR27rnUlMyYBBM6+vKgYrPyKe3dG7kz30TrwB91RWI8YvaYy+L3jN8jaL8CNQD5dkn4Asev4TaQtzGHhRxIrUxDEGzH6lXbuHyVoVkjn1Cy8GGhYRUNRmrMZHlFdTmFohXZOGoZA04E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242145; c=relaxed/simple;
	bh=JSWX0DEVyeKWwSSeA5uKpsaoMC5myki1parbs0yW88M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEjxrBwUNOelQGADgVxkFXxNvjkpxXdiVu1XcgwA51LuED1yl4267bPj3/SbwFe02KbRtZCagGBHJ7k1Kx3j6J4yk7kA5qdE8o4Rty5sn/X3RWCMzt9ZL9HU6z1bdEiy1/yUf6jBfc4Dn0ptdSWjtuh7FgMwzgv6NGyfbmVM4Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVfcs3z8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVfcs3z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDB41F000FF;
	Sat, 12 Sep 2026 19:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242144;
	bh=AWz4CDA/BX15NHP8jFn25Q58LKgiJzmO2BtmMc8NeI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zVfcs3z88ztNzYYqNVOZlnEjFr6KKVQsZy9No/qS5y3Y6yL7yKOcAc3cLx/q1U4Du
	 FRdsJMHtfPe5olluuBt4FeIwDBPozB33X8wQhPL8RYZR3uFC2Q8rsFSa/yg4PKMunK
	 bAWfp37cW7T/RUsHNnBJt9Wp3wm8nb1it1cYk4oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 302/798] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Sat, 12 Sep 2026 08:58:50 +0200
Message-ID: <20260912065524.084023290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit b7368687e3d11f51392d3c4774ec0263d5fbf31f upstream.

qla2x00_dfs_fce_write() called kstrtoul() with a NULL result pointer,
so a successful parse would dereference NULL and oops. Worse, the int
return value (0 on success, negative errno on failure) was assigned to
the unsigned long enable flag, inverting the intended logic: a valid
number was treated as "disable" while a parse failure enabled FCE.

Parse the value into enable and propagate parse errors to userspace.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-10-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -474,7 +474,9 @@ qla2x00_dfs_fce_write(struct file *file,
 		return PTR_ERR(buf);
 	}
 
-	enable = kstrtoul(buf, 0, 0);
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc)
+		goto out_free;
 	rc = count;
 
 	mutex_lock(&ha->fce_mutex);


