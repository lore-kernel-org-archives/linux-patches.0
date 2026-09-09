Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA37569F3E;
	Wed,  9 Sep 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962912; cv=none; b=l9Vi7KAD4yZ5+cfhDCxVDcITXlaXUDnHV/fPz5I4ZKFmaMsAs52OO8mXTgJgPmc/tcv3ByNsLOzbwpLaJm/hBUlMq3KyaC4FUuPuXH/Q2dM8aQZc+jAWn/a78FGG7q24NULG6POgs6awBUwRT42fN3lThLm/zQQd9wlJnNNwT0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962912; c=relaxed/simple;
	bh=BmFrpd1OzcQHp08GrkVFDsT9UnKGld4uh7Bu1EsxHao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdUN7lIyl3b20iMPsPxH5gQE1VjPtPfB6iLu/pj5+felSQx2khoUue65B4iNi6hVCs1vBwkWyAoFy1wNw1gT9mQcZdaC+08LozgGlMDWDzZA26CiXoCbdXE8qFoP+K64e2FYLf4eg65LxnSYkOIo1zuoZU9mf8BEYQSnamJWjvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5xanAQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5xanAQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D6C1F00A3A;
	Wed,  9 Sep 2026 14:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962911;
	bh=wHqLo86nXThoq5ypXuj+I//E2rZq7TGjnzH5WMOPaeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5xanAQiYg7p6J09x4wweivRP/NUWpwoA1TZ11dhGk1ce7g8eBuljgXXqypSo1mBO
	 wA+K3kH+2Mcfcl4iwOdQR2rK1oj+9aHp6dNCcqrGgTmmnx3xD7Y52ugdA3kbU+qwrL
	 l0qfQqOA7FYLSJg8MPKCQbwLGFr7Xg5DKUVOnTqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 432/556] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Wed,  9 Sep 2026 15:41:52 +0200
Message-ID: <20260909134245.800624421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -510,7 +510,9 @@ qla2x00_dfs_fce_write(struct file *file,
 		return PTR_ERR(buf);
 	}
 
-	enable = kstrtoul(buf, 0, 0);
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc)
+		goto out_free;
 	rc = count;
 
 	mutex_lock(&ha->fce_mutex);


