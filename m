Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B52027732;
	Thu, 16 Jul 2026 14:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211759; cv=none; b=CfPvN819cjgClEpnuFP4JLZEZ3OIPrW2/FAraZxfn03GVVcJWoiX0jt3ec8nRx+eW2zQLFp3CmH+ouUziagTTzMgctluHBEVY8eFTRdzTufgOebDOO8OkyscHU79Im3gR7HZYafzfwH6JyxuuGn6uF/pk74TUq8izbtBlpJbBSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211759; c=relaxed/simple;
	bh=edHrbQZP+2WQKMyM1Y4kmuIp8whvvQc25dvr6TzzVHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoKvzXQZUxafwW/KiccNYBt6pn1aGE4sHaA4YNJvAv2Xf70ldN/pEY5evzWIe1LHEe9wW2rrnFvWAk3ZMVBqGwPLwuU289RRJHcOs9dwdcIJC1T2gflfODHfHCeZ+kjyD1NR7qR6IJkqWJvWkYA6zHWASSBHdCjx36OseOnYqz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9tiqaZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9tiqaZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03AC1F000E9;
	Thu, 16 Jul 2026 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211758;
	bh=4UNj5A9Y/ycahC0Rv+ujRqCO+fK0PTDm75ktFrck1Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9tiqaZxd2cp/nmSbVSLFzFmAn1kC/5UcplQg4Vc9DhqXoQveddPpBhIhCqu5xI4m
	 NdxdkiR2Y2QP+9I1nz/PQGHRMqfahcbGI6bTLuUwVaIUps1gNOe8WRXDwqnQSV/6MW
	 774B7ij4E2f+LAEQa21eTUJYgvIq54/m3QwREAjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 069/349] iio: temperature: ltc2983: Fix n_wires default bypassing rotation check
Date: Thu, 16 Jul 2026 15:30:03 +0200
Message-ID: <20260716133034.865406597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liviu Stan <liviu.stan@analog.com>

commit 434c150752675f44dc52c384a7fa22e5176bc35a upstream.

When adi,number-of-wires is absent, n_wires is left at 0. The binding
documents a default of 2 wires, matching the hardware default. However
the current-rotate validation checks n_wires == 2 || n_wires == 3, so
with n_wires = 0 the guard is bypassed and adi,current-rotate is accepted
for a 2-wire RTD.

Initialize n_wires = 2 to match the binding default and ensure the
rotation check fires correctly when the property is absent.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Liviu Stan <liviu.stan@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -741,7 +741,7 @@ ltc2983_rtd_new(const struct fwnode_hand
 	struct ltc2983_rtd *rtd;
 	int ret = 0;
 	struct device *dev = &st->spi->dev;
-	u32 excitation_current = 0, n_wires = 0;
+	u32 excitation_current = 0, n_wires = 2;
 
 	rtd = devm_kzalloc(dev, sizeof(*rtd), GFP_KERNEL);
 	if (!rtd)


