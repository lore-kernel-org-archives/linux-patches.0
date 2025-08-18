Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC5308F30;
	Mon, 18 Aug 2025 13:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522209; cv=none; b=h1H3D+iP8dGkVZxWjbpbe9IhnA1MagpZ2vUEbmYv5GDl3nzdojbRCH/AKOHoGnLg7hHkSdxRhSCloEb0EY7t1eK4Oo6IaA0I5BV2ZOn4CllG3zuxusWK8CNOE0HsTcJclpXsStdtTCRSbbnwIhwUdgGZlJvI+hAL0K74GVi6bAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522209; c=relaxed/simple;
	bh=HmY/YtGnwam2ykZCt4JNgQ5Aa4FKpslhGvX2+hUthng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP+xvCoOT/jfCIhwRo4jDvBMlTYrLdGfgo6vFJ5N01yp+qnS1SCaxEKSaxC0wl22KDhUA/kDyRkRcTeHLOr4MCEz8F02TSDFByc5Wzsx3hdonf+G5b26/AwH2555FYZqAmWy/4AYasNRDi69NH+/wY47gb5QTxbtnw//XgTxzI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDfAyXfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDfAyXfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F72AC116C6;
	Mon, 18 Aug 2025 13:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522209;
	bh=HmY/YtGnwam2ykZCt4JNgQ5Aa4FKpslhGvX2+hUthng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDfAyXfgke6dgKpUm0OB5uNYLNg5tMXH5+we8YQau/buOkWqoB8pNJtCgLV/IBUXg
	 wDxski9mLvnF324y8g8NTGk6bWKRMEB3pd3O2WgvFE3UieNdIHRAC18izQYV9WpP3l
	 8NTnEOLEn54lWXiZYWz5HVFZIDtkQ+XNurSu0o9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/444] gve: Return error for unknown admin queue command
Date: Mon, 18 Aug 2025 14:44:33 +0200
Message-ID: <20250818124458.089164513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit b11344f63fdd9e8c5121148a6965b41079071dd2 ]

In gve_adminq_issue_cmd(), return -EINVAL instead of 0 when an unknown
admin queue command opcode is encountered.

This prevents the function from silently succeeding on invalid input
and prevents undefined behavior by ensuring the function fails gracefully
when an unrecognized opcode is provided.

These changes improve error handling.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250616054504.1644770-2-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 060e0e674938..36acbcd8f62a 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -564,6 +564,7 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.39.5



