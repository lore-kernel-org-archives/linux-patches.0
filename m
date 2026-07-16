Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2BD3FE36E;
	Thu, 16 Jul 2026 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210202; cv=none; b=FwzSt5m4A7V/OFR7ThDHB74GDzVscy2huJ+v535KoYPnp+v+wGrF+dCYfNBsc7nhP9viF6PkazxHD9yqeEOXdPmZRGkbyOywyWrKGqnJlXNeyeWsW/V/cwgzspT/P4W0uVFivMhx7432cVNzhsPJmegu5Etq1oXyxI5+PL4lBLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210202; c=relaxed/simple;
	bh=IN7iveesY1JTUQzvfiAFWGUpJG7WYhzq+LN7BgL5jqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TITgCK7ECgMQvpdzrbdWBbQaS5SrBJXTAkMEQi9/dSPZY+wqjjnIbKYYyCtdJi5G/tr4uIobz+zcqkb/gbQGwWwwIulC8uzcjpmJ0OJkYoYej7f/FgxI8B7Z89DEhimfXxWo3S2EZDm1zSysCI6sHBzeNLPppe11V71wZ2SNCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz/9coaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz/9coaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EFB1F000E9;
	Thu, 16 Jul 2026 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210200;
	bh=U/AiYKPwn9TE0rSKKyMb5xsjjO3AHfWylAw2WjnSTg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mz/9coaAu2mWyvK27DzzfLfHT+ZIsYmRlNKvIcLCoR8j3Zd9g1WZDz1dCfY5pN4Yp
	 ue7+t6kvB3qqjxQlSTTARCGqsuZ5cYSW5PYF71rwpyygpX6eiBv82GBA58F/MAH25/
	 DeMRPsGBhARfMfkVLO9qDDaZk9f6WQTxY1zsR5JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 475/518] i2c: mpc: Fix timeout calculations
Date: Thu, 16 Jul 2026 15:32:23 +0200
Message-ID: <20260716133058.239375213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 2e9a7f68329be41792c0b123c28e6c53c2fa2249 upstream.

At first glance the harmless cleanup of the driver does nothing bad.
However, as the operator precedence list states the '*' (multiplication)
and '/' division operators have order 5 with left-to-right associativity
the *= has order 17 and associativity right-to-left. It wouldn't be
a problem to replace

	foo = foo * HZ / 1000000;

with

	foo *= HZ / 1000000;

if HZ constant is in Hertz. The problem is that in the Linux kernel HZ is
defined in jiffy units, which is order of magnitude smaller than a million.
That's why operator precedence has a crucial role here. Fix the regression
by reverting pre-optimized calculations.

Fixes: be40a3ae719f ("i2c: mpc: Use of_property_read_u32 instead of of_get_property")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.4+
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260618144934.3249950-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -844,7 +844,7 @@ static int fsl_i2c_probe(struct platform
 					      "fsl,timeout", &mpc_ops.timeout);
 
 	if (!result) {
-		mpc_ops.timeout *= HZ / 1000000;
+		mpc_ops.timeout = mpc_ops.timeout * HZ / 1000000;
 		if (mpc_ops.timeout < 5)
 			mpc_ops.timeout = 5;
 	} else {


