Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EFE70805;
	Thu, 13 Feb 2025 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460646; cv=none; b=pXWfGoFG5eS1NkDeKJQb2nxNC/TylGnN3KX1MSAQAbsxIqyJoWFklMdoYTHJwwhUi2IR+XKTOAubmUgNcFsu3UgGsY/Hn0ZYAI0OXd91fmc0n8jz4+jYEUGVjnbQyHXh21P3DLMQSsxS2xR0bkfa1ANRj1a9ZHf/9mXTeCznVc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460646; c=relaxed/simple;
	bh=ne7bMfh14Svh2DHsb6eL5ppGexxFV8PgKKm9Y3cxhso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJM/lkqoU4eOlgaUwwwrtBce4AiRT/3oqOqunqsvCtQc08F0MBNnv16TgdFbBshInhC0ikiIOsqecapuQRSGG2I7xMyFHmaApq1slIBc7Fdp8higiSxhHKWBevA7UOs1Figj+iUcuR7mWNJFBRwsZYhxiVpN7dF86mPsqchvPk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIqLnoU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIqLnoU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CED4C4CED1;
	Thu, 13 Feb 2025 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460646;
	bh=ne7bMfh14Svh2DHsb6eL5ppGexxFV8PgKKm9Y3cxhso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIqLnoU3h633QxC+AAB55HUlcwnTorg2uf1Nzo4DQLgHwi69vdGEJnH0rZb5ydP6+
	 MK87x4JqFxuDeVWCY5rP90csrC2XXSYi4PM3lGqIQbvJX1wLvQl/IfAcdCYNpvVXMK
	 0aWbsCve1a/Jox8yN6VEGollgFnwDR9ivaKdYbAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 140/273] usbnet: ipheth: break up NCM header size computation
Date: Thu, 13 Feb 2025 15:28:32 +0100
Message-ID: <20250213142412.870064410@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Foster Snowhill <forst@pen.gy>

commit efcbc678a14be268040ffc1fa33c98faf2d55141 upstream.

Originally, the total NCM header size was computed as the sum of two
vaguely labelled constants. While accurate, it wasn't particularly clear
where they were coming from.

Use sizes of existing NCM structs where available. Define the total
NDP16 size based on the maximum amount of DPEs that can fit into the
iOS-specific fixed-size header.

This change does not fix any particular issue. Rather, it introduces
intermediate constants that will simplify subsequent commits.
It should also make it clearer for the reader where the constant values
come from.

Cc: stable@vger.kernel.org # 6.5.x
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 069979e2bb6e..03249208612e 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -61,7 +61,18 @@
 #define IPHETH_USBINTF_PROTO    1
 
 #define IPHETH_IP_ALIGN		2	/* padding at front of URB */
-#define IPHETH_NCM_HEADER_SIZE  (12 + 96) /* NCMH + NCM0 */
+/* On iOS devices, NCM headers in RX have a fixed size regardless of DPE count:
+ * - NTH16 (NCMH): 12 bytes, as per CDC NCM 1.0 spec
+ * - NDP16 (NCM0): 96 bytes, of which
+ *    - NDP16 fixed header: 8 bytes
+ *    - maximum of 22 DPEs (21 datagrams + trailer), 4 bytes each
+ */
+#define IPHETH_NDP16_MAX_DPE	22
+#define IPHETH_NDP16_HEADER_SIZE (sizeof(struct usb_cdc_ncm_ndp16) + \
+				  IPHETH_NDP16_MAX_DPE * \
+				  sizeof(struct usb_cdc_ncm_dpe16))
+#define IPHETH_NCM_HEADER_SIZE	(sizeof(struct usb_cdc_ncm_nth16) + \
+				 IPHETH_NDP16_HEADER_SIZE)
 #define IPHETH_TX_BUF_SIZE      ETH_FRAME_LEN
 #define IPHETH_RX_BUF_SIZE_LEGACY (IPHETH_IP_ALIGN + ETH_FRAME_LEN)
 #define IPHETH_RX_BUF_SIZE_NCM	65536
-- 
2.48.1



