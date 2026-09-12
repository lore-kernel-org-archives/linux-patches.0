Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D38142885F;
	Sat, 12 Sep 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228512; cv=none; b=cUVyDXA2iG2//SH8zOdJPzaA3nKxvWG+si9eQio6/TH4VR7vCiWOROkIddAKw3U/lPiOZeuDQ8lv1N6clKfbZfzdFQRmNDllTwzWY7OkaEnFB3QeMxbguhWNnSRrjcxbg5j5SPpFNZWTJbyeyvmH4cCStBJ7NR5TV7USl/4LUIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228512; c=relaxed/simple;
	bh=p2itVR+O3fQCVngJETXg8VXiPlof1vA+ByVxbnF73J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUD7HYufd9iOIEIVnBdi3lg1DsdY8naaM+XTUZSv20eSZA1x/5Oy0LD/9V/gajG1EjCnny4j1W7k0HkKOqd8N8UFRW37h0nkkyfbMJK+rlzmXAfUe9w7UC8xgodlMx4Om5aCg8Hqnz14R8OvYiWuQAX4l/QCYuz9FoRDqoTgjK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HODom+DY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HODom+DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6FA1F000FF;
	Sat, 12 Sep 2026 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228511;
	bh=SNL6iDjlFTi5XU7kpV+aSaM4B43ro9ssSSxK/mR/GGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HODom+DYcFFHXHpkMtkAJESCQBrHI/gWhpuqrEvTaz7w3WLaY59lfDMKt+10zUph6
	 v2sFQA7NBOOAIEh34ER7egX5yRgZYAlEoS7XXOQ94uxY0/ojavGd/OmjiJCEfiu5ps
	 jXpCaeklOK2xZgEVCJ/LOIYLeMtg4nkyOT2W4KIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0400/1191] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Sat, 12 Sep 2026 08:52:08 +0200
Message-ID: <20260912065557.223706494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


