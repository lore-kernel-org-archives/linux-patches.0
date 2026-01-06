Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6673009E2;
	Tue,  6 Jan 2026 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720920; cv=none; b=PGLcqmCdB3dxUIkS6JyETlGF6L4XtkK46R2YAMTG8KmLAoWGQC3vKiMsBjZaz51e+16HX3n66AlD9gv8mm3xulQKvjSEewVhkrataSrJacZE8nL4Rzv27hwhF7BhUQyoUAZ4xcmkkga5ENdtG/FGWkNBTjQMJNNqO2/fOT+e+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720920; c=relaxed/simple;
	bh=A+Zrq+5hsBh1jKuMIOmUIWOfiu7ilJc6PO14pzeK7Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAqzRgcShvIhgaz1HfDR/g0v8evTb2PgjUnVXkDowGVoV3IGdGjm67Slb2+JNCl2EQcP68QMne/bn+1Wep9nYrZWRUM/DGGJEuYlG8CJ42pV61yHUHQWa4WrixalSYi2rdjXQCUTI0ktECsO+yLjvzUn/MVeRE9ypV8kUQ0Pu/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQzlV7va; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQzlV7va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED07C16AAE;
	Tue,  6 Jan 2026 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720920;
	bh=A+Zrq+5hsBh1jKuMIOmUIWOfiu7ilJc6PO14pzeK7Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQzlV7vaEEQPiZeFQWlexaVDuY08ux8CKkK3JCXWW2d1VyT8VgLyvRe2M81UL070r
	 T2r0WXZAQgHzqewkggzqGJIltEF24datv+SyLN6JwyLQGubnY8cdr+ZFXU3Anh+TuW
	 Gw/552tOXS6gBiXhGvMkWiLOFqEbBvDqfuBQ39uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 380/567] mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup
Date: Tue,  6 Jan 2026 18:02:42 +0100
Message-ID: <20260106170505.398333378@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ccb7cd3218e48665f3c7e19eede0da5f069c323d upstream.

Make sure to drop the reference taken to the sysmgr platform device when
retrieving its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: f36e789a1f8d ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
Cc: stable@vger.kernel.org	# 5.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/altera-sysmgr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -117,6 +117,8 @@ struct regmap *altr_sysmgr_regmap_lookup
 
 	sysmgr = dev_get_drvdata(dev);
 
+	put_device(dev);
+
 	return sysmgr->regmap;
 }
 EXPORT_SYMBOL_GPL(altr_sysmgr_regmap_lookup_by_phandle);


