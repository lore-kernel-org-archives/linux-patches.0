Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6083D7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D739C433C1;
	Wed,  2 Nov 2022 03:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358403;
	bh=PQBL8nkxy7cSnSsNYzmZgEjNWbTjfbRbwftVcdyW3gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPp6YwOWTU/9AznFOxKqY3P6sNtUdD6m7HEuIhtTmaPHFxOIpWRQ0ofzV2yY0UBEu
	 MRkWPOV2UKyW1fNvaWxf3UAjic/Zj8LODNVe4s4U2GoOx6A9E6TWOGCl/NCO/kErpK
	 7eHf+Jxnq6uhSsRFkPp+d6GPygmGxroikUwpW54Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kolAflash <kolAflash@kolahilft.de>
Subject: [PATCH 5.15 092/132] PM: hibernate: Allow hybrid sleep to work with s2idle
Date: Wed,  2 Nov 2022 03:33:18 +0100
Message-Id: <20221102022102.045951282@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 85850af4fc47132f3f2f0dd698b90f67906600b4 ]

Hybrid sleep is currently hardcoded to only operate with S3 even
on systems that might not support it.

Instead of assuming this mode is what the user wants to use, for
hybrid sleep follow the setting of `mem_sleep_current` which
will respect mem_sleep_default kernel command line and policy
decisions made by the presence of the FADT low power idle bit.

Fixes: 81d45bdf8913 ("PM / hibernate: Untangle power_down()")
Reported-and-tested-by: kolAflash <kolAflash@kolahilft.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216574
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d926852f8119..9abc73d500fb 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -640,7 +640,7 @@ static void power_down(void)
 	int error;
 
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(mem_sleep_current);
 		if (error) {
 			hibernation_mode = hibernation_ops ?
 						HIBERNATION_PLATFORM :
-- 
2.35.1



