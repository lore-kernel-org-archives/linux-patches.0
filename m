Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3EC46D2A2;
	Tue, 21 Jul 2026 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657148; cv=none; b=qvK77Vt0/W3bWaPK/MdjAjh5FqRwUbMC24PJ333qFJDkOOOKKjPOPcjbzGGErKhx/IdYQOUktV7guczkLStCSlBZzkYednJO/S2fpRzGlX4tY13ZwWJRHyInp0AwxJbds92FjrX9rhdHUuTtfSSAnq82XuC5A3vHpfzWD6WaX3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657148; c=relaxed/simple;
	bh=SuI3wolHTQBMejH+P34gNDCVbp6HV50C2OaOnVJQUlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K99/sh+qVCbvBZ8QCVwEsE1nIoETYfvle0EzO32z+BjjXtQl6os1CtYXNPBKzqiSpQtbWcKk3XotRIZxcPxriFxHpgiobefvNP0GvC0NstAy/9GZniJVG9DLiWA8WdC23z9arW80TWSfZE4sVSC9/02u5ICCbejRVJEMJiCe9qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o0o3JgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o0o3JgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9587A1F000E9;
	Tue, 21 Jul 2026 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657147;
	bh=evwkD4BMTAYyWAiaehcXvaYLGaUPsBorNmwV+PxJ7OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2o0o3JgT8rpcsub3i/nDNj2J3L0cE1X4KOfP1bvY4QwaBcQhNL88qVxbY8sDLOjuX
	 2qXjmnj9b44RwBqq4oI/gYO6JT6Ax+IbFuWCnZcv2An0WPw2z3QZF1NjD/oyfRx4VQ
	 jU4GkBZoQvJ1DvQ3VZ20x9/qHoSQBDHOWseVArpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0612/1611] gpib: Fix inappropriate ioctl error return
Date: Tue, 21 Jul 2026 17:12:08 +0200
Message-ID: <20260721152529.151043140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 70ea440324e8c1a10837f721352f5bd469c85007 ]

The driver was returning -ENOTTY in the case the ioctl command
was not recognised. Change it to -EBADRQC.

Fixes: 9dde4559e939 ("staging: gpib: Add GPIB common core driver")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://patch.msgid.link/20260411102025.2000-3-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/common/gpib_os.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/gpib/common/gpib_os.c b/drivers/staging/gpib/common/gpib_os.c
index baa2fea5ebf7e1..6bae025434e5cf 100644
--- a/drivers/staging/gpib/common/gpib_os.c
+++ b/drivers/staging/gpib/common/gpib_os.c
@@ -613,7 +613,7 @@ long ibioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	unsigned int minor = iminor(file_inode(filep));
 	struct gpib_board *board;
 	struct gpib_file_private *file_priv = filep->private_data;
-	long retval = -ENOTTY;
+	long retval = -EBADRQC;
 
 	if (minor >= GPIB_MAX_NUM_BOARDS) {
 		pr_err("gpib: invalid minor number of device file\n");
@@ -806,7 +806,6 @@ long ibioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		mutex_unlock(&board->big_gpib_mutex);
 		return write_ioctl(file_priv, board, arg);
 	default:
-		retval = -ENOTTY;
 		goto done;
 	}
 
-- 
2.53.0



