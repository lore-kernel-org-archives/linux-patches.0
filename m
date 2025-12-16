Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645CE3314B4;
	Tue, 16 Dec 2025 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884922; cv=none; b=rKUS2QJo80DhFz2kQbXFeUw7AsrXfIPWA5ch+lIYat/v/uKlHHmaYQk1D2B/4TOwt6sZDb9y1VN6WFHscG+VS26DzQgULsRtodo5l35WIy7wOVzpZe9Tq5G4dYNgnHyzgXKL3j5/oVh4DyH5m4hPXHRkpgleb/+Dc92s/Pe40f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884922; c=relaxed/simple;
	bh=wUU/oz+FS3i/gUCcBa3fd+FtnEwKxlICEBIXccn2q+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSHaCB2TsQ+jaJfZTEgiNeUlTZGrEOgsY6cFSftBu5GoHn2NSZJ30cUPibxRAnx4CLnZ0v7eVQXwU1zyXVQ0VcrvWzqdJsqN5ef4TSkt+RlXZUVHkvUsSUh9O5ncYUSGK0Z8Qffm+2LByi3eDeodpEr2T2ubAQeJ7POHnfQlcsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cl7Afu6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cl7Afu6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FE6C4CEF1;
	Tue, 16 Dec 2025 11:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884922;
	bh=wUU/oz+FS3i/gUCcBa3fd+FtnEwKxlICEBIXccn2q+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cl7Afu6S9isxYHAbLN7B2kUxSkLgmuNVAOITE9K5nPUrjJ8Yn1l73rHWFi+5HwKBo
	 l7Gu5ZqCLgLUJ7ra6AlTusdzP7MltagZkGWD/GVb8oTVWE8th/OCSITVQjyV8I/NIh
	 kATAN941n356m6f3LUL3+PDpl7u1DqLjHZZhx+4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/354] dm log-writes: Add missing set_freezable() for freezable kthread
Date: Tue, 16 Dec 2025 12:15:06 +0100
Message-ID: <20251216111333.189129123@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit ab08f9c8b363297cafaf45475b08f78bf19b88ef ]

The log_writes_kthread() calls try_to_freeze() but lacks set_freezable(),
rendering the freeze attempt ineffective since kernel threads are
non-freezable by default. This prevents proper thread suspension during
system suspend/hibernate.

Add set_freezable() to explicitly mark the thread as freezable.

Fixes: 0e9cebe72459 ("dm: add log writes target")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-log-writes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 8d7df8303d0a1..6272c77184200 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -432,6 +432,7 @@ static int log_writes_kthread(void *arg)
 	struct log_writes_c *lc = arg;
 	sector_t sector = 0;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		bool super = false;
 		bool logging_enabled;
-- 
2.51.0



