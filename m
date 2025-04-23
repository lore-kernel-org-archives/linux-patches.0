Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475A31F5435;
	Wed, 23 Apr 2025 15:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421650; cv=none; b=gjn0Etb1tgsOsE87pZNytzvZHF8UvLEnqd2NUlcgqim1ZA/drgcwx5WsuMrYtyJyfTjC/UDmB9ZuM4xULtDsZrxPMvwJ3Sc38yXxZFtY54u5tZ3HWKQ9RlY99MPtFYhgAimVdYe4TteH+CCmsRSuHBjZd3fCx2Kdnr3cPqnlOoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421650; c=relaxed/simple;
	bh=hJnnuAUeLrgIf7bzkob6SIBRHCb6++ILeVpubi467os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAZuU1+j6MRNJpQGbRH6sWNkaw2yZR12dDKyaADH1z31DhezzkRk6m0Qd1t7HJiafzKwziI/c65BLo5SrjMh0thyPsElzeFuWINTeuHNlTk9DJm++oXuUU0VI2LoVTaGYOLZXFONjtQNQNdYCT9xngx3iNVITYLxwHaCrrVqb+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFBqoYHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFBqoYHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C60C4CEE2;
	Wed, 23 Apr 2025 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421649;
	bh=hJnnuAUeLrgIf7bzkob6SIBRHCb6++ILeVpubi467os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFBqoYHiUy92rqL7FwAzuZoCB9g5pqlGI5PeTEJy568xCGmwowEUmKfFtbGL10sjW
	 K3GsPKRT0UeZadMRqvWQ9p3EdUjeU6gs9LbDXRrE7LGq0ViSQRxh6M6niFYTcb2pbr
	 nHXRcKC7rVv4R1WJmpb6d4GPJi/UHz56cDnn3G44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.1 150/291] ntb: use 64-bit arithmetic for the MSI doorbell mask
Date: Wed, 23 Apr 2025 16:42:19 +0200
Message-ID: <20250423142630.528130632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


