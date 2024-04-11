Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F513F452;
	Thu, 11 Apr 2024 10:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830593; cv=none; b=ObloczCcIjTf6ub73icgjdLf1OlmmxPGzLa33vL2APmdljj/pcR3hACusRuzDIRizpxZHvwrfegbsbEpGsayV0x3D9EW8pAAJcwVftuq13FlXCyou9kAi8lE6rvdHiyLiQ8wJM25H4PLDcpkjhyIw2O5XxxhVXSzr/2RL3+pLHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830593; c=relaxed/simple;
	bh=LtPRdiAP0XeyG5h7ekv3XeaJKmHDv2IuPNRu9nHIahI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyN2SezAsh2v87bGXzq4mPzZ9KIMLfG9whLkVr3fL+/N2ZFAsmXxLc6yPhCpZbZMvZMP3dqUPAZW1+nE+cyZ7pRWz/sXx8khhuaGRLliL4dC79LtQNqV1pwtDWdk91tR3qanFY9ZbybhQveboYuqDFk/CxeUaMN8IlmQzy+BXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqbD0E5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqbD0E5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8053C433F1;
	Thu, 11 Apr 2024 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830593;
	bh=LtPRdiAP0XeyG5h7ekv3XeaJKmHDv2IuPNRu9nHIahI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqbD0E5LbYXCVAJzuxWlPcB3eL8onOQcMd3BnJTjwxkKnBfoHoRUMrI5Uf641x6ez
	 Wb13LK+vabL/nJJVpPm+vBPc2vKXfwL05qdBZ+ST/vaS1iATezisPles2ZK59qGX5f
	 m35+i009rQ2D4/efvPMY/I7aN1+xJABBocmwu5uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <cy54@illinois.edu>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/215] ubi: Check for too small LEB size in VTBL code
Date: Thu, 11 Apr 2024 11:53:54 +0200
Message-ID: <20240411095425.639213522@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 53d8ab54e1811..c891ee100dec4 100644
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



