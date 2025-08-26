Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0C635691C;
	Tue, 26 Aug 2025 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219034; cv=none; b=FV0EVQFlGQYLmL6h6zVIMeqXpaY3OyDJf29aISfBX5cW8DZfPEPtKzAdMLWna9oD7KE/ljxEHi8yEXEkHen3IzlB7y8nI3LWC64Cs0nHSJuUMZA/In5T43/DMsRT3A08szjCO/uEyd8+7G7rlf0BcZLsyjKJUL1KZ91yFSUAZLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219034; c=relaxed/simple;
	bh=bUkqGbqgu31oWPCww9l0G+6WpZSBsvSfTQqI8iFbIgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRcAFol6CiCKgCshYbJ3yVVuBrtICluHrX4rGDSrDY2xHtTso7Gi8EoTrQhZ38X0yYySms464XSWWbD8vV6+PZTQyMTuv13VEbmSAb920QAcsLllMyCmkMkeuKfwCDec26KBWcj2amv1yLfS8rGPug66wUSYCLSqIG/gnxDLFBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgBJdJYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgBJdJYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285AEC4CEF1;
	Tue, 26 Aug 2025 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219034;
	bh=bUkqGbqgu31oWPCww9l0G+6WpZSBsvSfTQqI8iFbIgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgBJdJYqo9emJDr6RjtBJCyxpBRi8ym7Z4I9b9yAtuyoUX0YvhVLhK0CCDVM1JlLt
	 iw/6JzHWmTYsUU8XxY3+LzYlIQINQUV5loloqOLY3Sr5Sp3g1bu8AsdlkNxEi/fl8R
	 7LpPnvA+mLlj5ClOVoFpvHTj91/cNnQx//UQYkhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/403] net: ncsi: Fix buffer overflow in fetching version id
Date: Tue, 26 Aug 2025 13:09:14 +0200
Message-ID: <20250826110913.126811457@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>

[ Upstream commit 8e16170ae972c7fed132bc928914a2ffb94690fc ]

In NC-SI spec v1.2 section 8.4.44.2, the firmware name doesn't
need to be null terminated while its size occupies the full size
of the field. Fix the buffer overflow issue by adding one
additional byte for null terminator.

Signed-off-by: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
Reviewed-by: Paul Fertser <fercerpav@gmail.com>
Link: https://patch.msgid.link/20250610193338.1368-1-kalavakunta.hari.prasad@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h | 2 +-
 net/ncsi/ncsi-rsp.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index b723452768d4..67d5ee4dbc2a 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -86,7 +86,7 @@ struct ncsi_channel_version {
 	u8   update;		/* NCSI version update */
 	char alpha1;		/* NCSI version alpha1 */
 	char alpha2;		/* NCSI version alpha2 */
-	u8  fw_name[12];	/* Firmware name string                */
+	u8  fw_name[12 + 1];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
 	u32 mf_id;		/* Manufacture ID                     */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index b7d311f97905..41e4ed80f29a 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -782,6 +782,7 @@ static int ncsi_rsp_handler_gvi(struct ncsi_request *nr)
 	ncv->alpha1 = rsp->alpha1;
 	ncv->alpha2 = rsp->alpha2;
 	memcpy(ncv->fw_name, rsp->fw_name, 12);
+	ncv->fw_name[12] = '\0';
 	ncv->fw_version = ntohl(rsp->fw_version);
 	for (i = 0; i < ARRAY_SIZE(ncv->pci_ids); i++)
 		ncv->pci_ids[i] = ntohs(rsp->pci_ids[i]);
-- 
2.39.5



