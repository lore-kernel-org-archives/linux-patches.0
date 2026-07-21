Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84C546EC61;
	Tue, 21 Jul 2026 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658800; cv=none; b=sQ4Ja46+3fSjButXE4GWBn5j0zyWlKC/zJPfHYVORAqK3I1opPwcoSGSMoVPzy/jYhnzHGos5RCCXstw+t/YEnRWECPZ8JLFLJUusfiueuxm4mXLUcDuKIZVp6zG3Fx4bQxgJVNX8n0DsJ4V9yyQVv7i/IjiohqiYAdoSdvlMJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658800; c=relaxed/simple;
	bh=kqXZyvyo7iC51ZhTkaxS+f8geAFg1VUBCls6l08Xs0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDjPU/3DBg1ZyEV3vOidtlAfqDdXWDWMKYtT40j1qZYj2e46tk9D177wclen/k5GwDcdKB36g4B98vH3ViFGabgXFUJRs0LBysuvEz2kgaFZPHO3dFOXe18/80Uq7QU/FUuUkMGfTfagCyiW3oW5EgnPRC3OHZL/rx0B2CG/k50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KolJavch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KolJavch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3D81F000E9;
	Tue, 21 Jul 2026 18:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658798;
	bh=f8l+kif99+64N6t2eXVWz20besMfb6VQs8fB+c31DTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KolJavchSfr/SdUS/ICQnOAOVQgyKFCMWO/zfwMeWm/lghTI8ajt3riAkAqXW2YAH
	 X9PW1M0AkZtKvgE2Ek8AcD5Q39bWR5wnertbX8XHUj7N9bi4il0h2W4cP6eR5V4dex
	 R2xF8U/6J0LeJGl3d5a2MJYkZ/kHK0wz+ikMArkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.18 1280/1611] fpga: microchip-spi: fix zero header_size OOB read in mpf_ops_parse_header()
Date: Tue, 21 Jul 2026 17:23:16 +0200
Message-ID: <20260721152544.237128003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Alba Vives <sebasjosue84@gmail.com>

commit 43a1974da6bc7ce8f4d1dc1d03d56997428c29c3 upstream.

mpf_ops_parse_header() reads header_size from the bitstream at
MPF_HEADER_SIZE_OFFSET (24). When header_size is zero, the expression
*(buf + header_size - 1) reads one byte before the buffer start.

Since initial_header_size is set to 71 in mpf_ops, the fpga-mgr core
guarantees the buffer is large enough to reach MPF_HEADER_SIZE_OFFSET.
The only real gap is the zero header_size case, which cannot be
resolved by providing a larger buffer, so return -EINVAL.

Fixes: 5f8d4a900830 ("fpga: microchip-spi: add Microchip MPF FPGA manager")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Alba Vives <sebasjosue84@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260518190742.61426-4-sebasjosue84@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/microchip-spi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/fpga/microchip-spi.c
+++ b/drivers/fpga/microchip-spi.c
@@ -116,6 +116,9 @@ static int mpf_ops_parse_header(struct f
 	}
 
 	header_size = *(buf + MPF_HEADER_SIZE_OFFSET);
+	if (!header_size)
+		return -EINVAL;
+
 	if (header_size > count) {
 		info->header_size = header_size;
 		return -EAGAIN;


