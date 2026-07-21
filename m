Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761AD347BC6;
	Tue, 21 Jul 2026 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674275; cv=none; b=PMyd77TYcv84YzPF8ywMHgpMNOmHNoadQ0ScYmttj9sZ74twb8uP2PXaKCsvZ/HJ+bmqZ3SUpHMZKv6kZjvc4tgC1MkDrhSAa+YVLvZSwITpYmAX8RsiTDXzBNCiAwrAU5pqvRHf/SqP6eTNDXX0YjyIqOV3q8jkkdGpj/V9kaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674275; c=relaxed/simple;
	bh=Z5ISxcIROp+l/bxmO/atmOyhLsTpL4Jxp3WZnraJbfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcXcEJnsgQa0kvf2JQD7UDVxFRHz27VMQG3cpT6yY2Bh2Eatol/lMCH4A4gGoA7CVxebsJDG9zbBk6WCVGdwYeuwyCGdx3kzaV9TLkhU2y9tU73dQ0P9rsZ5IN+G5/t0UX3oPIFMwfPGrg2lurajX2DqUqSRFcgKdv9RhpHd3ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1BWaian; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1BWaian"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768881F000E9;
	Tue, 21 Jul 2026 22:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674274;
	bh=gG1k/sKpF676+jbDZHo+mTteK1Mh1wrWRHnoTq2fRnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1BWaianXL26O7d6etFlbeHXNNEsV1YCae5ZaOiXP3gFhgLtHRYP9fOT7tKWhzqh/
	 JU+KDmOFN+VGI90W/M/M5nCTQsKxXW5VvL5FdzDUbdC+TYL3puXyFwZ73+opAnQb4H
	 EykdGaKZaFTcrpFXPGm9tQAP2S+qE1b9nj5pL/FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 452/699] gpu: host1x: Fix device reference leak in host1x_device_parse_dt() error path
Date: Tue, 21 Jul 2026 17:23:31 +0200
Message-ID: <20260721152405.898749124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit e75717f9aec04355777be41070890c6a815c76df upstream.

After device_initialize(), the embedded struct device in struct
host1x_device should be released through the device core with
put_device().

In host1x_device_add(), if host1x_device_parse_dt() fails, the current
error path frees the object directly with kfree(device). That bypasses
the normal device lifetime handling and leaks the reference held on the
embedded struct device.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix this by using put_device() in the host1x_device_parse_dt() failure
path.

Fixes: f4c5cf88fbd50 ("gpu: host1x: Provide a proper struct bus_type")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260413141526.2961841-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/host1x/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -441,7 +441,7 @@ static int host1x_device_add(struct host
 
 	err = host1x_device_parse_dt(device, driver);
 	if (err < 0) {
-		kfree(device);
+		put_device(&device->dev);
 		return err;
 	}
 


