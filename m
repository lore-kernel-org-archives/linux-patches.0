Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BFD288C1F;
	Mon, 18 Aug 2025 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526193; cv=none; b=COfJ8rtsITOT/uA/NZ9C6U1q2HsRCFJK8A9Fh1XKrX3Q3d+AjTGClHI4miEzPLhnlCaMbmssrvnhjk2CHkqhHiCeXnx0pxgnOQjodbtfdBbMYMygUQyLHZOaS4h2QngyGp3wsMO4kyObO/JgKx+XB0jiXSZFyzsKFJi6Nc3JSuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526193; c=relaxed/simple;
	bh=yej5aNuMCBioetOZzmmAWipA8XYs3as3+jsjnUkAwJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upGOwNvOA8IffOfVjLmTUpLuaKRPCsJoYsGkOc8UKYljjqRW6Z8YIU/Pd+ejxPkkF+eCaaiRYZ4Uk/M9EzVvTkzgz90c04yN4KhI30KOHmXJ3GUzjbwqNbNfqLZl2Ddw7XMUXUUIk/oobf5EvEQLZ8119/AnGexFz/LTEjN0ul4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYbajddw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYbajddw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BE3C4CEEB;
	Mon, 18 Aug 2025 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526191;
	bh=yej5aNuMCBioetOZzmmAWipA8XYs3as3+jsjnUkAwJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYbajddwvi0b4cBm4uVSdZo9CBwbDlwS5tvATKoH5+25jyAG8yXKbCiPiuKG0M/Ui
	 YgIVAjDpCv/41S3/RRXHnUXB3sy9ShBq5WkV1mR97UeBEq0H9CtGQqsVJW5Q8aD67B
	 6w3iczkh3xmdYOhAbnJcDJ0uRQdYOdPz6+hliVZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 6.16 452/570] tools/power turbostat: Handle non-root legacy-uncore sysfs permissions
Date: Mon, 18 Aug 2025 14:47:19 +0200
Message-ID: <20250818124523.232582730@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 426eabc10d76..291c98b5d209 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6740,7 +6740,8 @@ static void probe_intel_uncore_frequency_legacy(void)
 			sprintf(path_base, "/sys/devices/system/cpu/intel_uncore_frequency/package_%02d_die_%02d", i,
 				j);
 
-			if (access(path_base, R_OK))
+			sprintf(path, "%s/current_freq_khz", path_base);
+			if (access(path, R_OK))
 				continue;
 
 			BIC_PRESENT(BIC_UNCORE_MHZ);
-- 
2.39.5



