Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE3026FA77;
	Tue, 12 Aug 2025 19:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025628; cv=none; b=RakOq2YpjVrUhlgkjYV30buDoY/OTUDxcN75tH4IbmEXyUg86JllgMRKk9Wfq44kFQ2XFFZmx14KJnGv5OGUDFUVSkx8mSJcSvZGLaxdVp3qFM1sB8ru2q7ssE8JQBdJOHCQ9Vjxjb5kKL/wqFjaJXpHac/ZpDjDACXoMYFn40I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025628; c=relaxed/simple;
	bh=H6q/MhtucjK9G8/dtwj9HTK2gIyum3o2IU5FzXotpfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psPTEWMCPjpj1jqZsTFRxQnBDtXX/ptFFLecGFy6c0aD1cfrBevXCTIZ+p0dgkkXMtiIcTXDtY9bfF+cFUWo6mCT+wXQYMSmjxMP4KEb/0FXcpO4fxk9z0IYxB6JXJJT40y/fmxsZq4AG8pCGYj8QSXPBsoPXVB2YtUhxQ332Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vA7SEKOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vA7SEKOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B933DC4CEF0;
	Tue, 12 Aug 2025 19:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025628;
	bh=H6q/MhtucjK9G8/dtwj9HTK2gIyum3o2IU5FzXotpfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vA7SEKOXvA3Vq59tpE4+zE3MAClWBAZDv0yltmALlWdAAukgEut0QCFttGQ9iZWyI
	 IWqJIq6dt9FSE4sselDTcBiKYaRuiE63wwglj7tutd3jn+YkK8acyig52ds/7i+nf5
	 P8mZa3jrOHx1k2zMuTnb4FL57c7w+8ToKKscqNSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 097/480] staging: nvec: Fix incorrect null termination of battery manufacturer
Date: Tue, 12 Aug 2025 19:45:05 +0200
Message-ID: <20250812174401.458304179@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e0e67a3eb722..2faab9fdedef 100644
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



