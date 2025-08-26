Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8DB34F485;
	Tue, 26 Aug 2025 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216669; cv=none; b=WmIU43L73wEcxd5rZMwgRhh9R9Pyhev2+mPPcoC/Qmgx4/BA5/h3tXoGGVlY2SXQBZ/huYqVh5ylhu3UKO8sJlAUFoVIJm45npJBioYZXIy3YHsAL5NmVjlqtZRBlJUwem18wvLHbZgIYxAigZmdyeS/zie4JhTZ+7ZyNx6uxx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216669; c=relaxed/simple;
	bh=wztK95UM4EsuTdSZz38aNEClMqs6aErU0DuiWlQ0Gq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7Uwf87gc0EPWLe4CVWzkwHqjyGEihAr1ZDYeMjgdCb/4nZUF4JAugbLIJqj9Rk0NQY2OH6LxGJ1rltlEKhEpZl8kiAlq91z/jxEYVwMtWMzws7zP6XdmVfxeMTx+ESZqvK8000QQOkjIfhVjGvI2CIf0rqZ0qcFZCSdZbutYe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/MoRc0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/MoRc0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57BFC4CEF1;
	Tue, 26 Aug 2025 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216669;
	bh=wztK95UM4EsuTdSZz38aNEClMqs6aErU0DuiWlQ0Gq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/MoRc0UJ/7+QSa+ipHfTDQhbcgWqN85OFC4YrbefFtTQAYqbyxttvM9DjwJMbN6t
	 ppKHjZUlmI+GpWWzu0zlhElHv+GQWYY6gd2GxTU5E/pSg1gIsvGprL0wa9mLXnZ8LL
	 Xf1boK2GCbHPTEq9nvchiNdh3cZ4iM33hlBiPILs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 497/644] drm/amd: Restore cached power limit during resume
Date: Tue, 26 Aug 2025 13:09:48 +0200
Message-ID: <20250826110958.810757190@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1573,6 +1573,12 @@ static int smu_resume(void *handle)
 
 	adev->pm.dpm_enabled = true;
 
+	if (smu->current_power_limit) {
+		ret = smu_set_power_limit(smu, smu->current_power_limit);
+		if (ret && ret != -EOPNOTSUPP)
+			return ret;
+	}
+
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;


