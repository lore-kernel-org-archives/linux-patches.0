Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96FC1AB6D4;
	Mon, 14 Oct 2024 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916910; cv=none; b=jpuVRYGSaE9e70KHSleSTKZDDexxWu5mWAO0bAdQsB+qZg6L2l0A7Ds7p6PF3M54wai2C8Mll3fx9/enCmVtSVJqOlhAZa+HRHLEZp5xk1JGJhUnzJcvC6mZn3MqBBx+t339TutU28eCrgyP6q4oPRouz8Qrnq8I2a4T9hb8u/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916910; c=relaxed/simple;
	bh=DMozZe/7oDw4lQwbHiMcbO+ntzyGYsNjxm+QzGVFrto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6nMU/DSnvFNVZ7PURTeDQ1UMX/wWu8P0DGNK3eefyp8LKfEUe0cRf2/ZCHa8g0laY8coG6ntP3utyorzPtYmnGon7CZBjyWUyHHRWFlMBlaNMKLIR40izexu8BMgRoHcu+gc3frNLJ7tF1C068sf7G35UC8vkn2Tm8UKaxd58M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7daue66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7daue66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB49DC4CEC3;
	Mon, 14 Oct 2024 14:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916910;
	bh=DMozZe/7oDw4lQwbHiMcbO+ntzyGYsNjxm+QzGVFrto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7daue66kC8DMbozDU1bkbDAipcjms+zw1DohTNs1hCiCTisUF32mtCZQQoj/eBux
	 Rexzey51PA1TVsvv+pAeInYBu77FDMeH+TtdMYgzwwXKT+HpmYC4bFGRFlmdj6sIqf
	 Uinfkha1L3mA5w2UuzsOqcugar1cYW7rj5+775gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/213] driver core: bus: Fix double free in driver API bus_register()
Date: Mon, 14 Oct 2024 16:20:05 +0200
Message-ID: <20241014141046.833395141@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit bfa54a793ba77ef696755b66f3ac4ed00c7d1248 ]

For bus_register(), any error which happens after kset_register() will
cause that @priv are freed twice, fixed by setting @priv with NULL after
the first free.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240727-bus_register_fix-v1-1-fed8dd0dba7a@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index d7c4330786cae..e7761e0ef5a55 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -920,6 +920,8 @@ int bus_register(const struct bus_type *bus)
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&priv->subsys);
+	/* Above kset_unregister() will kfree @priv */
+	priv = NULL;
 out:
 	kfree(priv);
 	return retval;
-- 
2.43.0



