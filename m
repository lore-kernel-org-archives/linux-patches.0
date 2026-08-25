Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77778470421;
	Tue, 25 Aug 2026 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665213; cv=none; b=ajnaeVndXumx5enECXnN4YRyUApNyn37O2PUGBZuCxu1yXTBmEi1SXPKm11uQE2LHnad1omyajZ8ERZV9YWBGs7zpe4t3O45nFbst4/oo/4w/x3j2G9RhAsiaH3r7/MbVqqCwGInNq51DlKvnlqYABtEpw/HYLWiJip/I6yOg0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665213; c=relaxed/simple;
	bh=ZZATGcJKCHQ++ypa95pS9B+sBGE6+/RRPIy8DXAs1is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfr4mvQ5Msp71FbXaJH3ai2g3xDfnabb8aXnRZIszeR3bdRCBaqie7ewg7OCw0ikySGv7uy4EkwgTgz3FpoV3D3jdjfm5hIPoYkb3LH1qg8lQJAEadWSceqDkwRk1VB0m87sTH+/fRnMCO+kGvXh9AXscrpdDBy1Uf34aR+8s/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br7yJqj/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br7yJqj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF041F000E9;
	Tue, 25 Aug 2026 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665212;
	bh=sGpLjzSaqciAUsUeR+svD750Vmq27U2lNco6IMyDnX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Br7yJqj/se6/fr//qQbBkf30c7DA1VXoAJ9hkN4Ho+PjLCpczCafydkd/s2iOLTgu
	 PabMr3DF6C540UggWs08+I5BvIwPaHMvrpyTb2/MA/RkmaeKrnBYcvqQOeBPDCq8d0
	 m8uN8B0+xHenUbT9hfz8rc5pKn5YI6vVKNdFAZPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.18 45/94] nfc: nci: free destination parameters when closing a connection
Date: Tue, 25 Aug 2026 15:25:41 +0200
Message-ID: <20260825132543.675718012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

commit 2e65bafdfd3a8bba972b3d17b6a57816557530fc upstream.

When a connection is closed, nci_core_conn_close_rsp_packet() frees
conn_info but not conn_info->dest_params, which is a separate devm
allocation. Each connect/close cycle leaks one dest_params until the
NFC device is removed. Free dest_params along with conn_info.

Fixes: 9b8d1a4cf2aa ("nfc: nci: Add an additional parameter to identify a connection id")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260721023518.1697625-1-lilinmao@kylinos.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/rsp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -336,6 +336,7 @@ static void nci_core_conn_close_rsp_pack
 			list_del(&conn_info->list);
 			if (conn_info == ndev->rf_conn_info)
 				ndev->rf_conn_info = NULL;
+			devm_kfree(&ndev->nfc_dev->dev, conn_info->dest_params);
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}


