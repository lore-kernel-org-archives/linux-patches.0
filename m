Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7EF2E285C;
	Sat, 12 Sep 2026 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222033; cv=none; b=FNPqF+Ug4esFMjbXAeEM4G/iQirA3etZcaPkMJ9ciR5m6n0+RKCFVR1qPAigmo/jyl5i9VpT69wZ1B1RgSQDcY5YOizMu+/3B0b8q1KamPqWx9TXmA8X4lwWQCjBC+LAuPEIZMB96RH5w1fIbp+mQKR4p6gGA2+AHDvIor6Sl/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222033; c=relaxed/simple;
	bh=LKaVx8kXU3NQ2z3Q2TPBKmcT50pTNkcH1w6WvdrBoRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5plWL9qs5/b3EAHO7GX3GxCa7PK6LqvQRSHMVG+qdfktLoM/Mbil2naBjpXmhFNyaJeaGsiHB4JK1BfPlgWcCrKqz3mSV26cTzcEYoDm9iggsF7JN4CwFp0suV6k3DRIKWZIpoIjnNovFXrLbpOzA1dKZpb1ntgOVBhlnolQmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9d5cUEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9d5cUEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9411F000FF;
	Sat, 12 Sep 2026 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222032;
	bh=9rcfvn/hcZPR2NVb/+dcT9YCO6CGu7zuoboJNmHen3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9d5cUEHa5dFaNn5vDeS6zQBc7+Q0WWxbvatKhvGr9w9T0agBIfqCPv0g2+sYLI+t
	 vPcAfCwBbHFRnwsXYyWF/IS/dYkOqOS1Ir5A7UeHK3tfZaAMYo7cwfB0epULmpi2xX
	 5qJwi82BJNnavCK8AxQ1Wlm0kjg8Wt+huthkxxOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0487/1424] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Sat, 12 Sep 2026 08:48:39 +0200
Message-ID: <20260912065618.194465992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


