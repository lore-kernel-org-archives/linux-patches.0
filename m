Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2734C81;
	Wed, 25 Feb 2026 06:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002722; cv=none; b=Jw9zhhBHKbtNAkN3hS1jjpLEitoPCxtLGxknHClQhCJfG9LcMSjo8MobVqIYxw69zfNMxWpECoypklSwp7KKWfGATbm+PmGbuK8E+KsYWodtZa7tW2PWDU1RDrAgfcqQqKGd3BFixMtCbfMmbIwSZF+avn3wWvS9J8YD+QfHNYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002722; c=relaxed/simple;
	bh=ISg45eiW4OKdxCjWR1ITL085KueXdBYO6EAM0OHTO4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aU1Og65NTfFeX3VK1KmkTu7RZz+39fBNJbLzh2zSpkWMqYieQZKFMK2HV0oPed0d+SKLPw624rCQ1CFn0Gs6RKzy4lnJPN6tTPYZERHmMQnBAsUAGKQRvboNySEK5FV+4X0yF4wK3hbafOX1pfsPdXKAsr9rDHHvv8t4ocNt0Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qH+wZgR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qH+wZgR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3650AC116D0;
	Wed, 25 Feb 2026 06:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002722;
	bh=ISg45eiW4OKdxCjWR1ITL085KueXdBYO6EAM0OHTO4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qH+wZgR/kL3f1gMnABJN4sWm4XHgeAFUfY1FKJL79+p12s5bRF3RpMfItZrnMKqTT
	 yxKCZQE9u5O/n0DfURiFn04KBK7vCLVNett9BKc+Oxie76vcMVgt/O4lYdOf6KPCSi
	 9YQWyNfBNRRm2Y6zXSpz67b5f7nYRPK3RGZFSGT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 532/641] eth: fbnic: increase FBNIC_HDR_BYTES_MIN from 128 to 256 bytes
Date: Tue, 24 Feb 2026 17:24:18 -0800
Message-ID: <20260225012401.418203342@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Bobby Eshleman <bobbyeshleman@meta.com>

[ Upstream commit bd254115f38db3c046332bb62e8719e0dc7c2b53 ]

Increase FBNIC_HDR_BYTES_MIN from 128 to 256 bytes. The previous minimum
was too small to guarantee that very long L2+L3+L4 headers always fit
within the header buffer. When EN_HDR_SPLIT is disabled and a packet
exceeds MAX_HEADER_BYTES, splitting occurs at that byte offset instead
of the header boundary, resulting in some of the header landing in the
payload page. The increased minimum ensures headers always fit with the
MAX_HEADER_BYTES cut off and land in the header page.

Fixes: 2b30fc01a6c7 ("eth: fbnic: Add support for HDS configuration")
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
Acked-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Link: https://patch.msgid.link/20260211-fbnic-tcp-hds-fixes-v1-2-55d050e6f606@meta.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
index 27776e844e29b..51a98f27d5d91 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
@@ -66,7 +66,7 @@ struct fbnic_net;
 	(4096 - FBNIC_RX_HROOM - FBNIC_RX_TROOM - FBNIC_RX_PAD)
 #define FBNIC_HDS_THRESH_DEFAULT \
 	(1536 - FBNIC_RX_PAD)
-#define FBNIC_HDR_BYTES_MIN		128
+#define FBNIC_HDR_BYTES_MIN		256
 
 struct fbnic_pkt_buff {
 	struct xdp_buff buff;
-- 
2.51.0



