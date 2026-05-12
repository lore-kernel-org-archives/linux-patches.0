Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975983BB13B;
	Tue, 12 May 2026 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608028; cv=none; b=EEXf09DmoS9IJ4E/uV/5LlqxoKDQ5PjuKkrm2wyRTVeLPeylOplNS/Tu/jU47yYCDfgKNelCCzK2ed6TSCdmIej0Cl2FtzAacT9eRGds0s3ASU/CaQKLNAtXSLK7Wsony/Bo2kmS8LchExZ8cwq0mINE6rjh+jbMm8tyR8g5NLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608028; c=relaxed/simple;
	bh=qo3oNsF6EhVi4Ocoz/aS8V152s4kkEIYFkKs2nfV22s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf4lCParUFnxjJ09iinQpf9I1NEn53NipJrV/YIPg2TKVq/abC5bnwaSBxAQOB6F/ZiznZ0vi0gQ14HB/mfQVq/ysCIlwSA1AHS04qHRTPXYgiN3+kcefYMGliIJzAwYlZny+VwrV0D+5UM2+w3toioqHylc8fgqO9aHpbJFubk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4HbvPwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4HbvPwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8EAC4AF17;
	Tue, 12 May 2026 17:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608028;
	bh=qo3oNsF6EhVi4Ocoz/aS8V152s4kkEIYFkKs2nfV22s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4HbvPwPlxo+49gBz2Rgm5mMhRqeBvIaD2IdqRmMyRdkjkkg1d/qm+PM84vZ1oqSI
	 RLVlno2LhlDao04Msx8Rbpj7UuO9z0iZGN7aM3VE8odi4+NcvPAWHMLWhRipe5VhkN
	 tCMlJS025/Xi4EQNyTp5LyptgQrmYJg951EaNVSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 6.12 128/206] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
Date: Tue, 12 May 2026 19:39:40 +0200
Message-ID: <20260512173935.569192705@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 9aa6d860b0930e2f72795665c42c44252a558a0c upstream.

setup_geo() extracts near_copies (nc) and far_copies (fc) from the
user-provided layout parameter without checking for zero. When fc=0
with the "improved" far set layout selected, 'geo->far_set_size =
disks / fc' triggers a divide-by-zero.

Validate nc and fc immediately after extraction, returning -1 if
either is zero.

Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://lore.kernel.org/linux-raid/SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3872,6 +3872,8 @@ static int setup_geo(struct geom *geo, s
 	nc = layout & 255;
 	fc = (layout >> 8) & 255;
 	fo = layout & (1<<16);
+	if (!nc || !fc)
+		return -1;
 	geo->raid_disks = disks;
 	geo->near_copies = nc;
 	geo->far_copies = fc;


