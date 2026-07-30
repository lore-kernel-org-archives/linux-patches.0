Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC96930567C;
	Thu, 30 Jul 2026 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426108; cv=none; b=gs92PZ6ML6A4UNoi432fvjAyznZJPWvRejFqWeun8+08ZWUK07Jy1wOEA3mv07hXDFtq0BQKuZfyKKjpEv5no2vtUP8rAoq62wTPs+KUTspAL6qU7DILxo90IV2owauXyX+dzl6BHnNQ4mMTLr3POzQG4QTlFVKPv59FNfKKOtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426108; c=relaxed/simple;
	bh=YlAFt1/qV/rok12aG8OFLVcXEO+O00rRtatezVehouI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2OJ1svw6HAA7J8LcLyzfDyJJ4mvMdbOWS4Dtj8InGW+FtpuLLbTploUHSUV+mBvcwO8emuT8cZKMGa4dm6WaHUXuSr0ZqxE7/JBYqkiz/VmpiME63Cmk8uahHQvVBvA53YjO4RieaoOXNG7y9F0LwKxmN2QZtH5yf0c5CEBjoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7ptkenf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7ptkenf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442DB1F000E9;
	Thu, 30 Jul 2026 15:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426106;
	bh=Q6bZgXzLz8Vv4jFtp6eXw5gAHr81Aw2b2auhYiJ53vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7ptkenfq+AsUSJj/cgKMV/RIWCtmMawRFEk5qKUNVqsakbgxYEmSFlZqhRaeJrBy
	 kSvOGMPorJDCgTz4cPpCECTCk5vXvS4kqZS5ORxJT7tB/1G4JVqWtMvqFBfEVZUtEr
	 RHHFOBe3z/fN0RZsGvt+jtW2XzF5IdFgtvP7Iyoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 303/602] media: cedrus: Fix missing cleanup in error path
Date: Thu, 30 Jul 2026 16:11:35 +0200
Message-ID: <20260730141442.336349382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

commit d99732334aaf33b9f93926b70b6a11c2cef3de39 upstream.

According to the documentation struct v4l2_fh has to be cleaned up with
v4l2_fh_exit() before being freed. [1]
Currently there is no actual bug here, when v4l2_fh_exit() isn't called.
v4l2_fh_exit() in this case only destroys internal mutex. But it may
change in the future, when v4l2_fh_init/v4l2_fh_exit will be enhanced.

1. https://docs.kernel.org/driver-api/media/v4l2-fh.html

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Cc: stable@vger.kernel.org
Acked-by: Paul Kocialkowski <paulk@sys-base.io>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -392,6 +392,7 @@ static int cedrus_open(struct file *file
 err_m2m_release:
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 err_free:
+	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 


