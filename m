Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D012E22A3;
	Mon, 18 Aug 2025 13:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522571; cv=none; b=BLwD2zwj+hCExaq+eqIcAzLL6T5y8JxmsHwsXTpzKzObiI2yU1IX/xlXFhVu2EpoZGMbnE2HY4jy4zT1hvhvxdNZgC4o7kqk38SFH5cUo5CHomXMDmqOqTI4xCA1qQ4NXcY1CFvSGQ3P3WUrvMdXN1PnJjpfKfVQSgzytkWndoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522571; c=relaxed/simple;
	bh=PZHZrZDnY4KSdC/GPl6Tc4BGR5moAHlS+L8ffLFqMbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8xl/ha70uFdOgwm3aBZKlv7AveBpd6UN3vQn+axP2pOHOsosTQNDRCwqnLx3rx/jdmwlR6y4gslmITpj8T1kaJ7dmnjH9R4L1oRKimKgdy6WDnxvXCLEt1tcIsya/D7CR6eK/TWPzEhe150Cb7S3Eo1SdyoI934PXp570+QUaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXuvGWN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXuvGWN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5767C4CEEB;
	Mon, 18 Aug 2025 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522571;
	bh=PZHZrZDnY4KSdC/GPl6Tc4BGR5moAHlS+L8ffLFqMbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXuvGWN5wLQDX2QUXO0FdmIf7hiBKFKwCLxXb8tgiY3Wn5i8Ito0bp3NkN22xhjLI
	 sUyZC09WBCtJFKq/VpwWCUuAJk9ZZqdUPJMCuE9nT+yzogB0qJuPI0g7TFvvfxpkmj
	 ZohIRa5I6TBxtAsyq9nHMhKYUoafiP+h6xlesca8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 6.12 354/444] tools/power turbostat: Handle non-root legacy-uncore sysfs permissions
Date: Mon, 18 Aug 2025 14:46:20 +0200
Message-ID: <20250818124502.189980680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit e60a13bcef206795d3ddf82f130fe8f570176d06 ]

/sys/devices/system/cpu/intel_uncore_frequency/package_X_die_Y/
may be readable by all, but
/sys/devices/system/cpu/intel_uncore_frequency/package_X_die_Y/current_freq_khz
may be readable only by root.

Non-root turbostat users see complaints in this scenario.

Fail probe of the interface if we can't read current_freq_khz.

Reported-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Original-patch-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 4c322586730d..8c876e9df1a9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6409,7 +6409,8 @@ static void probe_intel_uncore_frequency_legacy(void)
 			sprintf(path_base, "/sys/devices/system/cpu/intel_uncore_frequency/package_%02d_die_%02d", i,
 				j);
 
-			if (access(path_base, R_OK))
+			sprintf(path, "%s/current_freq_khz", path_base);
+			if (access(path, R_OK))
 				continue;
 
 			BIC_PRESENT(BIC_UNCORE_MHZ);
-- 
2.39.5



