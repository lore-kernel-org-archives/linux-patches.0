Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C68913B2A2;
	Tue, 27 Feb 2024 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042873; cv=none; b=Da8kleGxb52ILKSq8/468FrigFI7EjjlV1MvP4AMYOZy/Ybhn7zJEf6EIf11Sw9M3RzUSNszjJ6i7Ek3opHpJ21c5in5htwcs0hXlymvtC8im0CsfHQcE25FYEQF278WVJRvUDizs8ISF40uXCY+rF9H6xvsBhAgYDoiQVDNNzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042873; c=relaxed/simple;
	bh=xvVwZqjgO6swRW5A3+UWiNzZSE/jpakZQtrCpj1TNM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoIEh2TU81HmPaUDRv5uzi4wHti81MJG7/8eGm5UJxomYy+MAB12k6RixE525WAzjznGvML4sIfBltCnJZ5t80+LJIcyNQTvlisfU7Mn/oNFVC+zWjmIkTlCVjc0Vz3zla8L6OA9uRUJG/XBhGmy/dCuygdWfgtNWcmcfFrFTVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FauUXY02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FauUXY02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF42DC433C7;
	Tue, 27 Feb 2024 14:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042873;
	bh=xvVwZqjgO6swRW5A3+UWiNzZSE/jpakZQtrCpj1TNM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FauUXY02OhNA9XNgd3oughmQNaOFUArLuCt2Rn3iJCmDNRN8AQ88Dk8bjBD+b8hOR
	 +SlGLyuuwOtBQ7da84ckfN4CUhj2IiLhQ+ZyAXAEAmi4JuiTeqx+nPg/XKcoI8ukDV
	 /dxSlH8+mM2YRGWfyzfBuk2PS9qula1QfZiYBnYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/245] powerpc/perf/hv-24x7: add missing RTAS retry status handling
Date: Tue, 27 Feb 2024 14:25:12 +0100
Message-ID: <20240227131619.258422822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit cc4b26eab1859fa1a70711872caaf6414809973f ]

The ibm,get-system-parameter RTAS function may return -2 or 990x,
which indicate that the caller should try again. read_24x7_sys_info()
ignores this, allowing transient failures in reporting processor
module information.

Move the RTAS call into a coventional rtas_busy_delay()-based loop,
along with the parsing of results on success.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 8ba214267382 ("powerpc/hv-24x7: Add rtas call in hv-24x7 driver to get processor details")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230125-b4-powerpc-rtas-queue-v3-2-26929c8cce78@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-24x7.c | 42 ++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 284ccc90fb11c..f68fa53f4b1a2 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -79,9 +79,8 @@ static u32 phys_coresperchip; /* Physical cores per chip */
  */
 void read_24x7_sys_info(void)
 {
-	int call_status, len, ntypes;
-
-	spin_lock(&rtas_data_buf_lock);
+	const s32 token = rtas_token("ibm,get-system-parameter");
+	int call_status;
 
 	/*
 	 * Making system parameter: chips and sockets and cores per chip
@@ -91,32 +90,27 @@ void read_24x7_sys_info(void)
 	phys_chipspersocket = 1;
 	phys_coresperchip = 1;
 
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				PROCESSOR_MODULE_INFO,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		call_status = rtas_call(token, 3, 1, NULL, PROCESSOR_MODULE_INFO,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		if (call_status == 0) {
+			int ntypes = be16_to_cpup((__be16 *)&rtas_data_buf[2]);
+			int len = be16_to_cpup((__be16 *)&rtas_data_buf[0]);
+
+			if (len >= 8 && ntypes != 0) {
+				phys_sockets = be16_to_cpup((__be16 *)&rtas_data_buf[4]);
+				phys_chipspersocket = be16_to_cpup((__be16 *)&rtas_data_buf[6]);
+				phys_coresperchip = be16_to_cpup((__be16 *)&rtas_data_buf[8]);
+			}
+		}
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		pr_err("Error calling get-system-parameter %d\n",
 		       call_status);
-	} else {
-		len = be16_to_cpup((__be16 *)&rtas_data_buf[0]);
-		if (len < 8)
-			goto out;
-
-		ntypes = be16_to_cpup((__be16 *)&rtas_data_buf[2]);
-
-		if (!ntypes)
-			goto out;
-
-		phys_sockets = be16_to_cpup((__be16 *)&rtas_data_buf[4]);
-		phys_chipspersocket = be16_to_cpup((__be16 *)&rtas_data_buf[6]);
-		phys_coresperchip = be16_to_cpup((__be16 *)&rtas_data_buf[8]);
 	}
-
-out:
-	spin_unlock(&rtas_data_buf_lock);
 }
 
 /* Domains for which more than one result element are returned for each event. */
-- 
2.43.0



