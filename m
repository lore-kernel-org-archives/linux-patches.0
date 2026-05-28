Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01EA1DE4E0;
	Thu, 28 May 2026 20:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000834; cv=none; b=jt5iNFVQ0HmI9RVp5Zc57X4uciaeR6en8npE8v/gyXBFwU7hV1+S4Cr8xcrf7ePxoWVjLD0COqLS1S4sBDf8jdIly4Wy+YYcNR/r3Rz8U3+YjySfYd+JUKxTapi/HzTWEiOR/63NoeOpdh3aw10Kxhw+IZ5+cCe+o8emgbCzkwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000834; c=relaxed/simple;
	bh=k8Kf4xIe3+B0Zbw3Ueo/GQowaNMMqtWGKh92y1Ek/3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1Sr7Wc1muycZC8apHGbpH323EmkhJWvy1jXIweYIdCZkiGmRKrWkWbLFwB4DctGgrkVtydfCFqYe1BfXEdvrXaVJMpb+/FFtSHVrnFlLGs146ErVEaEhbFNOG9rRr/QBNdA5AMx63sFzmhyQQJJw2dnYRsdvXu9l0wGCuRDKTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMqT+B0G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMqT+B0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2911F00A3A;
	Thu, 28 May 2026 20:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000833;
	bh=L7MCHnF+C9/oMBJY9JGAn70R2AXHR79KvTSMTBqh1Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMqT+B0GLoaCMCBf9Breks3o9JsgpVpy3Hh/Tei4whDuDaGfiLvn7TJbzNbO8DEfK
	 QBS+QbccWnECYxYKYpBqA/zkbPVS/ER3I0T3bssqWf913gEXcxSl2Ih3JeaQFXapxk
	 NauyuJgAPRlw9+hMx30VKpAojvIra5fnjq1Wlxtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/272] nsfs: fix wrong error code returned for pidns ioctls
Date: Thu, 28 May 2026 21:49:19 +0200
Message-ID: <20260528194634.465066082@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 725ecd80688bf3c57ca9205431f2c06174ff0756 ]

When executing NS_GET_PID_FROM_PIDNS (or similar pidns ioctls), if the
target task cannot be found in the corresponding pid_ns, the error code
should be ESRCH instead of ENOTTY.

This bug was introduced when the extensible ioctl handling was added.
Without proper return, ret would be overwritten by the default case in
the extensible ioctl switch statement.

Fixes: a1d220d9dafa8 ("nsfs: iterate through mount namespaces")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://patch.msgid.link/20260507112301.1042757-1-chengzhihao1@huawei.com
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 0f4b0fed9265f..eb232f5292f8f 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -235,7 +235,7 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		else
 			tsk = find_task_by_pid_ns(arg, pid_ns);
 		if (!tsk)
-			break;
+			return ret;
 
 		switch (ioctl) {
 		case NS_GET_PID_FROM_PIDNS:
-- 
2.53.0



