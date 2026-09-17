Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3C14ABBBF;
	Thu, 17 Sep 2026 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660987; cv=none; b=aFTkI/dJDQ4oa4Q6Iy3nBumqJa5wgkF08aMOXDz8J7yf0SlsDA4ipvRfhT+LHuV4UzR3NGzgN9QMiFB8GcwyyM2raHtnU6Q9D+CnhVtoBqDnUZLctTcPVb5fT84NzCUY04SH9ILuikdhjrJyEsoWRq4myBcrIQsMTvxXT0hJedc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660987; c=relaxed/simple;
	bh=v3mO7HkTic0ztPyqDXvhABWjjEWlYy0A0Zt5LQElPGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8E/Zb2fZq5JihDTy0qAzQSihThtTrmBh5Ix+X12n08jXW/Cgj8kZOqQRHzfKtso8eIu/+TFduM6kb+jcMLDUFr3evqXwF8KEPrWV+TB0HGAuj/wNMy2qHIlvDT5+YfaG/yUrMQh/6vorykHCpvQowK1kB/iyT43AfGFjOSZoZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VGhe+2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VGhe+2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629221F000FF;
	Thu, 17 Sep 2026 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660985;
	bh=pRM9SkAQOtfXEi+msdx/FX0+m44EvrmIg9VbFZ9F+GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VGhe+2CAYNuUL4lBCFl+0Di7rSkbdj0xtyFuO9Le4piROV3/PB9b4lBnb2rrBtSj
	 asf0bXh14Qqi8h6L6hn1O311GSvFNOqndINkhvExpdRFYRHGAy01Vi+wqzGh1YtLcY
	 RCFRW/5HIKxNNCTHzU55WvMIBSJKeU78aNNQti10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0045/1250] soundwire: validate DT compatible before parsing it
Date: Thu, 17 Sep 2026 15:57:20 +0100
Message-ID: <20260917151553.158773048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 45c7bda7b7440183850012153988e40b300f40d0 ]

`sdw_of_find_slaves()` fetches raw `"compatible"` bytes with
`of_get_property()` and then immediately parses them with
`sscanf("sdw%01x%04hx%04hx%02hhx", ...)`.

Live-tree OF properties are stored as raw bytes plus a separate length;
they are not globally guaranteed to be NUL-terminated. Validate the
first compatible string before parsing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260403183504.4-soundwire-compatible-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index 3d4d00188c26c..3c84027692460 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -240,8 +240,8 @@ int sdw_of_find_slaves(struct sdw_bus *bus)
 		struct sdw_slave_id id;
 		const __be32 *addr;
 
-		compat = of_get_property(node, "compatible", NULL);
-		if (!compat)
+		ret = of_property_read_string(node, "compatible", &compat);
+		if (ret)
 			continue;
 
 		ret = sscanf(compat, "sdw%01x%04hx%04hx%02hhx", &sdw_version,
-- 
2.53.0



