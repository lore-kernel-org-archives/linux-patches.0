Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1364908A9;
	Sat, 12 Sep 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237880; cv=none; b=FRq38UmkTzc8/eZpxmT+2P1UuMEpscsH9lu41cFsFMlJOHIBS20NA3IRY2ZXVdBKsLTEEwcKKL73GaB3xsOvGun9K1RDKUXkl+5D3gsAYhwFdrnOpz2thO97A1mKRlvFbJ5+h66JzIUcA/0IF1Ry9A/2rIuKrNjdDxhwqDwxwP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237880; c=relaxed/simple;
	bh=bPZc/+S9vXrsYcJdcvxspQmfgNry68WSG6s3SJupjF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJ2fRv+2uTeCRXi5CMvQnpKD16ULrHO/yg/RbCg9DZIOoyryttJYHNXCyAa4kk62yEc7yjaM2IJgnngoyPmX9yM6e9WF9i7LLFBM2jq6VWUAflgCIRkigUbyNBwnAo7BhKC35mH/DB3m5NxFykhuaDsuye3pN+odZhoUXM39W6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIZT+0Yi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIZT+0Yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65D21F000FF;
	Sat, 12 Sep 2026 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237874;
	bh=stOPzw8UZustHavk/8rks32hAL8hLTR9q1OFj9vGM2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIZT+0YiLpNhKeXDQPHc9DiGdTXSkJAJnjbq2KhRzdsPDo0MKFB+Nzd02htJV21gv
	 2inrVpADatCGPY6odUzqYS3tmOjGcNU9XlGqj+2kTv6v2Bj4e7ssRpVkDpdj03K4c/
	 yaSargLy4pIDBsJZugiv+DrxZh+eMj4dwMGVz2+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 345/935] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Sat, 12 Sep 2026 08:56:15 +0200
Message-ID: <20260912065534.718856445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


