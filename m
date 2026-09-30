Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EB84F3924;
	Wed, 30 Sep 2026 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788797; cv=none; b=ROt83MfQ030qoSbeDu7kPtWnBVayJqKy9lIktUtG3aFZIswSlGyi2T+9fujTWfT+GYIDRsCRzWLNpGsSv6a1iehK1reP4yRf0MjJDgBCjX1SS7udJ8du+YNxtZ4/v/soNonNFqsenYiAxqR4RBWRRNeK2RMF/S+KAsnc7oN9bE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788797; c=relaxed/simple;
	bh=hPAqLvJPvPI8vouYqhgkug2cCdhy1LYitgpBWFo57kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv9Se8XKeNFWdTUxbH4YJfxFOktKyW7K3GGRoMSd1m20C3I8QzWlc/abP8hRXUo/viU454/N9/ypXm0q9IzCeR2BCnjrOp2l6TXWi/9NaNcLVrm7lp69hV466ME0kkA8rxbdAL3A2DuZBW9gTxpv4ATasO97deA34PINd0d/D7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkzLgl/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkzLgl/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3091F00898;
	Wed, 30 Sep 2026 17:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788795;
	bh=7W7o0qfV7FK97JP7OxurKwsCiEc6JSe3dhbuvlUMJDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkzLgl/wfYe0hef3gXqlmX7q1FMW/+DccF3GjDwBnLjN0hNY3f3zTEk6a9xIrqnjh
	 nJ7W1JPg2aEQp5nPYaigj7ETgQAQsn/59x2gq7i1foFtvWyAV2TwkErQDRyVm35Lvt
	 SgTV4JOeS9mCNskACgH5hE4JIVtUp2tq/2JH0AXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 249/877] hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676
Date: Wed, 30 Sep 2026 17:19:20 +0200
Message-ID: <20260930152420.095879981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 089070b51ccbac411462a30a454690274c6e4270 upstream.

tps53676_identify() derives the number of PMBus pages but does not
ensure that page 0 is selected for single-page configurations.
pmbus_set_page() does not update the PAGE register when info->pages is
1, so if boot firmware leaves PAGE set to another value subsequent
register accesses may target the wrong page.

For single-page devices, select page 0 explicitly.

Fixes: cb3d37b59012 ("hwmon: (pmbus/tps53679) Add support for TI TPS53676")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://patch.msgid.link/20260916235406.681131-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/tps53679.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -181,6 +181,15 @@ static int tps53676_identify(struct i2c_
 	if (phases_b > 0) {
 		info->pages = 2;
 		info->phases[1] = phases_b;
+	} else {
+		/*
+		 * pmbus_set_page() does not update the PAGE register on
+		 * single-page devices, so select page 0 explicitly in case
+		 * the boot firmware left the device on another page.
+		 */
+		ret = i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+		if (ret < 0)
+			return ret;
 	}
 	return 0;
 }


