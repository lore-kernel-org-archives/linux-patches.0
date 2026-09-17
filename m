Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581B33DD85E;
	Thu, 17 Sep 2026 18:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670628; cv=none; b=GpqYshsNFLBtlWcQ6Q/OhPJrVUS8v0v/q4dgKFMvGm/c5YI4mEhIR7HEXxJSfN127itjTd5Puu+N/SyGoEkWPGgs8fXkKhGZdO4s2xtR0nzGzuyW+ZmxqsMvgkKLwKEjNP8gpKWdVf9fwOLkNSK88S0uLQ7qWSxwYVM4HznMlz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670628; c=relaxed/simple;
	bh=IoVCQhGap5fD0goTGngI8Bm9oPyM1YYVl1g0EyUOMRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgldvJMbcKPtjOFcfEv6ScTa+iv2danxPpnF7EBRiMZt85jDRMBmTkraQKddb0WlV4UGPP3OhPxToMbqe5gZ32rAlu7LC4i6HmLUuu7/GiRWcYORZ1FFT6fsYs1elyjJO8+uNlfrFdSugcSkMN2n+UF1s2XlJ09MfPLf18YuMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZL7A4QMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZL7A4QMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E191F000FF;
	Thu, 17 Sep 2026 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670627;
	bh=HNdvyUYK9SmIZ8EUZnKWNuufJQ1/r9KDjxeeLl2C6Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZL7A4QMGsJAr3V6TuqtiL3kXx7FwUqOIE0qSoNKDlFZCboUwld21vR/OJq+/dJZvU
	 1IwnsRhNLXTqfaxoaujVGVwOMQw2m97ozxHTx8HKQ3VWWn25Qy5ZR2WihxZcv1xFIc
	 pKkZIOf28SWz2/NgxSYhFbr3tfLCEZyUubC6+uT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XingWang Xiang <v3rdant.xiang@gmail.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0685/1102] net: mctp: i3c: serialize probe with bus removal
Date: Thu, 17 Sep 2026 16:10:28 +0100
Message-ID: <20260917151557.456504194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
Message-ID: <20260917151028.t_E8zwZ_dYFnDOoYIf6ZAvCLAP42J20HEYj5gLfZFgU@z>

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: XingWang Xiang <v3rdant.xiang@gmail.com>

[ Upstream commit 2b4707a149a55e8fa75c9ef32b359d60f470a566 ]

mctp_i3c_probe() drops busdevs_lock after finding the matching bus. A
concurrent I3C_NOTIFY_BUS_REMOVE can then unregister and free the bus
netdev before probe passes its private data to mctp_i3c_add_device().
The latter consequently adds a list node through a freed mbus pointer.

Keep busdevs_lock held until the device has been added. This also
satisfies the __must_hold annotation on mctp_i3c_add_device().

Fixes: c8755b29b58e ("mctp i3c: MCTP I3C driver")
Signed-off-by: XingWang Xiang <v3rdant.xiang@gmail.com>
Acked-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index fbcd48f1971a4..dd74f916e3172 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -288,6 +288,7 @@ __must_hold(&busdevs_lock)
 static int mctp_i3c_probe(struct i3c_device *i3c)
 {
 	struct mctp_i3c_bus *b = NULL, *mbus = NULL;
+	int rc;
 
 	/* Look for a known bus */
 	mutex_lock(&busdevs_lock);
@@ -296,14 +297,16 @@ static int mctp_i3c_probe(struct i3c_device *i3c)
 			mbus = b;
 			break;
 		}
-	mutex_unlock(&busdevs_lock);
 
 	if (!mbus) {
 		/* probably no "mctp-controller" property on the i3c bus */
-		return -ENODEV;
+		rc = -ENODEV;
+	} else {
+		rc = mctp_i3c_add_device(mbus, i3c);
 	}
+	mutex_unlock(&busdevs_lock);
 
-	return mctp_i3c_add_device(mbus, i3c);
+	return rc;
 }
 
 static void mctp_i3c_remove_device(struct mctp_i3c_device *mi)
-- 
2.53.0



