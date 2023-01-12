Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E94579C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8505C433EF;
	Thu, 12 Jan 2023 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534002;
	bh=gZCMzfdMThBHQbXKBBF+0ZdSCnJNopEembYlEMLWY8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BFYqPCv/XC+sOeiOYbPrIqHZnrIeiAS5KKu+gLuM/bBGJ91XJrnqWbBv1i2LTFRa
	 QVgpUZkHCJB7tu4yZiGFjhU4JLeIAqaKBmJH7E0PzjT1F2mibqdCbOg223zv5IKk0P
	 vH4dCeWci//Zp8zqSgmbWf5IUlOU6bp/Zsvc6Lic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Phillips <kim.phillips@amd.com>,
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 661/783] iommu/amd: Fix ivrs_acpihid cmdline parsing code
Date: Thu, 12 Jan 2023 14:56:17 +0100
Message-Id: <20230112135554.984747294@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kim Phillips <kim.phillips@amd.com>

commit 5f18e9f8868c6d4eae71678e7ebd4977b7d8c8cf upstream.

The second (UID) strcmp in acpi_dev_hid_uid_match considers
"0" and "00" different, which can prevent device registration.

Have the AMD IOMMU driver's ivrs_acpihid parsing code remove
any leading zeroes to make the UID strcmp succeed.  Now users
can safely specify "AMDxxxxx:00" or "AMDxxxxx:0" and expect
the same behaviour.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: stable@vger.kernel.org
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20220919155638.391481-1-kim.phillips@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3126,6 +3126,13 @@ static int __init parse_ivrs_acpihid(cha
 		return 1;
 	}
 
+	/*
+	 * Ignore leading zeroes after ':', so e.g., AMDI0095:00
+	 * will match AMDI0095:0 in the second strcmp in acpi_dev_hid_uid_match
+	 */
+	while (*uid == '0' && *(uid + 1))
+		uid++;
+
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));


