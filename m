Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A42FD7C3;
	Thu, 28 May 2026 20:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998727; cv=none; b=DvrIap0POo7hWluUZX5qA2wGlcc7r39Dp92cnTFf5YauviS5Ldsqjea4jjlcas+flODzC6h94VOfrk+sF2Q+dCjajQdJgTVcxEmDDlEwR4CjK9D3Hg57LLQUTp5RLRGb7zXBMdNQrzcAFVanHJJXW88b1+6e/C84zirGS9Jot1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998727; c=relaxed/simple;
	bh=nr8dByGz4j0qFeOIejXRYoMzyY7vwBNreavPyN2rfIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRmqjs4uRL/kqkQI9eW48w6ldlA6G3d1kwBHVGo2c/USvsIrEK7Vvtp/REsatL6bKVbI8a0209rTDyQBzbYgegdk3sCsQR+vDevWP/nGKPS8D0AhjHeCG6lejLr+n6yCb7M5ZV+8Vu0PEMEjeUHGba1JYU5YAQ+CX488ZdEV3UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J680fNIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J680fNIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEAD1F000E9;
	Thu, 28 May 2026 20:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998726;
	bh=mAK2I5OP0i5w6W86kzqYW1qZh7GRgFNo4s28vhel3Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J680fNIe9lL3RdPZhG1DR3PeDGFI4v6eM6i0l8F2jOySCzKey7vOO4zrbBiRr29s5
	 QXLv/b+9Asi/78i1u6pnQKG+iAZWroExdrpi+9kNjLK+xP13f+eSUke3/GHdRmRI9p
	 3aoo/oVtfhb6BbzN02eDhnaLSZ0b65+uP+O2laM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 240/461] nsfs: fix wrong error code returned for pidns ioctls
Date: Thu, 28 May 2026 21:46:09 +0200
Message-ID: <20260528194654.091751112@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index c215878d55e87..fb0dcc1196699 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -266,7 +266,7 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		else
 			tsk = find_task_by_pid_ns(arg, pid_ns);
 		if (!tsk)
-			break;
+			return ret;
 
 		switch (ioctl) {
 		case NS_GET_PID_FROM_PIDNS:
-- 
2.53.0



