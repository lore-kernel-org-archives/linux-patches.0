Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39CD44C8C;
	Tue, 27 Aug 2024 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770224; cv=none; b=OnuMyP5vwYolz9nOIZ14FkqiRTDmW4/Ttg2+PJSCh5L2fTal5GPwNDzDqRVphaOMHbGLplnk+5sIiXFfjJVcgko0Z5F4GORBCJaG6qQ3rXtLCtBFManelEPvoGrHw2pWh8uONGOguhcQKl4QCO9ncFiQ0yeHYsYPQAahtzTG5IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770224; c=relaxed/simple;
	bh=eKDPRZcr0VKdN39Nu+pqIL5T31r83PG97rgcRaoqMGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkhpKsESlmJY3ERQpCQpJV01/uUTngr5uIhWmQu0vTwxtRmoYK1WJeX+Y0WfI3Hkzw5trYGT5VraHrN8wJPNzcaFZMPppqLhlpPTScslO2gbqm0/kXGwKT79ooORys6eAmXQRTjZ+fEeGtnhPjES3bLOnn2pWq3Inl62J74CDeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7N9XY6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7N9XY6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C255C4DDF5;
	Tue, 27 Aug 2024 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770224;
	bh=eKDPRZcr0VKdN39Nu+pqIL5T31r83PG97rgcRaoqMGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7N9XY6LpM7yYpXZ629rPYq/iomj/8bdese7GcL6tRfeQd8TcVY3Z5MWYzqI1nkcg
	 7dVBkSOEMv49A80Rnk05qZxSgq5PYhfWLGhY5CylfvY7/BhKlo+fk2hLHdQvqakhgo
	 yF0Js4vY3ol6i2XK/ZEgKL60fvNIDmfdnjgFf75U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/341] media: drivers/media/dvb-core: copy user arrays safely
Date: Tue, 27 Aug 2024 16:36:36 +0200
Message-ID: <20240827143849.690354776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit 102fb77c2deb0df3683ef8ff7a6f4cf91dc456e2 ]

At several positions in dvb_frontend.c, memdup_user() is utilized to
copy userspace arrays. This is done without overflow checks.

Use the new wrapper memdup_array_user() to copy the arrays more safely.

Link: https://lore.kernel.org/linux-media/20231102191633.52592-2-pstanner@redhat.com
Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 9293b058ab997..93d3378a0df4b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2168,7 +2168,8 @@ static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		tvp = memdup_array_user(compat_ptr(tvps->props),
+					tvps->num, sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
@@ -2199,7 +2200,8 @@ static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		tvp = memdup_array_user(compat_ptr(tvps->props),
+					tvps->num, sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
@@ -2379,7 +2381,8 @@ static int dvb_get_property(struct dvb_frontend *fe, struct file *file,
 	if (!tvps->num || tvps->num > DTV_IOCTL_MAX_MSGS)
 		return -EINVAL;
 
-	tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
+	tvp = memdup_array_user((void __user *)tvps->props,
+				tvps->num, sizeof(*tvp));
 	if (IS_ERR(tvp))
 		return PTR_ERR(tvp);
 
@@ -2457,7 +2460,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
+		tvp = memdup_array_user((void __user *)tvps->props,
+					tvps->num, sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
-- 
2.43.0



