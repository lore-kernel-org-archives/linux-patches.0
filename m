Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C7F217F2A;
	Tue, 12 Nov 2024 10:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408151; cv=none; b=cdrWHghmS9z4WsCRlt37v/WIo+R9rdFCQG/d8hv8PaarWBmMU6T650SxtMZNoD3/IRoC0A72igRPb9h7vj20YzOpCTkSRVvJY+SmOpmXXP8TLU5kTmDhaFMwElcaCDGAcnF5yrYhyENDlpzqJdHTZSOTSrA1bDKG1O6pApV4AFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408151; c=relaxed/simple;
	bh=p3s8aogREnyTu70nnD9Ob9pMkw8hsM52cu4oOHzh0qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tVkUjJvk3FPMHjRqAQsKlucD3NmZif8EJqZCIIaP17sIkxlrYWc9CUfV0BvCvnUQdAlOnFdd+g4MGfMbA4nqro7LOFxZ7b/Q4FQqrO9XblXXkKfP/9ZBiIIeuDJpA+SLRTczl3GRARxNJq79vaajlRS7CoaColkFaAb6hMC1Mwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZySNPyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZySNPyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1ECC4CECD;
	Tue, 12 Nov 2024 10:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408151;
	bh=p3s8aogREnyTu70nnD9Ob9pMkw8hsM52cu4oOHzh0qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZySNPyBUc0eZuFrmHrG5QlHCHuPLpMb6nqgC/Nft6c6hb1QczPKsn25D1TvXsToF
	 qvjkoJqN8ipWuJne2wZ0X+lAj5sVv3PoR/hNutswuk+aNTxckMDsaMXRejlcVeiK3a
	 CfA/7P/lzPXXplzsdreM1dE8t0Xbg4awuX1XaTdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>
Subject: [PATCH 6.11 076/184] media: mgb4: protect driver against spectre
Date: Tue, 12 Nov 2024 11:20:34 +0100
Message-ID: <20241112101903.778683645@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 2aee207e5b3c94ef859316008119ea06d6798d49 upstream.

Frequency range is set from sysfs via frequency_range_store(),
being vulnerable to spectre, as reported by smatch:

	drivers/media/pci/mgb4/mgb4_cmt.c:231 mgb4_cmt_set_vin_freq_range() warn: potential spectre issue 'cmt_vals_in' [r]
	drivers/media/pci/mgb4/mgb4_cmt.c:238 mgb4_cmt_set_vin_freq_range() warn: possible spectre second half.  'reg_set'

Fix it.

Fixes: 0ab13674a9bd ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Martin Tůma <martin.tuma@digiteqautomotive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/mgb4/mgb4_cmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/mgb4/mgb4_cmt.c b/drivers/media/pci/mgb4/mgb4_cmt.c
index 70dc78ef193c..a25b68403bc6 100644
--- a/drivers/media/pci/mgb4/mgb4_cmt.c
+++ b/drivers/media/pci/mgb4/mgb4_cmt.c
@@ -227,6 +227,8 @@ void mgb4_cmt_set_vin_freq_range(struct mgb4_vin_dev *vindev,
 	u32 config;
 	size_t i;
 
+	freq_range = array_index_nospec(freq_range, ARRAY_SIZE(cmt_vals_in));
+
 	addr = cmt_addrs_in[vindev->config->id];
 	reg_set = cmt_vals_in[freq_range];
 
-- 
2.47.0



