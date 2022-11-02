Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FE47E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692A7C433D6;
	Wed,  2 Nov 2022 02:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357584;
	bh=s93B14zjw80sMeP1UH3MlvnUC/h7MQClDHkQ8GML+9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7RrpFNocDmVSCHtHKIYUDJ4WHOXITvIG2hZUQ65ThvSm6SWcqJgXnFKafKxV+nkU
	 oXC/B8rBMlg5IcLA5pLfkyow+ipf/rbCMfj9/x6yZKNTK0sBIRooCNboViQxCE6UwC
	 CIFSOIdWCnxZ21qOL3iY/E9rg7YS9wHx+iiXKXJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kolAflash <kolAflash@kolahilft.de>
Subject: [PATCH 6.0 195/240] PM: hibernate: Allow hybrid sleep to work with s2idle
Date: Wed,  2 Nov 2022 03:32:50 +0100
Message-Id: <20221102022115.805533286@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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
index 89c71fce225d..537dd3beafc1 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -641,7 +641,7 @@ static void power_down(void)
 	int error;
 
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(mem_sleep_current);
 		if (error) {
 			hibernation_mode = hibernation_ops ?
 						HIBERNATION_PLATFORM :
-- 
2.35.1



