Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC1C245012;
	Tue, 26 Aug 2025 11:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207413; cv=none; b=AaLM7xWHdI/heZOKws1ZkR7Hp9TZRUBwW6ycBFiENdhpQDUTIa2ypp+nUvwmoenTfy+s+Lo1UJa9aq0MzIEYMxt6j3u0XMCTTAiNE0DapXmLRyEp7haYQh6OCBucWn91X6hbnkKTgIQu3/kGEnZX7unU1uvzO6ru//9wBvXaSZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207413; c=relaxed/simple;
	bh=NXoFARUjflh7aMqkKVlWDBbgnBNDDtomCWHeeEq/s6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVLWVbiaxdb3MyexRvtQgG/ch/ZybLkhxtQg633nptEth0MMfxkT0oiz2otbaXAa/5cfl5/PiIvXvcRb7Mx41jVUKUA4h7ZEe2Jctd3Op7D0VnWH4b1cGFtKkLcRBOipLdg8FtXAfRAU2LEuKx4Gb52NbjyiYI9I0mLi4CkLHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE688jYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE688jYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79484C4CEF1;
	Tue, 26 Aug 2025 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207412;
	bh=NXoFARUjflh7aMqkKVlWDBbgnBNDDtomCWHeeEq/s6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IE688jYUnN1Dr134c/cKdqbO1OFlZpNX80tZaRAIfI0kKPQArgtYgHojEhXbguaXh
	 NnftHPEVK5TxU929az4YiEzYSPDmNCwNF2su7tQIuMxdI3JGKpaqAD0gbO+O+D/ygk
	 HHkVeMGeA+PSKPYLaDW05Q8ZpnaW85xnRyyLUSlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.16 172/457] drm/amd: Restore cached power limit during resume
Date: Tue, 26 Aug 2025 13:07:36 +0200
Message-ID: <20250826110941.627201471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit ed4efe426a49729952b3dc05d20e33b94409bdd1 upstream.

The power limit will be cached in smu->current_power_limit but
if the ASIC goes into S3 this value won't be restored.

Restore the value during SMU resume.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250725031222.3015095-2-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 26a609e053a6fc494403e95403bc6a2470383bec)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2175,6 +2175,12 @@ static int smu_resume(struct amdgpu_ip_b
 
 	adev->pm.dpm_enabled = true;
 
+	if (smu->current_power_limit) {
+		ret = smu_set_power_limit(smu, smu->current_power_limit);
+		if (ret && ret != -EOPNOTSUPP)
+			return ret;
+	}
+
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;


