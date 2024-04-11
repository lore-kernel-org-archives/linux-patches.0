Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C703013DDDD;
	Thu, 11 Apr 2024 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829545; cv=none; b=IRzdoRGuzziDzqfCrr1ZSTAVKZb0yM4es7IWE0w9D+9HnE2F/EI4DGNeiRXhBQDmFSnh4onoy2GXbqr1nr0WHLT1EqqdeBf6UzV2kfZroOeGg9cVh3kUYAR98/19H/z2dIUbfEwZlm8N5g4chUFCWOebdWy/XsQv/vzJTHHJztw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829545; c=relaxed/simple;
	bh=wU8oKy3jtizkkUkaBTeIgTdEonJUQmgx7DKWKD/f8iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aw7c9Qzas5CPbkeuMGjqMv4zqwt0EewXZWWeUBCG3ohiDDZCqO8XfyqVnYApy33WHyJkO0nAQknfMhealuEgsp28V3dd3vLYbgL3NhuGY6luZ7pi9UVePoNIUw0gwGPJ3FkNprbDw4ZNWw7MxxZncMLSbPg5+gh7u4DELiEmqxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvC+LZNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvC+LZNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA1BC433C7;
	Thu, 11 Apr 2024 09:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829545;
	bh=wU8oKy3jtizkkUkaBTeIgTdEonJUQmgx7DKWKD/f8iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvC+LZNFsk83nckOIkUe/Voks8cPZwz8m3J5hFQ6Jejd6pVSdrOU9jTRy5Lwt9Hrp
	 pWF4vg2JpxBYqHs1xWt3HTnzvzvTofQokR+2llxLliKgfKNaJRsH29Zk1cFZC/+9PO
	 Qbd/FMpOEaklQS7b2JxQqb/wTNVECPfcdljolNm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <cy54@illinois.edu>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/175] ubi: Check for too small LEB size in VTBL code
Date: Thu, 11 Apr 2024 11:54:06 +0200
Message-ID: <20240411095420.251994731@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1bc82154bb18f..634ec95a1e71a 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -804,6 +804,12 @@ int ubi_read_volume_table(struct ubi_device *ubi, struct ubi_attach_info *ai)
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



