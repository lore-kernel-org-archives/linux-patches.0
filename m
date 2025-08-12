Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D405257435;
	Tue, 12 Aug 2025 17:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020983; cv=none; b=c1bapCH6MzimSS3mjZ/xZodasancxgVZUGZBin+9tsHYdfKmVuyaVXNJkW7GqQPrC5egI5jQK/E00Qe7mhL+zhKyVj1+yBGGuezcKnC3olwQfLCTr2PXM3D/8BqG5FXOzm0Z2npgxCcVfeeA6Uc1Nq+3haY2tD18yNp8UCnJpbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020983; c=relaxed/simple;
	bh=DKOZLerO13TcJZd+6GnMUKPiAEaCUCQVbCSI3kwqB9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPGvEhvJhHUA7+0AP/DYWRcPCjXRk8lWiUDw55L6EcwVyJZHmMyrwP5ca1c1hfbZlKQCtaaAMCQ/ICedmzqoLniNQ2Wy6X3A07bqnsZUb7ZWi86KDZ+mGf28LgjaifLKXRNFN1pioQCCoQ8vC2qYZOqr4pQwhZIjk7nqN30BekY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJWvafle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJWvafle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FED3C4CEF0;
	Tue, 12 Aug 2025 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020983;
	bh=DKOZLerO13TcJZd+6GnMUKPiAEaCUCQVbCSI3kwqB9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJWvafleEWO5S4FAGUGH9Yq7mWNnDZ+I/knYP+Ip4XatQ+EjJqWUNxmgGzOgkXpRc
	 k6zeshEOUVg8RzNq7oXZRDc9eI7A7ZJ2ZYF6xbQZKvQckqIgV8WC70aoJNfYRlqQ9I
	 yFWT5YQMsFC/STm993VNru3kaOpP1JXWaGVc0ivM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/262] staging: nvec: Fix incorrect null termination of battery manufacturer
Date: Tue, 12 Aug 2025 19:27:14 +0200
Message-ID: <20250812172954.929100013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit a8934352ba01081c51d2df428e9d540aae0e88b5 ]

The battery manufacturer string was incorrectly null terminated using
bat_model instead of bat_manu. This could result in an unintended
write to the wrong field and potentially incorrect behavior.

fixe the issue by correctly null terminating the bat_manu string.

Fixes: 32890b983086 ("Staging: initial version of the nvec driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250719080755.3954373-1-alok.a.tiwari@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/nvec/nvec_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec_power.c b/drivers/staging/nvec/nvec_power.c
index 9943b1fff190..573521e1703b 100644
--- a/drivers/staging/nvec/nvec_power.c
+++ b/drivers/staging/nvec/nvec_power.c
@@ -194,7 +194,7 @@ static int nvec_power_bat_notifier(struct notifier_block *nb,
 		break;
 	case MANUFACTURER:
 		memcpy(power->bat_manu, &res->plc, res->length - 2);
-		power->bat_model[res->length - 2] = '\0';
+		power->bat_manu[res->length - 2] = '\0';
 		break;
 	case MODEL:
 		memcpy(power->bat_model, &res->plc, res->length - 2);
-- 
2.39.5



