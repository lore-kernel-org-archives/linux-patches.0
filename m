Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88E31EEA4A;
	Wed, 12 Feb 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393693; cv=none; b=esK6o33jXQnh+WMt6MkUfopH9OFkwTWHFFXThjDRo/Ok0ZTyzjRHxHOa+PnDXbMXB5o0KR87fmsbSMbzLqftWXASSJOW/td9IwYXivMj+Ggr8pphIW0wAvr/VDUdN9izq19r7hVin3dfjWywV7K8pz0mf2GVBDm5E159rPEEi3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393693; c=relaxed/simple;
	bh=k8dA5lKb2/vo1cUKP/hBBEJjebZ/4e1cGMp4Wi309JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvTpZZBsZTCJ5qSxJG6R/0AF2QkfrPER2a2qB/vjuAMJ68Bi/O4BRdMwLykbQi4USBbYagYYiER1HuG2n34+TSzjz/yr0RA6pQJhPRLfnOLCBfnfiyUXlDpWZS9r5hzZXNNkRXcxIp/xQCKWi7X91nXXToPOpE/ZknKxNDC81tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OsTi6j38; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OsTi6j38"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LD/vmeHNDlK4DCwLOI57rae7DeHYYbFNDQgh04JcWTA=; b=OsTi6j3878fwSWHjFVZ2AAQJda
	2YTNoTkf7xJVB9jaLnqMm42k37B9uxKgLaszcEF1w00FlQjPYxW4R0HCIp7zu4HYQX9GvHNkyg+5M
	uup8+Xt9NvrgtLtE+Q1qGA43aSj6ijXRd7lnDvRZOVbxnZGsxn4/k2a2bgkmHozs1aihk1FRadicP
	WXz60HP50+Qkm+jKOy31uQiYgHcrRn0azzzkYNJHzyEZyUQzkykuWsnPjuFO1/DMLH3VF7eUdCW/b
	jWq5a9ggyZHHp+zRwsk5UceBFLVH6uWASv/ffrb9TgiCGrex10Uyvoz+QWY3hLQogUD3Aja01Z+lb
	HLAO0Zhg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiJkw-00000008q87-33ti;
	Wed, 12 Feb 2025 20:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v3 1/6] common/xfs: ignore first umount error on _xfs_mkfs_and_mount()
Date: Wed, 12 Feb 2025 12:54:43 -0800
Message-ID: <20250212205448.2107005-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250212205448.2107005-1-mcgrof@kernel.org>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

We want to help capture error messages with _xfs_mkfs_and_mount() on
$FULL, to do that we should avoid spamming error messages for things
which we know are not fatal. Such is the case of when we try to
mkfs a filesystem but before that try to umount the target path.
The first umount is just for sanity, so ignore the error messages from
it.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/xfs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 569770fecd53..67a3b8a97391 100644
--- a/common/xfs
+++ b/common/xfs
@@ -15,7 +15,7 @@ _xfs_mkfs_and_mount() {
 	local mount_dir=$2
 
 	mkdir -p "${mount_dir}"
-	umount "${mount_dir}"
+	umount "${mount_dir}" >/dev/null 2>&1
 	mkfs.xfs -l size=64m -f "${bdev}" || return $?
 	mount "${bdev}" "${mount_dir}"
 }
-- 
2.45.2

