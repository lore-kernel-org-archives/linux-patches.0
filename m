Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD9663B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBE1C433D2;
	Mon, 20 Feb 2023 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901124;
	bh=M7kFyBm0CpB7DcFJq7q7wYYHkUIKh4NZQryM6nyDv48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Li0L3Qsug+SHZu070sYh0SyvmGoqLBzKbJOx4dWeGGibmE0ieYUVk7QDvIng3x8xc
	 io481FdhNSJMBMDaKiH3yoCtPVB4h1dO9s4RnOXFaIST/K0+l3mafzLnurJoNzeG/e
	 NPLh/svXIQ74rTAVKz+P/QopqAQjw5FQaY7wo+rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 39/83] platform/x86: amd-pmc: Correct usage of SMU version
Date: Mon, 20 Feb 2023 14:36:12 +0100
Message-Id: <20230220133555.017289062@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

commit b8fb0d9b47660ddb8a8256412784aad7cee9f21a upstream.

Yellow carp has been outputting versions like `1093.24.0`, but this
is supposed to be 69.24.0. That is the MSB is being interpreted
incorrectly.

The MSB is not part of the major version, but has generally been
treated that way thus far.  It's actually the program, and used to
distinguish between two programs from a similar family but different
codebase.

Link: https://patchwork.freedesktop.org/patch/469993/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220120174439.12770-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd-pmc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -115,9 +115,10 @@ struct amd_pmc_dev {
 	u32 cpu_id;
 	u32 active_ips;
 /* SMU version information */
-	u16 major;
-	u16 minor;
-	u16 rev;
+	u8 smu_program;
+	u8 major;
+	u8 minor;
+	u8 rev;
 	struct device *dev;
 	struct mutex lock; /* generic mutex lock */
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -164,11 +165,13 @@ static int amd_pmc_get_smu_version(struc
 	if (rc)
 		return rc;
 
-	dev->major = (val >> 16) & GENMASK(15, 0);
+	dev->smu_program = (val >> 24) & GENMASK(7, 0);
+	dev->major = (val >> 16) & GENMASK(7, 0);
 	dev->minor = (val >> 8) & GENMASK(7, 0);
 	dev->rev = (val >> 0) & GENMASK(7, 0);
 
-	dev_dbg(dev->dev, "SMU version is %u.%u.%u\n", dev->major, dev->minor, dev->rev);
+	dev_dbg(dev->dev, "SMU program %u version is %u.%u.%u\n",
+		dev->smu_program, dev->major, dev->minor, dev->rev);
 
 	return 0;
 }


