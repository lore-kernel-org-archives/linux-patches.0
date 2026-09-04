Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98385415B76;
	Fri,  4 Sep 2026 05:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498526; cv=none; b=YYlPB29BbWMpkKo9wzZiXK+cVolcm8Sl6KCMxYPtoP0nESC5OPuN3cjMclE1etyLCyFytYvNJGAr7F5c+r/rk+gAYkl1gD9YeHrVzdWMfNSvER9IYLlRhjZvIYuKkCkuWDlRc1b9IPvlb4F7R7YHxvXalMRaqI67OHQkrTxScSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498526; c=relaxed/simple;
	bh=t8s7IVenwWfjqkn5dcwh1cYZptmuh01DVAsBFkqWTPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjFlotFQA5bQTIIa6yTc5RwDYhAa2qG4bYT/EOLWqrK08FVqZ3d6SogesiZRohoKl5pVRkkKlyGtoUuHT9e4o462um6kU6wMYArD1ZVJBdJoKK+KOtr1o7ZDKNk/1Z1tbq2/wAhuaL6xeq8yCWVEw3dco4gz27zCJ6aFgu7IzdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYnkTalk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYnkTalk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE981F00A3D;
	Fri,  4 Sep 2026 05:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498522;
	bh=pVEs5q7ubVugWXMHc961hQzS61KSkFMr4NAGmMHMzng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYnkTalkC/9f8ccPdSk1M5D9841QexvblY/BcvnecBrFjzYNq7+jmpT0VfB+7Wam9
	 HwK3SyPlZR2oYvr8h1pxYaZ5kW9/7LnPh86gcngtU6Qb1FSnOp8Nmhmfa2D3OJR21y
	 eBUy6MEWCAHeaJVKHTE0PzGxOIQXOJvQoj1Z96CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Nikhil Agarwal <Nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH 7.2 094/713] cdx: Fix double free when sysfs file creation fails
Date: Fri,  4 Sep 2026 06:51:02 +0200
Message-ID: <20260904045805.945848455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

commit 6f4acc3a3c300e174e3f586b97b04ed8f5948c36 upstream.

In cdx_create_res_attr(), if sysfs_create_bin_file() fails, the code
frees res_attr but doesn't set cdx_dev->res_attr[num] to NULL. This
leaves a dangling pointer in the array. Then cdx_destroy_res_attr()
frees the already-freed memory. Fix the double free by initializing
cdx_dev->res_attr[num] after sysfs_create_bin_file() completes.

Fixes: aeda33ab8160 ("cdx: create sysfs bin files for cdx resources")
Cc: stable@vger.kernel.org
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Acked-by: Nikhil Agarwal <Nikhil.agarwal@amd.com>
Acked-by: Nipun Gupta <nipun.gupta@amd.com>
Link: https://patch.msgid.link/20260724092712.2119149-1-ptsm@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdx/cdx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -738,7 +738,6 @@ static int cdx_create_res_attr(struct cd
 
 	sysfs_bin_attr_init(res_attr);
 
-	cdx_dev->res_attr[num] = res_attr;
 	sprintf(res_attr_name, "resource%d", num);
 
 	res_attr->mmap = cdx_mmap_resource;
@@ -747,8 +746,12 @@ static int cdx_create_res_attr(struct cd
 	res_attr->size = cdx_resource_len(cdx_dev, num);
 	res_attr->private = (void *)(unsigned long)num;
 	ret = sysfs_create_bin_file(&cdx_dev->dev.kobj, res_attr);
-	if (ret)
+	if (ret) {
 		kfree(res_attr);
+		return ret;
+	}
+
+	cdx_dev->res_attr[num] = res_attr;
 
 	return ret;
 }


