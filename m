Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65157246773;
	Tue, 20 May 2025 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750177; cv=none; b=LNE6/95d3sE+aLPheCbDbMsZH0pd2lT5YRNjjBnjOMIC8Nn5Yacj+IMhySG/Z7cSPbDRW+t4/uA/KIFP0NZn5TKguDyCi6Zoso5jdD2Acr8dwA/x+bC6dn89lVpteFQjdXMKKTX+UQTvJ+AW0Sx7chNiTp8sJsUvxd/7yec4J+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750177; c=relaxed/simple;
	bh=GipE5Mf6+kt/+s5duhETLQcSc/VHpm7fd3N80Ugv6qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6ssNG9kN/skfLVD6YiVRKCbn4L5KLOkU2KFk7w9HkaOPf4sw1bgfLkigtM1qtoUzylQOraDS07/lL7Dx48pD+6Ejq71ypCl3SdpizHex0cVNG/P89XSNG0dHkzF3aCbLFs7djgU10OL3ogZqFyHJ3/aCWwr1b0D5VJYVIimuXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpWh8y7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpWh8y7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F0FC4CEEA;
	Tue, 20 May 2025 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750177;
	bh=GipE5Mf6+kt/+s5duhETLQcSc/VHpm7fd3N80Ugv6qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpWh8y7a3MO0lpRXheXDc8URo+JwK/chY1UzflnRNlvFkpkJky/P9FWVoBq5eQ76K
	 TqmUw+aZmTdt+RkF106oZZbofpb38oxuTWSV3iKGBHnRzQQJca9PLA3EjrYzravdqj
	 TmF5a6yWrpG0z/sIFz1q11oWVS5ZYVmPSNwqmAfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengtao He <hept.hept.hept@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/143] net/tls: fix kernel panic when alloc_page failed
Date: Tue, 20 May 2025 15:50:21 +0200
Message-ID: <20250520125812.657324687@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengtao He <hept.hept.hept@gmail.com>

[ Upstream commit 491deb9b8c4ad12fe51d554a69b8165b9ef9429f ]

We cannot set frag_list to NULL pointer when alloc_page failed.
It will be used in tls_strp_check_queue_ok when the next time
tls_strp_read_sock is called.

This is because we don't reset full_len in tls_strp_flush_anchor_copy()
so the recv path will try to continue handling the partial record
on the next call but we dettached the rcvq from the frag list.
Alternative fix would be to reset full_len.

Unable to handle kernel NULL pointer dereference
at virtual address 0000000000000028
 Call trace:
 tls_strp_check_rcv+0x128/0x27c
 tls_strp_data_ready+0x34/0x44
 tls_data_ready+0x3c/0x1f0
 tcp_data_ready+0x9c/0xe4
 tcp_data_queue+0xf6c/0x12d0
 tcp_rcv_established+0x52c/0x798

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Pengtao He <hept.hept.hept@gmail.com>
Link: https://patch.msgid.link/20250514132013.17274-1-hept.hept.hept@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_strp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 77e33e1e340e3..65b0da6fdf6a7 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -396,7 +396,6 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 		return 0;
 
 	shinfo = skb_shinfo(strp->anchor);
-	shinfo->frag_list = NULL;
 
 	/* If we don't know the length go max plus page for cipher overhead */
 	need_spc = strp->stm.full_len ?: TLS_MAX_PAYLOAD_SIZE + PAGE_SIZE;
@@ -412,6 +411,8 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 				   page, 0, 0);
 	}
 
+	shinfo->frag_list = NULL;
+
 	strp->copy_mode = 1;
 	strp->stm.offset = 0;
 
-- 
2.39.5



