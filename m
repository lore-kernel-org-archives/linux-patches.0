Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6973189F39;
	Wed, 23 Apr 2025 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421755; cv=none; b=uLAQf5r/3tFTgnj0ylKRxsWLWAGpIe3MUzHRWWFQ1ZKepAnSeJQzyx2xHbOjJpI3WOKFUCpyW3mrbnLW95oYWb2Fl5YNAyF83FG/JLuOhA///8vQ5dzAAquF3RGWNCKPvAlVEe1jJsO5z7RIXLpgdHtEuXhLZfZ1jsOej378bak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421755; c=relaxed/simple;
	bh=2S/YBmFH/bN7uerbwVnhh9YvU/G6QWS6S2Ru8zyRsWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIfwctHJZclly/zLv2KyuN0hs+w3p8QntEuIp7NSHpcavI+0j6XW7kS14BOP3nriGz3bnD1pmJLjjk5cNt+C6s3TDwchXqJuz9II0pJxuCATc2YcmlQIWou52Nwe2WA4CuIFLCmYTKlQCOhhm5s0+My46aYhmSry738mg7jglhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAF62guO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAF62guO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC082C4CEE2;
	Wed, 23 Apr 2025 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421755;
	bh=2S/YBmFH/bN7uerbwVnhh9YvU/G6QWS6S2Ru8zyRsWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAF62guO0WACluJDTwTg6MaTJsuBzXMkygdKIMifnpkXup//NoWd3ZkOdNAIKH3Jp
	 HOla5/5+H8vsDRdDRtP4MxVBvlczFAzTDCNvndwsKaKOcgNF0/PBtBEkbGQwyW7R4Q
	 A/CSADrrphOK7vhXXMzkYFrZ4yVTHLTrDAmTGZ80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.6 220/393] ntb: use 64-bit arithmetic for the MSI doorbell mask
Date: Wed, 23 Apr 2025 16:41:56 +0200
Message-ID: <20250423142652.473904773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit fd5625fc86922f36bedee5846fefd647b7e72751 upstream.

msi_db_mask is of type 'u64', still the standard 'int' arithmetic is
performed to compute its value.

While most of the ntb_hw drivers actually don't utilize the higher 32
bits of the doorbell mask now, this may be the case for Switchtec - see
switchtec_ntb_init_db().

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: 2b0569b3b7e6 ("NTB: Add MSI interrupt support to ntb_transport")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1351,7 +1351,7 @@ static int ntb_transport_probe(struct nt
 	qp_count = ilog2(qp_bitmap);
 	if (nt->use_msi) {
 		qp_count -= 1;
-		nt->msi_db_mask = 1 << qp_count;
+		nt->msi_db_mask = BIT_ULL(qp_count);
 		ntb_db_clear_mask(ndev, nt->msi_db_mask);
 	}
 


