Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF32B46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DA4C433D2;
	Mon, 16 Jan 2023 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886258;
	bh=Bd30rdhk3vhh7I9s4k/LqSG+zXtTS7pSwF8hT2TQz3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lytgfp3ij0AI7sbpu9eq//zOLMjUOybuo64x1T/ZlNxJIEi45EUySNiwCU8+3jTgQ
	 ficxIRsD0Vy9R0MUXx7D285BSMPuPapHRpOneYRWBojadNkS1Ipdt++piQjPLwjkzj
	 ueI/9F33vXYiDdSmuOwUOJnRN553Cetr4/8kD3T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobroff <sbobroff@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 363/658] powerpc/eeh: Fix pseries_eeh_configure_bridge()
Date: Mon, 16 Jan 2023 16:47:31 +0100
Message-Id: <20230116154926.193988967@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 6fa13640aea7bb0760846981aa2da4245307bd26 ]

If a device is hot unplgged during EEH recovery, it's possible for the
RTAS call to ibm,configure-pe in pseries_eeh_configure() to return
parameter error (-3), however negative return values are not checked
for and this leads to an infinite loop.

Fix this by correctly bailing out on negative values.

Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Nathan Lynch <nathanl@linux.ibm.com>
Link: https://lore.kernel.org/r/1b0a6010a647dc915816e44845b64d72066676a7.1588045502.git.sbobroff@linux.ibm.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 893ba3f562c4..04c1ed79bc6e 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -607,6 +607,8 @@ static int pseries_eeh_configure_bridge(struct eeh_pe *pe)
 
 		if (!ret)
 			return ret;
+		if (ret < 0)
+			break;
 
 		/*
 		 * If RTAS returns a delay value that's above 100ms, cut it
@@ -627,7 +629,11 @@ static int pseries_eeh_configure_bridge(struct eeh_pe *pe)
 
 	pr_warn("%s: Unable to configure bridge PHB#%x-PE#%x (%d)\n",
 		__func__, pe->phb->global_number, pe->addr, ret);
-	return ret;
+	/* PAPR defines -3 as "Parameter Error" for this function: */
+	if (ret == -3)
+		return -EINVAL;
+	else
+		return -EIO;
 }
 
 /**
-- 
2.35.1



