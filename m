Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2CD215008;
	Tue, 12 Nov 2024 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407688; cv=none; b=OKlfLDy5BruY1RiINQaSRjl17mFJtstAUMcdG16UIjPLLphN2ABgRq2LKNKQuTrpkEZgStnuGweW3UN5zafXafKyg0w7Oo6mZtIlOFnOkYVdQvpAbVKNDF2YhcPT684irZZvAliwhuXZBFcvqVXqiOiDrsDFtEM4jwzo/jK4Qn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407688; c=relaxed/simple;
	bh=tgJH/4gorlEWRqP5KEtx71suarzcLBJfbX5RM63zWTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dX1Z3fIWMT/chsti/NwQLHWVTEp8XEig9EG6+qLMlDa8OIDHpSrWAhrlGFfLWyVkaNOdS0N4qmHvGUgl/9GPuUnxMRWX43poQ5McMt4Nj+VqZ4Kk0rYxIIQoBobK4ctUFTbeIsaz7XlAsZsRuGVQzrWbh4quFlVVAz+aajU5yQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kETMYIFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kETMYIFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671F7C4CECD;
	Tue, 12 Nov 2024 10:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407687;
	bh=tgJH/4gorlEWRqP5KEtx71suarzcLBJfbX5RM63zWTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kETMYIFO94WIu9vv8qwkJ29TtXt3/M6Kgjqk+MPsKMff3+VnHzcTrJqJqUiPZ1Vyq
	 jWRh0DStVpaDQCHLa05KZlfl/ZagPd7KMm311cp0QNhzFIMzoDAZoiLaw89N5NLsLa
	 Zjdv5Nb1dC1F3tXY39JW7aWC5POJ20if18H2PGGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/119] media: dvbdev: prevent the risk of out of memory access
Date: Tue, 12 Nov 2024 11:21:00 +0100
Message-ID: <20241112101850.705862946@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 972e63e895abbe8aa1ccbdbb4e6362abda7cd457 ]

The dvbdev contains a static variable used to store dvb minors.

The behavior of it depends if CONFIG_DVB_DYNAMIC_MINORS is set
or not. When not set, dvb_register_device() won't check for
boundaries, as it will rely that a previous call to
dvb_register_adapter() would already be enforcing it.

On a similar way, dvb_device_open() uses the assumption
that the register functions already did the needed checks.

This can be fragile if some device ends using different
calls. This also generate warnings on static check analysers
like Coverity.

So, add explicit guards to prevent potential risk of OOM issues.

Fixes: 5dd3f3071070 ("V4L/DVB (9361): Dynamic DVB minor allocation")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index b43695bc51e75..14f323fbada71 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -86,10 +86,15 @@ static DECLARE_RWSEM(minor_rwsem);
 static int dvb_device_open(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev;
+	unsigned int minor = iminor(inode);
+
+	if (minor >= MAX_DVB_MINORS)
+		return -ENODEV;
 
 	mutex_lock(&dvbdev_mutex);
 	down_read(&minor_rwsem);
-	dvbdev = dvb_minors[iminor(inode)];
+
+	dvbdev = dvb_minors[minor];
 
 	if (dvbdev && dvbdev->fops) {
 		int err = 0;
@@ -525,7 +530,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	for (minor = 0; minor < MAX_DVB_MINORS; minor++)
 		if (!dvb_minors[minor])
 			break;
-	if (minor == MAX_DVB_MINORS) {
+	if (minor >= MAX_DVB_MINORS) {
 		if (new_node) {
 			list_del(&new_node->list_head);
 			kfree(dvbdevfops);
@@ -540,6 +545,14 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	}
 #else
 	minor = nums2minor(adap->num, type, id);
+	if (minor >= MAX_DVB_MINORS) {
+		dvb_media_device_free(dvbdev);
+		list_del(&dvbdev->list_head);
+		kfree(dvbdev);
+		*pdvbdev = NULL;
+		mutex_unlock(&dvbdev_register_lock);
+		return ret;
+	}
 #endif
 	dvbdev->minor = minor;
 	dvb_minors[minor] = dvb_device_get(dvbdev);
-- 
2.43.0



