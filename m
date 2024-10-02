Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B7E1D0BAA;
	Wed,  2 Oct 2024 13:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877332; cv=none; b=fElY27yFRQopmP0LOjntPKMqzb5Lgvv2hyi1PzYUrtzEwnczKqKIznSYMuQ+c2Hk2oWX0yGFrWARKy0lRiYCeAKo4u4+swaTsgXrxcfkhXAlKNOKgGBbYxhlvLtTRVnCJx6wCzp269g3o9XP2rxNy1H/1EGKyqit4DxHEwhe1Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877332; c=relaxed/simple;
	bh=xtMwLtW6ciToUjki9pM2gaE/P7Q8nb1I/gT/mLAb9qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUivnP0kQsDOz7KexSrei8Layea4pIIixsSc/URYBSLGqV9LiD+Fr/dvoUrd+MSTbFz0phEDsZepcQLpKtUHk06Rsm2ml1cVWKHwKxHMijzgdD5+1Q5tx5znNwyePv5dACITFBpeL/ItZmsxQdAfOHxNhghmg+Ltv5ZuLGB9WTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ju2AC8/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ju2AC8/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC507C4CECE;
	Wed,  2 Oct 2024 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877332;
	bh=xtMwLtW6ciToUjki9pM2gaE/P7Q8nb1I/gT/mLAb9qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ju2AC8/LXe4cbnCEKFsTllRIUdoD0b9y/gVc/Unq1qVX76go6kDHulr4hHN8/vN0W
	 4bxz86zAlRsF//lUOSS6ON7HadzoKhiAP2l43LTgDiphVFKrCMOe0ZsqpBvHKqxlT4
	 MJNrO3pmK/Bk1+zSooMAoZhlx5L5vp3QbtLe/40E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 046/634] ACPICA: executer/exsystem: Dont nag user about every Stall() violating the spec
Date: Wed,  2 Oct 2024 14:52:26 +0200
Message-ID: <20241002125812.921536304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit c82c507126c9c9db350be28f14c83fad1c7969ae ]

ACPICA commit 129b75516fc49fe1fd6b8c5798f86c13854630b3

Stop nagging user about every Stall() that violates the spec

On my Dell XPS 15 7590 I get hundreds of these warnings after few hours of
uptime:

$ dmesg | grep "fix the firmware" | wc -l
261

I cannot fix the firmware and I doubt that Dell cares about 4 year old
laptop either

Fixes: ace8f1c54a02 ("ACPICA: executer/exsystem: Inform users about ACPI spec violation")
Link: https://github.com/acpica/acpica/commit/129b7551
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exsystem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/exsystem.c b/drivers/acpi/acpica/exsystem.c
index f665ffd9a396c..2c384bd52b9c4 100644
--- a/drivers/acpi/acpica/exsystem.c
+++ b/drivers/acpi/acpica/exsystem.c
@@ -133,14 +133,15 @@ acpi_status acpi_ex_system_do_stall(u32 how_long_us)
 		 * (ACPI specifies 100 usec as max, but this gives some slack in
 		 * order to support existing BIOSs)
 		 */
-		ACPI_ERROR((AE_INFO,
-			    "Time parameter is too large (%u)", how_long_us));
+		ACPI_ERROR_ONCE((AE_INFO,
+				 "Time parameter is too large (%u)",
+				 how_long_us));
 		status = AE_AML_OPERAND_VALUE;
 	} else {
 		if (how_long_us > 100) {
-			ACPI_WARNING((AE_INFO,
-				      "Time parameter %u us > 100 us violating ACPI spec, please fix the firmware.",
-				      how_long_us));
+			ACPI_WARNING_ONCE((AE_INFO,
+					   "Time parameter %u us > 100 us violating ACPI spec, please fix the firmware.",
+					   how_long_us));
 		}
 		acpi_os_stall(how_long_us);
 	}
-- 
2.43.0



