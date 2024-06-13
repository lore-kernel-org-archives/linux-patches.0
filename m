Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F205143878;
	Thu, 13 Jun 2024 11:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278879; cv=none; b=cQv/ppXtrMR64ndkJAB52agDx5lQcZF1KUIju4/kzkdfTFEgcnm6zd8L6UX1jNQ5s0s3sP5yT/5yuka3xul6cYYv7gVsICQAmGM6f2QLQo4pddD8HXRRTKeDkymYeEa527jXbDwdk/RLCahhNNl1I9O4dbv+w4WXO8lxWsR14GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278879; c=relaxed/simple;
	bh=9Q9dj0K+2hLo1WZLoODXN5zcc4nbb3ZHV8LPJYrIrJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKJLiuwobI3YU3Hou34cfx8Rzi9mCoEfYSCJCKxC3us+E5fFkowhQm87420SixbQJEQMneghYpvkTrNKrC8wzR72P5cJjyjnCYG0CJAI8AcSj2xkpGALRPbSs2qKgVb9VALxsyVTWQamNTHo3laXTkD7a+q9yw7Y+F7WdfAFQoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yq9YLGEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yq9YLGEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FB8C4AF1A;
	Thu, 13 Jun 2024 11:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278879;
	bh=9Q9dj0K+2hLo1WZLoODXN5zcc4nbb3ZHV8LPJYrIrJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yq9YLGEkPrhF8rJOeifCic6/L6w8ziUQIiAyA/He0tPISd9OBkp0VATA274GAt8/4
	 Ii7dEvbZj78ZFgViA0je1YNIvP2MxqKdr/ZEdVELaT8uw4LmK9FfPqZIYlJ4I1CZhS
	 Ng/ATRR3IzMkODw8dfrupt87jFgv6hVNGxx7/6KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/213] stm class: Fix a double free in stm_register_device()
Date: Thu, 13 Jun 2024 13:32:28 +0200
Message-ID: <20240613113231.864558877@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3df463865ba42b8f88a590326f4c9ea17a1ce459 ]

The put_device(&stm->dev) call will trigger stm_device_release() which
frees "stm" so the vfree(stm) on the next line is a double free.

Fixes: 389b6699a2aa ("stm class: Fix stm device initialization order")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20240429130119.1518073-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/stm/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index eeba421dc823d..9bb85d20934a0 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -701,8 +701,11 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
 		return -ENOMEM;
 
 	stm->major = register_chrdev(0, stm_data->name, &stm_fops);
-	if (stm->major < 0)
-		goto err_free;
+	if (stm->major < 0) {
+		err = stm->major;
+		vfree(stm);
+		return err;
+	}
 
 	device_initialize(&stm->dev);
 	stm->dev.devt = MKDEV(stm->major, 0);
@@ -746,10 +749,8 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
 err_device:
 	unregister_chrdev(stm->major, stm_data->name);
 
-	/* matches device_initialize() above */
+	/* calls stm_device_release() */
 	put_device(&stm->dev);
-err_free:
-	vfree(stm);
 
 	return err;
 }
-- 
2.43.0



