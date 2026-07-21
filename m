Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5DD46A616;
	Tue, 21 Jul 2026 15:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649573; cv=none; b=rG0VGaAhewDK6R9C674gyCLleq0+LrFACOZTkb7krfozZsulj4xNvmOZnrPdI6oAhyunmfjDlMkKL5/z0Tz09Es1MDN/0MLo2YfEiOBHZ6FOmlPZnRUVu0aQUsY/Mi2RipTRvo35f6BHKdEs66UvCZen+aPRaGIv0uY6GDlHEHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649573; c=relaxed/simple;
	bh=fTrT051R3oYUjwa+i3JmOytUqVApfeb/fnx2c1lOcWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPvUMlR+tjFAyJ82/LQD5XIHDSIA4Hk48J2VN/ZNOZtjo/OTuO1pOmMucs6Jm+aN8j+BFW4REpcVZqJvWwWb1lgA9g3OSfyMWyoYPPPtLjsWMQltKU2EiaQxouZRK6tSnYcMH3/DVLgGvHBXFYPsX6g+wr/XEbv6PLYs0dKxwSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkzRoaWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkzRoaWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D958B1F000E9;
	Tue, 21 Jul 2026 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649572;
	bh=TEKmnubKFJNRnGlgImlsv3ZWaZ2a3bK+6XhIRHr+56I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkzRoaWG98OLZeKMXzpizQR7hSzMEBjf2oeQ7+VXdpoS+AmxVc56FuMAmkkpjcBxh
	 QTfhGvTj99aycT2EbnqqgfXu1eqg8ywpH9ignAdAzANHkygwvsHqr0x+azxOPWtMmv
	 wz9kF8PJkrvD4VnOCSd2vLLDPi8oEtKqKcTxGBZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0628/2077] vduse: hold vduse_lock across IDR lookup in open path
Date: Tue, 21 Jul 2026 17:05:01 +0200
Message-ID: <20260721152607.621282738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang Tang <q.h.hack.winter@gmail.com>

[ Upstream commit e440e077748939839d9f76e24383b76b785f80ce ]

vduse_dev_open() looks up struct vduse_dev through the IDR and then
acquires dev->lock only after vduse_lock has been dropped.

This leaves a window where a concurrent VDUSE_DESTROY_DEV can remove the
same object from the IDR and free it before the open path locks the
device, leading to a use-after-free.

Close this race by keeping vduse_lock held until dev->lock has been
acquired in the open path, matching the lock ordering already used by
the destroy path.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Signed-off-by: Qihang Tang <q.h.hack.winter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260508094659.94647-1-q.h.hack.winter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 6202f6902fcdf1..d5c34260ed68dc 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1637,26 +1637,18 @@ static int vduse_dev_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct vduse_dev *vduse_dev_get_from_minor(int minor)
+static int vduse_dev_open(struct inode *inode, struct file *file)
 {
+	int ret = -EBUSY;
 	struct vduse_dev *dev;
 
 	mutex_lock(&vduse_lock);
-	dev = idr_find(&vduse_idr, minor);
-	mutex_unlock(&vduse_lock);
-
-	return dev;
-}
-
-static int vduse_dev_open(struct inode *inode, struct file *file)
-{
-	int ret;
-	struct vduse_dev *dev = vduse_dev_get_from_minor(iminor(inode));
-
-	if (!dev)
+	dev = idr_find(&vduse_idr, iminor(inode));
+	if (!dev) {
+		mutex_unlock(&vduse_lock);
 		return -ENODEV;
+	}
 
-	ret = -EBUSY;
 	mutex_lock(&dev->lock);
 	if (dev->connected)
 		goto unlock;
@@ -1666,6 +1658,7 @@ static int vduse_dev_open(struct inode *inode, struct file *file)
 	file->private_data = dev;
 unlock:
 	mutex_unlock(&dev->lock);
+	mutex_unlock(&vduse_lock);
 
 	return ret;
 }
-- 
2.53.0



