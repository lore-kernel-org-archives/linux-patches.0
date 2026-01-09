Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033AE1A01C6;
	Fri,  9 Jan 2026 12:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961570; cv=none; b=KHwcuQwiFxSwWQH/TPbrTRxDHbdDnsPN/J07TJGh7Fa594+AWEQHVaL/QvGJJF+KlDzL3LS+AiunaAQm4Nm1PB4nEulFKB5iKIrM1F9SmCeQf9/n16n/H21CE6LV4L3tsyuPADnZP+RnM8pBpJrh70DV8DDyHIRH1foTnbYgpw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961570; c=relaxed/simple;
	bh=YXAbEIiofmkcXmbVhWR54PrTGcyOAHiIOn5xJhuve/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VX7M/b+b9GJ8GO5QOw2TJLbr6Rkbz7FrrX4xNlL1hlHVdEOaftDTTGutonqEKQsgPOyc6/QhzVzMNQjj2saCS4PNxjpOpdSVlq/aLjV7U/Agv9N+O6BPEGVe6HD9ssmblyGyNymi/2xaORn1K9K9v+NnJkkRdHtQXVIRIPLTCMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFMSkVJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFMSkVJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5922BC4CEF1;
	Fri,  9 Jan 2026 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961569;
	bh=YXAbEIiofmkcXmbVhWR54PrTGcyOAHiIOn5xJhuve/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFMSkVJ59J5hb+14Kw7ghu9UlboKcHu2E9bJ/X0SAERdcT5PPpVdyZTlfytnl6iQS
	 oZFL57TT4GOyLL61yB9IRb3ln4hlL0gpJJ3Kkm5XLAfPh61MysXfNtlk4kpMlCFO8q
	 ZsGVwjFtuQVRpYxEHCJxB4rdqJ2hheQDleO5JhKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/634] uio: uio_fsl_elbc_gpcm:: Add null pointer check to uio_fsl_elbc_gpcm_probe
Date: Fri,  9 Jan 2026 12:35:37 +0100
Message-ID: <20260109112119.664968261@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit d48fb15e6ad142e0577428a8c5028136e10c7b3d ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: d57801c45f53e ("uio: uio_fsl_elbc_gpcm: use device-managed allocators")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Link: https://patch.msgid.link/20251015064020.56589-1-liqiang01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_fsl_elbc_gpcm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/uio/uio_fsl_elbc_gpcm.c b/drivers/uio/uio_fsl_elbc_gpcm.c
index 7d8eb9dc20681..db4e64550f121 100644
--- a/drivers/uio/uio_fsl_elbc_gpcm.c
+++ b/drivers/uio/uio_fsl_elbc_gpcm.c
@@ -384,6 +384,11 @@ static int uio_fsl_elbc_gpcm_probe(struct platform_device *pdev)
 
 	/* set all UIO data */
 	info->mem[0].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn", node);
+	if (!info->mem[0].name) {
+		ret = -ENODEV;
+		goto out_err3;
+	}
+
 	info->mem[0].addr = res.start;
 	info->mem[0].size = resource_size(&res);
 	info->mem[0].memtype = UIO_MEM_PHYS;
@@ -423,6 +428,8 @@ static int uio_fsl_elbc_gpcm_probe(struct platform_device *pdev)
 out_err2:
 	if (priv->shutdown)
 		priv->shutdown(info, true);
+
+out_err3:
 	iounmap(info->mem[0].internal_addr);
 	return ret;
 }
-- 
2.51.0



