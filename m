Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F926FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CA6C433F0;
	Mon, 16 Jan 2023 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888100;
	bh=Vwy4BjoQMhksLPN1W/v5hQl8Sae12S9YOg7pjyU6tbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HALWT2fa5GAhCvLhhMglUl6S2HMb7TEdOKXa7WJ5oZlPjdqn6wS2CcwXrW0+HY8lU
	 46LH8s0f0JtW+MiPZW33MZ/Fa1iwwYy0QCQ9hC3++8I3gESd3vINzhaMQW9KcM7oHL
	 nlFvy5iUsjmneb43bnMkgd8C9BnDxzbsBWPxEdeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Phillips <kim.phillips@amd.com>,
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 401/521] iommu/amd: Fix ivrs_acpihid cmdline parsing code
Date: Mon, 16 Jan 2023 16:51:03 +0100
Message-Id: <20230116154905.007097157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
 drivers/iommu/amd_iommu_init.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2946,6 +2946,13 @@ static int __init parse_ivrs_acpihid(cha
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


