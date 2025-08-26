Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA12345758;
	Tue, 26 Aug 2025 14:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217303; cv=none; b=aMDWDshBSo65K8EttHafoXBYrnWFl/+C3HDSPmGZ6E7yToJxP59sEVwhAl1O99RDAbCkTUhRQaZJNPMtfsEo5WSM0di5F1ETrsHQ1bH62AQT2F1V398SHfjuvanBv/AUJF/ZvfiHbu4fqHOE3xSs9xIVx1Za/rYXe7/twZorUxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217303; c=relaxed/simple;
	bh=7qjgB5e8tLCbzJlwCiAv8cAFGo6vTL+8gVyIHagJX70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9IfoeOpOpsHDpf9CKnakAucb3hbVhQyRrdtAKQo6zyakk2GY5qjyQDkutAmBQ6TdOHVWL0+0Wu7FxOl2Ukgr/ozEQAt1MAhtyC7JXGPrLQXhyH+4GS9anQykwOeHLBXUjpZ2fckTAbJ5pDff2d60pyR4rQmy5yRf+6REvDEjoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0mXj+o0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0mXj+o0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20150C4CEF1;
	Tue, 26 Aug 2025 14:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217303;
	bh=7qjgB5e8tLCbzJlwCiAv8cAFGo6vTL+8gVyIHagJX70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0mXj+o0yGfG4lcVmIOqSbYmCateZgmYu7AanVngCobnlAD0sggvbAZaJt2pK2sa6
	 abmWXF9q0buhFFvFo075hy85v94UHWpV5UFbnU5yQ96Rapcyhv0t1VdsqsJPmG1rva
	 xW+tbkc+24rwyi7wNl15Tq1reyDK6Sr7FgeD0AKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/523] staging: nvec: Fix incorrect null termination of battery manufacturer
Date: Tue, 26 Aug 2025 13:05:02 +0200
Message-ID: <20250826110926.818084301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



