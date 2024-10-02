Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17B21D07AD;
	Wed,  2 Oct 2024 14:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879207; cv=none; b=KSzeAfU3Lo8QvHV97Q6UckTu4p6JNpV7k9wIhK+O9SWbxNvsRa9pIuCbAFXM99pTz9WjP7Js0MyAhYJwGoZ4RUsxjTQCVlSBCd5VA6XA/YPu49vGl8gbn4GFVtiwowoqnKT/JdevYp6rCw+k3QiCUWbgXI0gS6sQCp4MIISDPYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879207; c=relaxed/simple;
	bh=5echFlvXeHbHziHJ0vw6FIyVlB/OzE1OyfBqP7flNhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Htz+tK18rNiMdglEwSGN6NBR7nK6xwh/UdhRY+0Lz7IaFmR9OLaAE70qGgAcNDFm62I7JZNFax2HPpAVGp7ioIQTFOgs8eMC5+KP+Z4ytl+mVqujVnLpr11u29sYsMK5ob9vmNywoKUh6Qw3qoP9TF1u7lbzYJp4EP6JkO/HClk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcJNtCds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcJNtCds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD71C4CEC2;
	Wed,  2 Oct 2024 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879206;
	bh=5echFlvXeHbHziHJ0vw6FIyVlB/OzE1OyfBqP7flNhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcJNtCdslT2PP4WplJb4NBXuGP+BEX+cR4twMwnZU90z+9cGtWl43R16Oty9sDoGK
	 fXVP2Lt6VLXfxYtQIPdfjZYwBHPgRIxiYshWKZJmf1tPSRpWAq8FxCJpbJ9r2lOOpk
	 nQaYZxwEu1snOETmCSHYBJq/F1M67R6Hth4Dsmx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/538] perf/arm-cmn: Fix CCLA register offset
Date: Wed,  2 Oct 2024 14:54:39 +0200
Message-ID: <20241002125753.611380468@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 88b63a82c84ed9bbcbdefb10cb6f75dd1dd04887 ]

Apparently pmu_event_sel is offset by 8 for all CCLA nodes, not just
the CCLA_RNI combination type.

Fixes: 23760a014417 ("perf/arm-cmn: Add CMN-700 support")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/6e7bb06fef6046f83e7647aad0e5be544139763f.1725296395.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 311a85b6be2ec..3926586685cb4 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -70,7 +70,8 @@
 /* Technically this is 4 bits wide on DNs, but we only use 2 there anyway */
 #define CMN__PMU_OCCUP1_ID		GENMASK_ULL(34, 32)
 
-/* HN-Ps are weird... */
+/* Some types are designed to coexist with another device in the same node */
+#define CMN_CCLA_PMU_EVENT_SEL		0x008
 #define CMN_HNP_PMU_EVENT_SEL		0x008
 
 /* DTMs live in the PMU space of XP registers */
@@ -2321,10 +2322,13 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 			case CMN_TYPE_CXHA:
 			case CMN_TYPE_CCRA:
 			case CMN_TYPE_CCHA:
-			case CMN_TYPE_CCLA:
 			case CMN_TYPE_HNS:
 				dn++;
 				break;
+			case CMN_TYPE_CCLA:
+				dn->pmu_base += CMN_CCLA_PMU_EVENT_SEL;
+				dn++;
+				break;
 			/* Nothing to see here */
 			case CMN_TYPE_MPAM_S:
 			case CMN_TYPE_MPAM_NS:
@@ -2342,7 +2346,7 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 			case CMN_TYPE_HNP:
 			case CMN_TYPE_CCLA_RNI:
 				dn[1] = dn[0];
-				dn[0].pmu_base += CMN_HNP_PMU_EVENT_SEL;
+				dn[0].pmu_base += CMN_CCLA_PMU_EVENT_SEL;
 				dn[1].type = arm_cmn_subtype(dn->type);
 				dn += 2;
 				break;
-- 
2.43.0



