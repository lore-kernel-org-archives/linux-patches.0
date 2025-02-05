Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F4714A4E9;
	Wed,  5 Feb 2025 14:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764312; cv=none; b=APuYKaynAiB3Gv5td86tNEfyTPNu0j5zMM4hYEdnR0CWLmH08BBcz9cStjlO/T0kgp2eSaWmKg8TjOP/toTsjFX5s21nW9FU/+Lqc6y4/ejW2jIo6yxjv3XiePciKHZe4utA9caJ56QPbX5/hrWNTOAp08HwXDSRZPBX9Humlfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764312; c=relaxed/simple;
	bh=00tjWKgJNYNKUOjRuaDtaKFBDyVSbqbENzrpd9XLaJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlAMAQ3nWc+HR3P9F7BLwjnrkYX/+4XgCObPdNWsIX+M+8TAOCRmXN3ewsOBAjC5SL8QBO97ON2uE+oYh6UjPZ/7bRdlua/751ZED+3wmAox4WK0PGUlxK1BV0OK1laajqwdQR/zDWAKE8EtJkQedRqAfyip4QCswd0wZCinMSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0n/8BE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0n/8BE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279ACC4CED6;
	Wed,  5 Feb 2025 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764312;
	bh=00tjWKgJNYNKUOjRuaDtaKFBDyVSbqbENzrpd9XLaJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0n/8BE44Y6sBMAA6zQOHfewVRkiA/C1o7owV5Fgk3fqP+uMXTSmOhxoWRVEuEwkZ
	 bORtfbcUZVhDk+xEMGMm4WcTTnkYnr/wwj6pOVVU1jb9ktOwozaANzyre+BfZgiIAs
	 KP3AJl4FyNGHq3f/zxF8XDPCJ/JivJTfczhfBCAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 066/623] OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized
Date: Wed,  5 Feb 2025 14:36:48 +0100
Message-ID: <20250205134458.749041183@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit b44b9bc7cab2967c3d6a791b1cd542c89fc07f0e ]

If a driver calls dev_pm_opp_find_bw_ceil/floor() the retrieve bandwidth
from the OPP table but the bandwidth table was not created because the
interconnect properties were missing in the OPP consumer node, the
kernel will crash with:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
...
pc : _read_bw+0x8/0x10
lr : _opp_table_find_key+0x9c/0x174
...
Call trace:
  _read_bw+0x8/0x10 (P)
  _opp_table_find_key+0x9c/0x174 (L)
  _find_key+0x98/0x168
  dev_pm_opp_find_bw_ceil+0x50/0x88
...

In order to fix the crash, create an assert function to check
if the bandwidth table was created before trying to get a
bandwidth with _read_bw().

Fixes: add1dc094a74 ("OPP: Use generic key finding helpers for bandwidth key")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index cf32e642da027..47b1068bb9891 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -116,6 +116,15 @@ static bool assert_clk_index(struct opp_table *opp_table,
 	return opp_table->clk_count > index;
 }
 
+/*
+ * Returns true if bandwidth table is large enough to contain the bandwidth index.
+ */
+static bool assert_bandwidth_index(struct opp_table *opp_table,
+				   unsigned int index)
+{
+	return opp_table->path_count > index;
+}
+
 /**
  * dev_pm_opp_get_voltage() - Gets the voltage corresponding to an opp
  * @opp:	opp for which voltage has to be returned for
@@ -890,7 +899,8 @@ struct dev_pm_opp *dev_pm_opp_find_bw_ceil(struct device *dev, unsigned int *bw,
 	unsigned long temp = *bw;
 	struct dev_pm_opp *opp;
 
-	opp = _find_key_ceil(dev, &temp, index, true, _read_bw, NULL);
+	opp = _find_key_ceil(dev, &temp, index, true, _read_bw,
+			     assert_bandwidth_index);
 	*bw = temp;
 	return opp;
 }
@@ -921,7 +931,8 @@ struct dev_pm_opp *dev_pm_opp_find_bw_floor(struct device *dev,
 	unsigned long temp = *bw;
 	struct dev_pm_opp *opp;
 
-	opp = _find_key_floor(dev, &temp, index, true, _read_bw, NULL);
+	opp = _find_key_floor(dev, &temp, index, true, _read_bw,
+			      assert_bandwidth_index);
 	*bw = temp;
 	return opp;
 }
-- 
2.39.5



