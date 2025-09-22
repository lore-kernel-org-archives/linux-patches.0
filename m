Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5A02F2909;
	Mon, 22 Sep 2025 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570260; cv=none; b=KSno3MzwqI1PAinYUsxrtFL/UrZSQcATDWx4E/jOLFtWAXeoQIYZrgXQJW3RtGVO4Mr8vABHVEjWhkPY77ocmKjBWsUyrwEmdkcQO9OfVNjrbM5rCft9NmNOKFC045E3dy1Av5SN0px3HtUwE1+jQSASRsvXAIrj7abiP2G5Ybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570260; c=relaxed/simple;
	bh=GLvXu4lgQ5nXDffQTrijckeWzQrfQJdbeRxzcYFWwy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XL2WjbOzmQZPSHy9hpX4fohgtOvYVqL7PtWfZ1gYEHv66eFBTxKOL7ATTemdyRXq8hDL9nWibEXoxDyjZfx7J7X1qfqy5dxjTfoFp2qIyIDdCc/SLccq5SJKctWgTHywACHd9Zb/5I8v12/sRITWsCMvxcZMKeBkA37Lt/ss3/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaH9XZiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaH9XZiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C424C4CEF0;
	Mon, 22 Sep 2025 19:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570259;
	bh=GLvXu4lgQ5nXDffQTrijckeWzQrfQJdbeRxzcYFWwy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaH9XZiDKTxi92f561NMMygukUPJqLk8b6GjsFIG1tZK6ZrRdysbFV7EsMCJzXXl3
	 dKnMSA9VrdTSoAz2BroE/yeyWl6hwCWp9mgjipVuXCbF50TD1KarC9bA0pGS7Zqjw2
	 gDwSdnv3rBn59hM5TuqEIkY52NuxSbFOlZn3WU1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.16 079/149] iommu/amd: Fix ivrs_base memleak in early_amd_iommu_init()
Date: Mon, 22 Sep 2025 21:29:39 +0200
Message-ID: <20250922192414.874376533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Zhen Ni <zhen.ni@easystack.cn>

commit 923b70581cb6acede90f8aaf4afe5d1c58c67b71 upstream.

Fix a permanent ACPI table memory leak in early_amd_iommu_init() when
CMPXCHG16B feature is not supported

Fixes: 82582f85ed22 ("iommu/amd: Disable AMD IOMMU if CMPXCHG16B feature is not supported")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20250822024915.673427-1-zhen.ni@easystack.cn
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3048,7 +3048,8 @@ static int __init early_amd_iommu_init(v
 
 	if (!boot_cpu_has(X86_FEATURE_CX16)) {
 		pr_err("Failed to initialize. The CMPXCHG16B feature is required.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/*


