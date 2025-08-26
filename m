Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8228345726;
	Tue, 26 Aug 2025 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218074; cv=none; b=XLL5AfQ44bRI36wtv7An3hRwYFmv4WMOmo2LhqLep+O8EPbQycz/I21xXcXJEjqNhwMRfNnz4jDkADYZTkPpWpQdQzLQICCmMTNCXEMzYg68r5ELX0yYe86CQJh39/LCc3RlxGuTNwTvhl3wg74m6kNJNIMzi5OPowlYoWr68ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218074; c=relaxed/simple;
	bh=VD70jjYJvSU5X+kyqA33V5xdTp7k+j+dHV8DksrNIxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6sXUZfrFflDDb+ItWycEHu3q5MoeMF4DUkOgDMXgiXGXpLAlcDnleRNpesYCf1vNqurpmNjZqFoaLwYO4aEfVLHF9R9hGnpwDgexuKvv0B8C7ndmt8aFuc+/lH1fGTiHFqyaj8dUWECzacXB3DOjILpPWI0aw4xu3nsvZMLKEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8SqcBKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8SqcBKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D63FC4CEF1;
	Tue, 26 Aug 2025 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218074;
	bh=VD70jjYJvSU5X+kyqA33V5xdTp7k+j+dHV8DksrNIxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8SqcBKmUV+jn2OufRgN33fyIBo3b73N0ZrKAKQk1fSsmj51KuNz2rtsTxKJ03MBT
	 5kuJlO8/ENgAFtVCOXjhBsPjSCVqSehfYlQTeTtF09t5QP0/iZXpKVI1ugHqq/7khV
	 asPHTmL50e3eXqXxS348ofCvBhKobeumUu8ieZ2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.10 384/523] drm/amd: Restore cached power limit during resume
Date: Tue, 26 Aug 2025 13:09:54 +0200
Message-ID: <20250826110933.933816030@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1332,6 +1332,12 @@ static int smu_resume(void *handle)
 
 	adev->pm.dpm_enabled = true;
 
+	if (smu->current_power_limit) {
+		ret = smu_set_power_limit(smu, smu->current_power_limit);
+		if (ret && ret != -EOPNOTSUPP)
+			return ret;
+	}
+
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;


