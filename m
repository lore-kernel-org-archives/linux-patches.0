Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062200;
	b=dwdyjmqqf/KWPY5P5XcajN7UJ6phaX8geY/sVEZ9qj1YyHd9ku6EHftuvDMVSiQyPmrN
	 wvwwq8HPG+6ooWoP7/ms70zyfALKV/Y2x0T9f+2nZJjqpVEuh8m6E5dZgXgAdxP4JUt66
	 qCpUTvpte4gGkEvvVtfXUtf+Rh9GEYR7IgVLjNqn6PAjRZCSdKm9jg5D+C+TeknAHmxlz
	 lWb69KK93/BZdvIKaC0IJi1iHNZ2FRVVsRDp9zLOXBKPqEXQ8w1i27DJMwBica4kKhj9J
	 WUZvdPKyfzAkKiagTjWkn68Qe+vqVQ5bPPfnSuH+Kt1fFtJEBS7XCFtvmJXDNllvfyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y/dRbHZh2zKPAzdiFjRSMXkOecu0knswvDIoOVpnvD8=;
	b=vfgV5PnxZZmJJgXJx4WNNijlVV6x/Tkc8826s+6DpuUblsHtvwZ+emG7H1oOnp7PYMJG
	 6juYp+PCaCBSO9dGv0Sd35jm5jSscwoEiQZhl5s12J8GkyZ7Y1Y60FiYeoyClWC0nIXm5
	 e03/SYYutVsPhk7bBPGrr9fUO7Pj82QUeiTgQH1XwS1iEe2O9+xiSowQM7C3eW6lqJ0vo
	 XuWsBqdV5auO9baLBgr74yg5OYPXcu1TYbG0cBKvO6jRUzv1n7FQ9Xkf3Vi2/fPzsKrOO
	 4nHjrjAyI4uFHE50n/XIIibHWDI8rCgELwaQ5k0zKHTklDbf7kVsU7MmxIRrfBnz5Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L33iO141;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BAF606A326;
	Sat,  7 Nov 2026 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L33iO141
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A7A1F008A2;
	Sat,  7 Nov 2026 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062200;
	bh=y/dRbHZh2zKPAzdiFjRSMXkOecu0knswvDIoOVpnvD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L33iO141MfGpc61mf41hmLDIlGoGP87RLAEEfwFersYB+2VZPMzavSf6MIbqP8tfp
	 +jQV4d6jktg5mZuAbLdeqVsxgXK/KXWiHa+TxBuZxsPvWRVdjYTgeVQ0OuelyynkD9
	 7vF/KEQnLJ3DVpV7uJd3ZNi95yt93OqE649usRP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1118/1536] media: pvrusb2: Fix USB parent device leak in class_dev_create()
Date: Sat,  7 Nov 2026 08:52:14 -0500
Message-ID: <20261107135029.109535956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 02421d7278e4a62c3daf37ad6c45d4af96ee4252 ]

class_dev_create() stores a reference to the USB device obtained with
get_device() in class_dev->parent, which class_dev_destroy() releases.
When device_register() fails the function only drops class_dev, so the
reference to the USB parent device is never released.

Drop the parent reference on the failure path as well.

Fixes: 28c4a5e6d324 ("V4L/DVB: pvrusb2: Fix USB parent device reference count")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 3077399901aa1..dd6fcc6245afc 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -633,6 +633,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp)
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev->parent);
 		put_device(class_dev);
 		return;
 	}
-- 
2.53.0



