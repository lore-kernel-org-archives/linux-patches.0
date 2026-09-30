Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39457502D5A;
	Wed, 30 Sep 2026 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792309; cv=none; b=lJaV+Z/EjAW6JpO8WdnfmSyq/K6myZ7F55opgE6icfOY11xCaUGF82yZ7+GmNriOBiUWXHHAAsA2U27Grhm/Uw5Ke/eeRPdKXkYR79Akfg/WJSGOUzcMLXs+6iNREptx2jE3ecTWPTt7eT3oUlEe7ylugkgFKlmrcwafNb0qTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792309; c=relaxed/simple;
	bh=mDp9X+AFOw4TSeqojwDNtFvq15RUR1wcPO7wgFALF0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+Q2bTk/rYrYF3L9PjV4SlL8dm4OBVBF0TxmZWMX70PzwFN/rCvwuMfFgvMXNOTqzNyhthbJm5xeaDf4GylSmYKvded4NyNdHdzKpmLRSxH9k+sLMgQm7ygHigiV5UHaCES0alUAv/tD3so9yEjzJay/ouA0DcYhEsJjdxiFEHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJhB7caY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJhB7caY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920191F000FF;
	Wed, 30 Sep 2026 18:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792308;
	bh=avbQFADNBABwxwwdxXDQK6Pjeyck2z4Df2510O2rIHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJhB7caYqFj+QPRri6c/mH9gtQ31tXh+X1yMkT7mUvoQY4q74l5Fp3A+l+tDUoBGr
	 lnKgcJjSuSEADAxSHbkQwW7gClwkWYgZI6pUwnEq2pmQqcp21ZcBMGi0PEty5Mft74
	 GNebO5OUko9m1xtkmhPzXyvDm8qTPq3eu9qRgOFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 564/752] hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676
Date: Wed, 30 Sep 2026 17:27:14 +0200
Message-ID: <20260930152410.441644607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


