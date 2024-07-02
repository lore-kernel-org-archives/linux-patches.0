Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7F81BD51B;
	Tue,  2 Jul 2024 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940093; cv=none; b=APjNB9GFetZXiNfkt8+Db0HY/Wz6Uo2tWUEZltuRXoPysPRg6Zzr4wriyehhFe3Gt7lfdjhNmKqeGEvSKtRY7lNjCV7TLtW8cQKa3/+IuIBqBVGbL3gZXo5AG0aEyGbAGw9cCNEDRAFiOZDxWpoQMXZY5YM4PM2l07gxGv6EW0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940093; c=relaxed/simple;
	bh=mvyHow1Ej1gdW3lPZv4WHGWvADHCR3WawiU1hO86UJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGIaPj5SQ/EaOEegdUXjNasWboRjoXTpB+lEdSpxAx+fShC5xboCgI7QZovvDhcj3B7sNiBzDsghCFnfKxvJQJYQUrG+s+NdpE7YXBF2OpIHPRnjAI1ggclqm2Qc/mKmkJyNDBDSXm8ORBcoUaFrgUe28Zb6M2FbXyUC0Sthlag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyjWl5Yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyjWl5Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A794CC116B1;
	Tue,  2 Jul 2024 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940093;
	bh=mvyHow1Ej1gdW3lPZv4WHGWvADHCR3WawiU1hO86UJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyjWl5Yxa/1cgpuYYnC22EAsWs4Zl4sCcGbs1kFylNTJMrj8cEv11rWu3L22f/NPe
	 9RirpNgIhXCOosw2uFQylGS+AR9Qv6sNnJRtqVusCuKBAdQC0ElHuPSnYSqMxARNiI
	 KzBPAH5UgZRuPF0YpP+pg2erB4FDmtoos790dU3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao22@gmail.com>,
	Audra Mitchell <audra@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 019/222] workqueue: Increase worker descs length to 32
Date: Tue,  2 Jul 2024 19:00:57 +0200
Message-ID: <20240702170244.710804755@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenchao Hao <haowenchao22@gmail.com>

[ Upstream commit 231035f18d6b80e5c28732a20872398116a54ecd ]

Commit 31c89007285d ("workqueue.c: Increase workqueue name length")
increased WQ_NAME_LEN from 24 to 32, but forget to increase
WORKER_DESC_LEN, which would cause truncation when setting kworker's
desc from workqueue_struct's name, process_one_work() for example.

Fixes: 31c89007285d ("workqueue.c: Increase workqueue name length")

Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
CC: Audra Mitchell <audra@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 158784dd189ab..72031fa804147 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -92,7 +92,7 @@ enum wq_misc_consts {
 	WORK_BUSY_RUNNING	= 1 << 1,
 
 	/* maximum string length for set_worker_desc() */
-	WORKER_DESC_LEN		= 24,
+	WORKER_DESC_LEN		= 32,
 };
 
 /* Convenience constants - of type 'unsigned long', not 'enum'! */
-- 
2.43.0



