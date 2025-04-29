Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A80C148;
	Tue, 29 Apr 2025 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948776; cv=none; b=R3tB441N8mz9O5zHxHkl+Zc+G/qjzP9Ry7D9gMdcQGMFBMi/sgx12YCb9KAGmuyHeUu0fmtA05efRzz711GPpHWFyOC9hSZ+Phs8zIMjVRBwvPa7GkL1WC5T5oj6FmOfvR1Ytg7lJLWZGGOCqbK/GkffvoEKknRBZAYfb2amBS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948776; c=relaxed/simple;
	bh=f12l8Ne9f8y+qHqctQBokTxLhI5j+HOmK1L3sYvmdVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9o/eIdYe3l7khHe6vD/CXn05/p37Aik7abktx/6pnO4owPp5o5aSw6q6yF3GicvoIvqf5nmhZMa52U+dMzkB81ukobsi3qbAIAAPijEMnln0QiJvPnSLne++r/vWdtl3bKZAdFa1WvJFp3/kt3fF8q67dM/CojOdphL7muvVg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05VXVRrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05VXVRrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9023FC4CEE3;
	Tue, 29 Apr 2025 17:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948775;
	bh=f12l8Ne9f8y+qHqctQBokTxLhI5j+HOmK1L3sYvmdVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05VXVRrmPTLYKpEK/EMAlijFpNL6K2WVL9u+mwKi6umRhNqbA22fbDGBIBsJQj1wV
	 BzBwYIY18JVPIWz6+byVMVvqW1Na122UPnIZbc7yBMVglJEjBgActcUn2ttj0twkl+
	 TOYUaD3xbdkbX9b+37Ec5C1p9MVLCXnJNpODw3eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.15 108/373] ntb: use 64-bit arithmetic for the MSI doorbell mask
Date: Tue, 29 Apr 2025 18:39:45 +0200
Message-ID: <20250429161127.616156610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1338,7 +1338,7 @@ static int ntb_transport_probe(struct nt
 	qp_count = ilog2(qp_bitmap);
 	if (nt->use_msi) {
 		qp_count -= 1;
-		nt->msi_db_mask = 1 << qp_count;
+		nt->msi_db_mask = BIT_ULL(qp_count);
 		ntb_db_clear_mask(ndev, nt->msi_db_mask);
 	}
 


