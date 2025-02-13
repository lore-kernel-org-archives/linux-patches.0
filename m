Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3D71AAA29;
	Thu, 13 Feb 2025 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459145; cv=none; b=JBD+iysevyA/5T1uUpna1bmSnFnuCmocNQIgdKtkVXsbZHz+itQk1OHWZZNHJTr2TvHlSa8Xr0SyYhfUlyiHCvUR2LCYCjh+PYneft/1eMm4UNdc0FrpCEj5e7udkAsY+XisWoPVX2RRFq6gGXMYPHyWn+Ls4e/Tsbr2o0OMwx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459145; c=relaxed/simple;
	bh=i8zzqfHWTC4KZmlRVOzH2qQwXOGmdEUV0MYltoBp8eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR/VLFgVTH0e6MAOjrgS+ltmHg4slcs7uSHY2wI8+qUy5DRbOxHKvXICF7Xm8EBZQYfR050piGIIaQYPcY68RB6c9RQ93OLKdesX89lsY8G8Kpk3K15CoOoF00sS0X10jx6JTo2Qb8wrbL/4ry+HE0rq93YO+RZLymUd+b94JRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkh0t6SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkh0t6SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59560C4CED1;
	Thu, 13 Feb 2025 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459145;
	bh=i8zzqfHWTC4KZmlRVOzH2qQwXOGmdEUV0MYltoBp8eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkh0t6SIcoQxDiAAvGc8Zy/50Oeyl900uKorWkShOEJ0+L1IN6ck7u0sJFDO1QaWE
	 WhcW5YrJJN1PBPqfJe37Z7UYBKzqiuPA0zBmh3/KPnHfd3HpYkMFv6tzseAW7usxHV
	 86/JTpIMe+Lg9XBNtbXsJHdmyh8GbfEu+i/Cedjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.13 182/443] drm/komeda: Add check for komeda_get_layer_fourcc_list()
Date: Thu, 13 Feb 2025 15:25:47 +0100
Message-ID: <20250213142447.639720453@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 79fc672a092d93a7eac24fe20a571d4efd8fa5a4 upstream.

Add check for the return value of komeda_get_layer_fourcc_list()
to catch the potential exception.

Fixes: 5d51f6c0da1b ("drm/komeda: Add writeback support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20241219090256.146424-1-haoxiang_li2024@163.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -160,6 +160,10 @@ static int komeda_wb_connector_add(struc
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       kwb_conn->wb_layer->layer_type,
 					       &n_formats);
+	if (!formats) {
+		kfree(kwb_conn);
+		return -ENOMEM;
+	}
 
 	err = drm_writeback_connector_init(&kms->base, wb_conn,
 					   &komeda_wb_connector_funcs,


