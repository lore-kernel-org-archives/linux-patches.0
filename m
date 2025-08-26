Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C0C35A28A;
	Tue, 26 Aug 2025 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218728; cv=none; b=fLHaNdbVtT2NG3S0shTVXu+bK/RITZ4Jci76hvRhc8BF+8hwuHcD96FYwdPHCePS4PmQFA+6y8c53bS2ITdPNCdFobjGYnqVxxVeI2KODmXg+LOIHFE4iRFbc0ix+sBWO6n21xwb6zU+AXzLuEiDci/6G7EsV59MsaoaqME6xqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218728; c=relaxed/simple;
	bh=R+y+uewviSNgkgIUDs24gt6Tk98aDQqLeAQEK+IsNKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UufXwBhLEVwqGrsUie4rdRDJ5oIFuu4wh7gP+rgo2RSaW34JRfI0WnF7Ww/kR6vtCnD5iM/PDQSQqJ+DsypT2tQsRpN6Dxoq6pz3eBagpQJBtIfOf4yHJ8JIdY2lExTl7bAcNChfsSidnSisE5rTY0bUeiYeArtBU++BGgNDcJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC303Ybj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC303Ybj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134F6C4CEF1;
	Tue, 26 Aug 2025 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218728;
	bh=R+y+uewviSNgkgIUDs24gt6Tk98aDQqLeAQEK+IsNKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC303YbjIhhElNoYA8sZwYf9XoZ5Ubwx8hPkl/Q1wOOes8g+e3ri+KwlRb2fqlPej
	 nsuTkxVO+HEMJ3Q4loaRNKEZspkL4tZ6fgGsykyfrVK8YvU4X1qo71mshwQbjUnWxW
	 YUebOJ7uZ75yMFQyZC2EsrSWqnT6ofbOMVFZvDpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/403] staging: nvec: Fix incorrect null termination of battery manufacturer
Date: Tue, 26 Aug 2025 13:06:49 +0200
Message-ID: <20250826110908.951298969@linuxfoundation.org>
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
index 0e861c4bfcbf..590b801c5992 100644
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



