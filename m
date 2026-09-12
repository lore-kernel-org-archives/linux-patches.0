Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFFD34752E;
	Sat, 12 Sep 2026 11:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214077; cv=none; b=mIcPc2Bys2iUVqTOdgVTJdhuibyeN6lNhQji3oM6VL+mr+A0XaWeJ7cc8AwYaoP/tsQh7DOmBxqvhQXMxhgD24UBB+dCzNjAk5l6Xa87JNK+pZgCcHK5FH9Gp/FgPJ1ANt6uSxHggZT6oxnrFWtEMl7ZocpsC4XX5n4v41WN3gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214077; c=relaxed/simple;
	bh=tztKHIJ1PDAWsLkmDA2rzFyeflmyVh8yHxdzHD0A0KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fnf2uLCTDEFlez888ia7BmE9RBulbAZPeB/o+6TyYJyDY/OSZAtjrV2XB8BNIf1wiWowUhp42KQAG9MTgpD97rfxFQduFx4QEHNkrr33dvd+usEzu7V4FCLNR3pNKxQDqBCXlKJ3NnVX9wC8jAdonQPbmocmYhF2Wxow4NO6VGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2Ugzq2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2Ugzq2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374411F000FF;
	Sat, 12 Sep 2026 11:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214075;
	bh=IPFgSLL0IvYnlLcxfw6zGgeciqq6hFEAG+SBH+Md3do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2Ugzq2izL8cO68KN+1rbuID53hZbV4kP0KBk0is5mcMCI1PtfFV9PbsWzcarzDoj
	 avtWAbQWO/JVKiH+qBI5aVO2LEE3jn6T/rrnx8/56zK33NxRKfeqsxXJM4F6QEbg/c
	 r4PBxfBiLnYoKXqVo9YPZcp+E/GwWE6pkm7ACWB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 0234/1376] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Sat, 12 Sep 2026 08:44:20 +0200
Message-ID: <20260912065612.761269777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -518,7 +518,9 @@ qla2x00_dfs_fce_write(struct file *file,
 		return PTR_ERR(buf);
 	}
 
-	enable = kstrtoul(buf, 0, 0);
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc)
+		goto out_free;
 	rc = count;
 
 	mutex_lock(&ha->fce_mutex);


