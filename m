Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909DD322DB1;
	Mon, 18 Aug 2025 13:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523369; cv=none; b=DUoCB9fBd0iodra8eVsAApuVLyFc0tzkw5jzNIctNWrgOAKYmQWOTw1GjhLbe1bBBmI/o97zRDKWPgk3+gKbnywH7IilBkBAO4ySOlk3XfpErSTj9h7JuSCeWOzWClu2EdAzRi7tNTlCihzM2VpSH+NCUn+nqKG08yJuwvaJ1gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523369; c=relaxed/simple;
	bh=bzfEt7W+HFJm2JEGWXw9TcSwT+aueL6T5QG9/M8XS1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHXK+NxvuqXLAblyKY4LngOUuF99NnxlyIAvvNEDdI7jtc+ajk21GrAg8g3u9FIhrqt37EmC6QvRwuUVpl6OCTzO4dn/3kwusT3oih4PLZ/tvWrSGb77Ijbnm11CFniIg0FK3qAl2cbDW9Fqv79TUIt14JWYAW9l/YHBNka7u/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjRvMM37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjRvMM37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7C7C116B1;
	Mon, 18 Aug 2025 13:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523369;
	bh=bzfEt7W+HFJm2JEGWXw9TcSwT+aueL6T5QG9/M8XS1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjRvMM37xz74xY41HsWTLw5Eisf0btV38Wc2aWRUahuZThc3Fq57UZRXK4huebBKM
	 1CrMjRLRkKsStrL9q6cFZo+TnSUPNII3ez/V2ydCX4WyPEvs0ez08RW/Rw0KvKJ/Ip
	 gOcdUBoV79jzbDyDbiSals807Anhunyrx+37wkbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 149/515] firmware: tegra: Fix IVC dependency problems
Date: Mon, 18 Aug 2025 14:42:15 +0200
Message-ID: <20250818124504.114768381@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 78eb18020a88a4eed15f5af7700ed570642ff8f1 ]

The IVC code is library code that other drivers need to select if they
need that library. However, if the symbol is user-selectable this can
lead to conflicts.

Fix this by making the symbol only selectable for COMPILE_TEST and add
a select TEGRA_IVC to TEGRA_BPMP, which is currently the only user.

Link: https://lore.kernel.org/r/20250506133118.1011777-10-thierry.reding@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/tegra/Kconfig b/drivers/firmware/tegra/Kconfig
index cde1ab8bd9d1..91f2320c0d0f 100644
--- a/drivers/firmware/tegra/Kconfig
+++ b/drivers/firmware/tegra/Kconfig
@@ -2,7 +2,7 @@
 menu "Tegra firmware driver"
 
 config TEGRA_IVC
-	bool "Tegra IVC protocol"
+	bool "Tegra IVC protocol" if COMPILE_TEST
 	depends on ARCH_TEGRA
 	help
 	  IVC (Inter-VM Communication) protocol is part of the IPC
@@ -13,8 +13,9 @@ config TEGRA_IVC
 
 config TEGRA_BPMP
 	bool "Tegra BPMP driver"
-	depends on ARCH_TEGRA && TEGRA_HSP_MBOX && TEGRA_IVC
+	depends on ARCH_TEGRA && TEGRA_HSP_MBOX
 	depends on !CPU_BIG_ENDIAN
+	select TEGRA_IVC
 	help
 	  BPMP (Boot and Power Management Processor) is designed to off-loading
 	  the PM functions which include clock/DVFS/thermal/power from the CPU.
-- 
2.39.5



