Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888754ABBA1;
	Thu, 17 Sep 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665757; cv=none; b=ipSfTA+hZHtOQiH3sguPPD9kliSiNubqB/6FywWaMKlQOqUUo1CzJjd0CRVzvEThSEleHIkBEf4kktKGItoSAP5cUMkc/0ips+5PfaRpRj+YNdKnDCOEMAuwLQewfRRCQoFjRj///7OuiYSdTnMlArWHoI2MH5MBXmYuRq2pJQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665757; c=relaxed/simple;
	bh=wfLsiOC5DbSbJx/gNAK9jAHXav/s6U3vLNDs5vA6+QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIPkXiwxtB3WRWmjbeO82O/9DvRhihI+s9fYGqZwvBtUGRcvvLpDUHVBDSzA5C77nrEQ3qPkEwdMtSSPOkuLyzsfKwRbZgEAL6LhyGhVWmOFNIfH1s4x5kRopUxnA4wnwWXl+HwyGmyrukF1LglBEFxpjLTfHO82MKqRDCmSbB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItTD+89d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItTD+89d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A441F000FF;
	Thu, 17 Sep 2026 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665756;
	bh=mHfbJp62jGur6DwPLgEN7no30GAeucyJU9KTjoP2rXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItTD+89ddFanbZ1vfu0F5r2YhqhvVELSWh82wPRUSzLD6tRWLGW24BNpmSCjkA2fE
	 Uj6zFdjGI8mZH1dA3EHIHb8vBmdXsejMmnVQOMn8MR0vJDCD6LeMG4FAl99XVVLJue
	 xJkWRgy7dNTfu05CXxZlnkM2G1gctV2ylEPG9dLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XingWang Xiang <v3rdant.xiang@gmail.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0809/1250] net: mctp: i3c: serialize probe with bus removal
Date: Thu, 17 Sep 2026 16:10:04 +0100
Message-ID: <20260917151613.843733468@linuxfoundation.org>
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
index c5d0bc517fea9..1d9d0c1418ebd 100644
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



