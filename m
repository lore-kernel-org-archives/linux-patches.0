Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26256385CAD;
	Tue, 16 Dec 2025 12:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888643; cv=none; b=V74ZWX6Gh+W3n6YIIgHjI9hcZDQrd0o/CqJpk2ucDCuJNSjl1OHrYWyviku+WNVmPRu6IA9neeiYPoS1vjSMPE3dpPzpkvndn8q18ZhFmTtvQ70HojMD1tEUbBmq8hcVxd5F0+L6CmL7MvUwX9Q1L6XJEq7h433/Ue56kkwyOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888643; c=relaxed/simple;
	bh=pO1Itp7jeP1tlQGHyxAH/jQhMCpdvdW9y2vfsmYgVcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0OctLiDRNpzto9cZ6VlPuD2zrWm9+HM0EdR0h+/hJ2OgAO3YH+ecZBG4VrON70ZBhYlAAMX/IhVQnkcqbsVojft4IQeB43djs8dfKKmFqLoHmdfDUZvYn5/nnyUTadxYCzWsvdjBNZTQt9gC3pZSAoxioyTa6zkEUaobH5vVSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KO0nXi6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KO0nXi6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C94C4CEF1;
	Tue, 16 Dec 2025 12:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888643;
	bh=pO1Itp7jeP1tlQGHyxAH/jQhMCpdvdW9y2vfsmYgVcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO0nXi6CiiUMTIk8OCKnfwOR42vdwBVAXpPcq7JghihqHVJcPVU0/57nNtAp/r/8k
	 Jdq/GV1Fuym07ZyKGypqfV/a+Kuomg5HDXpCftgaFmVFctt5fPgdfu0//XBqo62SZL
	 bahUnuzXShruySghieZVxl0SneXSU4PLfZIe+NmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 593/614] dm log-writes: Add missing set_freezable() for freezable kthread
Date: Tue, 16 Dec 2025 12:16:00 +0100
Message-ID: <20251216111422.877112139@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7bb7174f8f4f8..f0c84e7a5daa6 100644
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



