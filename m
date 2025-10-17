Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB343328F5;
	Fri, 17 Oct 2025 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715258; cv=none; b=awfjfnkbQt0ziyePS9YqieBFzdmQMHl5DKiRBoIXxdXmiL3WQ2hPWWVbdQbxR6N/SG6l8huMYAezy8nRJHX2DrAYqZ3mlnkqqHJKktQQXf5nb7OcOATjZli3UPoNEObRdcV50yUfcTx8aspzTGfaWgmFUSnqzvFCCjKoWpuwjfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715258; c=relaxed/simple;
	bh=DdBsN6XYBr9n4TkQVlNypUjiKPKKOh585wPpBv+MIM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldh6jR9N7YpVY56P+gjV1DBBsECLpeFNR/7I8KwbIZt8IQfkTnV+MvlM8E83/T8Vj3CN3gAadZkZHuRA7teigDQ/D/Ej141w0RXvRM3fRwSEUSVsRtu0g03bDxGnTqbXNAnLguPAW/dZBOwurVAQa2pS2sfU2L9Spfvqfd/3DQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opuKQnsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opuKQnsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371D8C113D0;
	Fri, 17 Oct 2025 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715258;
	bh=DdBsN6XYBr9n4TkQVlNypUjiKPKKOh585wPpBv+MIM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opuKQnsAAmV5X6qJ6UisFGjQSgwkGoZjShZ2a1+c4m/ce/EPtSHEVafWnh1LsoKKL
	 4bUqvno/XeFAFVRK+Oo2sosVM/6UJaBJu2+hZZiz/T0PcEtIiBm3IulsfaGbolricm
	 xMjbdSAhtcNbIqfk96i6FDbcApVui4BWN0DB5/rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.17 153/371] perf/arm-cmn: Fix CMN S3 DTM offset
Date: Fri, 17 Oct 2025 16:52:08 +0200
Message-ID: <20251017145207.469323064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit b3fe1c83a56f3cb7c475747ee1c6ec5a9dd5f60e upstream.

CMN S3's DTM offset is different between r0px and r1p0, and it
turns out this was not a error in the earlier documentation, but
does actually exist in the design. Lovely.

Cc: stable@vger.kernel.org
Fixes: 0dc2f4963f7e ("perf/arm-cmn: Support CMN S3")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -65,7 +65,7 @@
 /* PMU registers occupy the 3rd 4KB page of each node's region */
 #define CMN_PMU_OFFSET			0x2000
 /* ...except when they don't :( */
-#define CMN_S3_DTM_OFFSET		0xa000
+#define CMN_S3_R1_DTM_OFFSET		0xa000
 #define CMN_S3_PMU_OFFSET		0xd900
 
 /* For most nodes, this is all there is */
@@ -233,6 +233,9 @@ enum cmn_revision {
 	REV_CMN700_R1P0,
 	REV_CMN700_R2P0,
 	REV_CMN700_R3P0,
+	REV_CMNS3_R0P0 = 0,
+	REV_CMNS3_R0P1,
+	REV_CMNS3_R1P0,
 	REV_CI700_R0P0 = 0,
 	REV_CI700_R1P0,
 	REV_CI700_R2P0,
@@ -425,8 +428,8 @@ static enum cmn_model arm_cmn_model(cons
 static int arm_cmn_pmu_offset(const struct arm_cmn *cmn, const struct arm_cmn_node *dn)
 {
 	if (cmn->part == PART_CMN_S3) {
-		if (dn->type == CMN_TYPE_XP)
-			return CMN_S3_DTM_OFFSET;
+		if (cmn->rev >= REV_CMNS3_R1P0 && dn->type == CMN_TYPE_XP)
+			return CMN_S3_R1_DTM_OFFSET;
 		return CMN_S3_PMU_OFFSET;
 	}
 	return CMN_PMU_OFFSET;


