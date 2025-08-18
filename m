Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58AF335BD3;
	Mon, 18 Aug 2025 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524264; cv=none; b=pTLy4Zwh4fhGiI+1Uh0v1YdwPqc+v6MSidL8y9DRkaUwTGtc4210LNf6smN5BO1XUqTIJtj4AbDNvICjdu2eYKIikZKgzGkyj58LnwnuPNnAnXNzwgictpLmMLQtExqsY8y8r+s9DaWYcjPDUCG1CTja3yifyQmcBlD48mDbNkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524264; c=relaxed/simple;
	bh=WbFWR414LiRTgnwFyf7HhGc4c0Gr4ZgajBBb1JSy0BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9S+NRChRpd64cUETibVC2Mpbn6VWm9+AJ1nNrRokIXx3VBPsAyxtGyeTSv9NBTy/XKVAy6TTPqIYcyMchUaGBZCHXvLBUIjZ7ae+jruep1/c2bj0KHOtGs2tdUC4tR0/2rYyk0W/7xbB+XSvfJ4FRudEmDX0HOsx0jVbNIvjAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9E4jx9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9E4jx9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50034C4AF09;
	Mon, 18 Aug 2025 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524263;
	bh=WbFWR414LiRTgnwFyf7HhGc4c0Gr4ZgajBBb1JSy0BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9E4jx9HaPIIiDPS1YTvClrxrjqyNqEMSyXkVR5IYeKoGMOC/ONYShy4YLp2vOcfB
	 UEGtE4MztwiesKpkFfgy4tuIX6g63OVRcaI8xBwn/7o2r1zvUDYr9j22uIv2Lxmxo9
	 +B9HTWWAn+ZxHp8juAgGOPI+UqbophXL8J/aOtaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 6.15 418/515] tools/power turbostat: Handle non-root legacy-uncore sysfs permissions
Date: Mon, 18 Aug 2025 14:46:44 +0200
Message-ID: <20250818124514.517451959@linuxfoundation.org>
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
index 444b6bfb4683..3e97b69b1dfb 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6690,7 +6690,8 @@ static void probe_intel_uncore_frequency_legacy(void)
 			sprintf(path_base, "/sys/devices/system/cpu/intel_uncore_frequency/package_%02d_die_%02d", i,
 				j);
 
-			if (access(path_base, R_OK))
+			sprintf(path, "%s/current_freq_khz", path_base);
+			if (access(path, R_OK))
 				continue;
 
 			BIC_PRESENT(BIC_UNCORE_MHZ);
-- 
2.39.5



