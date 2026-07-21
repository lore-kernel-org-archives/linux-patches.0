Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3E30EF7E;
	Tue, 21 Jul 2026 19:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663788; cv=none; b=N8lyDWSgNpeJY6ebntV/xSc5aseGnkcReg/kEviAGiHwM2KH8k3uo97x6HD0EFBglNybxohtj3n0h/iqZB7go7yQ+vYmqAzW3h1JazxLS2g2l8XCKc9IAP6uJnCaf0qg+SSF/4aFM1j1Bbx4l6d+ZIeORPwODTxglWzxq300E9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663788; c=relaxed/simple;
	bh=z8YgIoCIWxK3ZctVKYCGEFLPXXB/45E0ZCBSL+cKqTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otE6cztQy8mf/oQltBzL3IZbC6f+6vQEznxZgVVHGCtzOQ+oZVCv6iFdKH2qtJFRAro8VXX3fW8wF0c/CnpDEDDazvH3LC3TBQC5tzvH4gVitfRqtnDBDuW5qgi2IPhAGwr3ORbdMhyTZ8KvjrMbJggRKxYGWFbB4eTN0knxvek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nql8hbHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nql8hbHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF061F000E9;
	Tue, 21 Jul 2026 19:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663787;
	bh=95F1PE4dn1LY/szZ/gPM7bq32m365wzusTEMPZXOLOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nql8hbHWwcd5C68qP4Gr4xokzIsDX0LfrgIazj3sWyYN+l7D5Depl37+dPuFEPBk6
	 jmHKsaQCv/hiEmnqQIVx97RNl6QKUb4dMmXk/3efF2Df3ey7cqHjIrgjLSwTtDb8An
	 I3qX/nj2bPtBlQYWThqpQXaAt9gibmoWfj0tXEH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.12 0954/1276] fpga: microchip-spi: fix zero header_size OOB read in mpf_ops_parse_header()
Date: Tue, 21 Jul 2026 17:23:17 +0200
Message-ID: <20260721152507.376538629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


