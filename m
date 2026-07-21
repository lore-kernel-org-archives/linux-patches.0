Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5D947010D;
	Tue, 21 Jul 2026 20:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665439; cv=none; b=lRr97uXFEwbfIprkeYCnsiDucT7w9NWbaVcqiM4esdvxRuLwxNu9XpzPLVUmEsimjW0W0bp+15kVTqHT3ddppl3gxA6nfA2NENh99Uggr6hNTDlOBGSqUw4Oc5RLLDAXRPIBuvHk9yvRVHBAJlMgHH0lKIf5U6yeOaVHTxbgy+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665439; c=relaxed/simple;
	bh=tW7eY1rCDFecTrbQw/ThYJZDl+9cAI8YLtbArcogVs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlAw3a81hagrMMJO6mxaQarRoz9F/ttdDuALYUvOxvZv33Zo62ulCj4odxFK1yVszQcg63FISEcG/AM337nRxpXManAeviwgSVTd0yDLZaQCZ31Y1/3qc8XdKARCy0LfPCuabdn7ZyEfbDB+F3qTHhASy1MUYts5lVDPavCsAEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqszfvtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqszfvtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541CC1F000E9;
	Tue, 21 Jul 2026 20:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665437;
	bh=QlhRrxePLHdSGVTF+vdtDDY8xA5mOv1I6GG9zLYddIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqszfvtlNm59zelgONZ2QdKRDpUL6CSVgh/W/fSJXXDrOiCtu7RWdy6quL9NYftiT
	 Fee4Plhgdglbp0OlVK7+edgw142XGKZmnDHzqHbHuU0vvkDXPmiRoaxmYP4XwA2kn9
	 x5pLxy2tS6saQu6VB0wDPMXjuLpUg/3mbZKAR9g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 0303/1266] i2c: mpc: Fix timeout calculations
Date: Tue, 21 Jul 2026 17:12:20 +0200
Message-ID: <20260721152448.608950947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -857,7 +857,7 @@ static int fsl_i2c_probe(struct platform
 					      "fsl,timeout", &mpc_ops.timeout);
 
 	if (!result) {
-		mpc_ops.timeout *= HZ / 1000000;
+		mpc_ops.timeout = mpc_ops.timeout * HZ / 1000000;
 		if (mpc_ops.timeout < 5)
 			mpc_ops.timeout = 5;
 	} else {


