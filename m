Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB70234F47D;
	Tue, 26 Aug 2025 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216331; cv=none; b=AKqXUyGmGRieMliAmsh5W5A4ar1ntuw7AYD2d7en6haqBihPDTKSFOIpDciFmUf33NPfa9DcE0jxIQfsYgAxouZs2sjEqG0M/dI6+Pl/WlnPbfJC8vK28qdsyJgTf19ZRWok4Y0us+hicmWKcpyJ7Z2ryihbQ4RpGDQaZyoHbwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216331; c=relaxed/simple;
	bh=yZ5Xaaf9kgVtY/CKAQk/EBT0fxC2NoVV7MMvI8UQGoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE/J9uvjQuVL8YMPeAxzWhy2hRgcUvYBcgFJyGv22osiggkY31hfE8UMvvU8eKawk1HsEkwwTfHZPm+lK+Rt92Fu0Qr5ue4SczXRWVfm7X0JI/auA9m0DH2zTl1rl5OI9I/wwvXp/57f8X50oC7W284nqcJBF6ukFm8DftXD0Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Szet99d0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Szet99d0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4759FC4CEF1;
	Tue, 26 Aug 2025 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216331;
	bh=yZ5Xaaf9kgVtY/CKAQk/EBT0fxC2NoVV7MMvI8UQGoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Szet99d0630aTEoLZ+cSMGA/AkfFyi7Yv3Zy5v8XcCPSC1q/8j7qp5X6PC/PDuI6i
	 z9dz2URbiaHsBX5CTpjywo3SvfGMuw+h8c1NGVdAoFrLHevj68c2YkdNdHF/yFyCCR
	 qJW+lX6bF2e3atIhO2NmtZq4VCwT00wlEheHPJH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 371/644] gve: Return error for unknown admin queue command
Date: Tue, 26 Aug 2025 13:07:42 +0200
Message-ID: <20250826110955.610913587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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
index 54d649e5ee65..872b169b920c 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -389,6 +389,7 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.39.5



