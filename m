Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192A640876;
	Mon,  1 Apr 2024 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990708; cv=none; b=M5kujE8Bvlai6xIaccHn5ecqSlTbm7myWMv2GUL10dtrTandEK68PUD3aJw4E7xANjVOVyEoe9ubFWZ5xT3AavWQKf5/fjUFWMrfjZ241SnKzDr/OhZ7r+ANpS5WFJyBEMzA2xw+PRWakxRPNhQZA/+1tGfcXx+teC1DJ7ZAp4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990708; c=relaxed/simple;
	bh=lgZJ+gcUCulxek1XeFJ0cUF5ESd2B46j8RjAQ9+IStc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwzUc+h4frZofV0SNsdtecWJfsj9kKWKTMD8N7lqIpHTHG/bKiWEELQgEkAcMFXFY9TaOmTe8z5xgsmnHUL/bPrY8BJXXAGtXVO9lvnNcauGpsZR0vgkXFtQDx2K9wsfgnFyqD6mXcjmhwoS7JcEldr5WOZ4PD9bMakMbRKImOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5rC7pM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5rC7pM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81904C433F1;
	Mon,  1 Apr 2024 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990708;
	bh=lgZJ+gcUCulxek1XeFJ0cUF5ESd2B46j8RjAQ9+IStc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5rC7pM9FfkwWw/UuaB4YeCw40sJEaou4G4c5S5YJ3uY99WSzysrxpEq4m7xaNBza
	 IUXKOXzXER4DWMhWb6FZlH0fhgIdCDdcfySnoGYlnmSYPZ4WcwFB9KcjBOeqivJ9SO
	 sERGz7jPREdFRenY7Rkib+QnC5pqE7ehzVgEI5Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <cy54@illinois.edu>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/272] ubi: Check for too small LEB size in VTBL code
Date: Mon,  1 Apr 2024 17:43:51 +0200
Message-ID: <20240401152531.680267649@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 68a24aba7c593eafa8fd00f2f76407b9b32b47a9 ]

If the LEB size is smaller than a volume table record we cannot
have volumes.
In this case abort attaching.

Cc: Chenyuan Yang <cy54@illinois.edu>
Cc: stable@vger.kernel.org
Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Reported-by: Chenyuan Yang <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-mtd/1433EB7A-FC89-47D6-8F47-23BE41B263B3@illinois.edu/
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/vtbl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index f700f0e4f2ec4..6e5489e233dd2 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -791,6 +791,12 @@ int ubi_read_volume_table(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	 * The number of supported volumes is limited by the eraseblock size
 	 * and by the UBI_MAX_VOLUMES constant.
 	 */
+
+	if (ubi->leb_size < UBI_VTBL_RECORD_SIZE) {
+		ubi_err(ubi, "LEB size too small for a volume record");
+		return -EINVAL;
+	}
+
 	ubi->vtbl_slots = ubi->leb_size / UBI_VTBL_RECORD_SIZE;
 	if (ubi->vtbl_slots > UBI_MAX_VOLUMES)
 		ubi->vtbl_slots = UBI_MAX_VOLUMES;
-- 
2.43.0



