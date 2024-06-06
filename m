Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6B21BE87E;
	Thu,  6 Jun 2024 14:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683551; cv=none; b=MzU6e3ov2M0jM/ckiXSycJ6bmZmKgGSqt/56+tiEjRh6TOevvv92bi889xjcyrs61jtre2OyhhXNpasRbSD/T7excCCfah1zz0uSLYVVXQ/XM+8VimYfR1LIUT65tAHrltG/OM8yXU0eM/Uzu+qcgu6KERFgzlltqdZeVOk20Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683551; c=relaxed/simple;
	bh=ra6w31LwSxgSaeuNaT+x8y1dkUHzd2jUcPmajFZxHDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEMPKebmgnKUjmHcCo5HdIfyVASc9hQY/QpN/f++fmrJRUes1Kjjlg+yjmVP/EqwaCnklyfN9ZirvzPGMi7p+hWny4A1I2l7qGGd7E+znBMEmlc+QICiCCOnzkygKny/v60glyClisgo3HuLqoxNNQoUipZqlMLJUtb7gBSaL3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAaYJQmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAaYJQmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8939DC2BD10;
	Thu,  6 Jun 2024 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683551;
	bh=ra6w31LwSxgSaeuNaT+x8y1dkUHzd2jUcPmajFZxHDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAaYJQmJqf6Cy91tGrZ7PjUXBW9dJPvVt0k2ebJqZtAr6kVQTq+stggKdVgMCDMBv
	 Nzm3KBZcYCgpYNMz0l+zfHN2s/tsgZfJXLdlUPi4OWL8jV7Y+gfrLse/QHcFNDk0es
	 Rt/ZIS4hb2g/wkysFfzXXhmNVL8cwf5nBt3ZZO68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 489/744] stm class: Fix a double free in stm_register_device()
Date: Thu,  6 Jun 2024 16:02:41 +0200
Message-ID: <20240606131748.131845893@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 534fbefc7f6aa..20895d3915623 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -868,8 +868,11 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
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
@@ -913,10 +916,8 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
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



