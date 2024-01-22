Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9B358127;
	Tue, 23 Jan 2024 01:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974062; cv=none; b=OIzArNDq9OKxmtZr6DNsQBOsrVi6MLElulnmm3V1sxQAditUIYPBmOmXBrJP6dSiIZw1sPGy95nf6WrcU39La4M3XlP4gr/Q051sgL3sISNLbPxdQrHoOibWk0bzJWxQsozPSawi35q2Mro7AeBy8sCOKpG+dhhjurgcg4h75zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974062; c=relaxed/simple;
	bh=t0lWGX7T/U0kl3g/dWUMVeUSkHmnhsszjD1/eyRDKzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hO3wkLdI2XJew+UnQLmwvlkp/6jdc8dAnnrTcAaXTBY04Sos1ZN3NXiWnrWiWL0A/SThpamWaydF+KukjNQ+GoYOH16netnN7DBrihdhxy+3kHXRYMBI7YTg5O4fUFzlukEXXaoajQnSM2msFwQYCSGdfCGACF8h4y2x8BpVyM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs/Uw/Aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs/Uw/Aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8A5C43390;
	Tue, 23 Jan 2024 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974061;
	bh=t0lWGX7T/U0kl3g/dWUMVeUSkHmnhsszjD1/eyRDKzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs/Uw/AaSk2HP1Tbk4VRyt8PmWyMIGGYWPl9g/UIWpXaiTKM7ktUlL3KD/uAZ+V0j
	 AHv3EL024aGxVXc/y6p/iNQr1wq0egaXR+ZipOPyE3e2+5XV97RGyUmRNjeU9B8lGe
	 Ea2YboNagET7VJNLUL4Ktk8MtEzB8J1TQr92kiTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/583] x86/mce/inject: Clear test status value
Date: Mon, 22 Jan 2024 15:50:53 -0800
Message-ID: <20240122235812.309158304@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 6175b407756b22e7fdc771181b7d832ebdedef5c ]

AMD systems generally allow MCA "simulation" where MCA registers can be
written with valid data and the full MCA handling flow can be tested by
software.

However, the platform on Scalable MCA systems, can prevent software from
writing data to the MCA registers. There is no architectural way to
determine this configuration. Therefore, the MCE injection module will
check for this behavior by writing and reading back a test status value.
This is done during module init, and the check can run on any CPU with
any valid MCA bank.

If MCA_STATUS writes are ignored by the platform, then there are no side
effects on the hardware state.

If the writes are not ignored, then the test status value will remain in
the hardware MCA_STATUS register. It is likely that the value will not
be overwritten by hardware or software, since the tested CPU and bank
are arbitrary. Therefore, the user may see a spurious, synthetic MCA
error reported whenever MCA is polled for this CPU.

Clear the test value immediately after writing it. It is very unlikely
that a valid MCA error is logged by hardware during the test. Errors
that cause an #MC won't be affected.

Fixes: 891e465a1bd8 ("x86/mce: Check whether writes to MCA_STATUS are getting ignored")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231118193248.1296798-2-yazen.ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/inject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 4d8d4bcf915d..72f0695c3dc1 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -746,6 +746,7 @@ static void check_hw_inj_possible(void)
 
 		wrmsrl_safe(mca_msr_reg(bank, MCA_STATUS), status);
 		rdmsrl_safe(mca_msr_reg(bank, MCA_STATUS), &status);
+		wrmsrl_safe(mca_msr_reg(bank, MCA_STATUS), 0);
 
 		if (!status) {
 			hw_injection_possible = false;
-- 
2.43.0



