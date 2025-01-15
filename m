Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94ED248BD0;
	Wed, 15 Jan 2025 10:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938701; cv=none; b=siI5liiuoBiyCav93QNyZqLQB8ilD2G/BIlXW8R2cHfIS0lwQP3Mw/6tvbSQxbUMjox0tqOZRydQLNlodTf8wLhYIB07WGCXfrt+34KBiNYSnhugBeuhO2BJveG3szsVdJRLBo/ZkyPJs4ccHUzPOPYG+IZkfbCdXd/TUlDDABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938701; c=relaxed/simple;
	bh=O0qxxGCIujx4V8PdUMliPkRD5JIN1f515OITJv90q84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SobbXCwBMhSDEfrmgn8DU8T25nO1go/UiLH0IiVREAW20LgGhzI90MUfIP+m1tFIFurzsF0zaTGtgQEXvxcJHSAQMynt4YkGNigz2xMgkiFHd3Rf5mnwqBjBChM2AJP8nf4y9ZMlVaL5M+6AuSam1MgzewW2qDmIJSCvjQR5g1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGCW9ypp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGCW9ypp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5FEC4CEDF;
	Wed, 15 Jan 2025 10:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938700;
	bh=O0qxxGCIujx4V8PdUMliPkRD5JIN1f515OITJv90q84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGCW9yppf4SEvgZBDP7PDvqzaGxnCzEPOvUmisdVs9E4zHn0T/jcpTMn2fh3Ttv7m
	 BTYbbmbqeMa+MRTIb0RuCLThiV5OZVMdGCMnBlG48m/BiMHM7uSHmNDkZZSC8T4flN
	 jwwgIn7iy0JtyycSkJ53sllJzsRPmM58OIUuowrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/129] thermal: of: fix OF node leak in of_thermal_zone_find()
Date: Wed, 15 Jan 2025 11:37:24 +0100
Message-ID: <20250115103557.128763222@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 9164e0912af206a72ddac4915f7784e470a04ace ]

of_thermal_zone_find() calls of_parse_phandle_with_args(), but does not
release the OF node reference obtained by it.

Add a of_node_put() call when the call is successful.

Fixes: 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree initialization")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241224031809.950461-1-joe@pf.is.s.u-tokyo.ac.jp
[ rjw: Changelog edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 4e5f86c21456..0f520cf923a1 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -203,6 +203,7 @@ static struct device_node *of_thermal_zone_find(struct device_node *sensor, int
 				goto out;
 			}
 
+			of_node_put(sensor_specs.np);
 			if ((sensor == sensor_specs.np) && id == (sensor_specs.args_count ?
 								  sensor_specs.args[0] : 0)) {
 				pr_debug("sensor %pOFn id=%d belongs to %pOFn\n", sensor, id, child);
-- 
2.39.5



