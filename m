Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36CDF510;
	Wed,  5 Feb 2025 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764096; cv=none; b=ukGi6NpAVDZtutY82blqmiT4hVh2DZ74Y8X6zPoBrDKB7zWDONY6MxDlYxe/kptsmxi3lwrMAYKiOirSShHoj7RY2yctu0ycBlWaI4HMCU36s0mwt/+yE92708wFFg/IvdBLgpz/g8IlBV4cgkKmo98OstGPwFUh2ulJZz9VKgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764096; c=relaxed/simple;
	bh=90sd+mVOvfc50vTU8kq2cMJp7kfHbuj1s7RZR+iNwUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyQLxq47arcDpmGpGPWy8xn3VLoYQxd7spO0aKQOfIOqzdWN7sZU46xZoYzIzJeV8wuF2OkQOrthLUnLBfskER1I2hk60GNIo49ibu37isKvYtpqklebOu5uamr4pKcb+mRlT0w0EwU2QyYyUUiRttzlMolI1G5LrK6ZONaOwTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLq+8pfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLq+8pfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1820EC4CED1;
	Wed,  5 Feb 2025 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764096;
	bh=90sd+mVOvfc50vTU8kq2cMJp7kfHbuj1s7RZR+iNwUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLq+8pfEhP+OEj1BNGbyAnzhNu/GRabHYQD5DbWYUOksIanvw5A8G92ZR9BJiHccJ
	 bYIZLQWIZbQj0ZA9FkDbz01M2l3QjKYqnoOHxEvvwv1nz/448vBOOSQS97IjKx2Qr7
	 Z5ztVQQcqbqwztUQ6JWBAv5s365a/6qLxTOi277Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 047/623] drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table
Date: Wed,  5 Feb 2025 14:36:29 +0100
Message-ID: <20250205134458.030054585@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Stepchenko <sid@itb.spb.ru>

[ Upstream commit 357445e28ff004d7f10967aa93ddb4bffa5c3688 ]

The function atomctrl_get_smc_sclk_range_table() does not check the return
value of smu_atom_get_data_table(). If smu_atom_get_data_table() fails to
retrieve SMU_Info table, it returns NULL which is later dereferenced.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

In practice this should never happen as this code only gets called
on polaris chips and the vbios data table will always be present on
those chips.

Fixes: a23eefa2f461 ("drm/amd/powerplay: enable dpm for baffin.")
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index fe24219c3bf48..4bd92fd782be6 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -992,6 +992,8 @@ int atomctrl_get_smc_sclk_range_table(struct pp_hwmgr *hwmgr, struct pp_atom_ctr
 			GetIndexIntoMasterTable(DATA, SMU_Info),
 			&size, &frev, &crev);
 
+	if (!psmu_info)
+		return -EINVAL;
 
 	for (i = 0; i < psmu_info->ucSclkEntryNum; i++) {
 		table->entry[i].ucVco_setting = psmu_info->asSclkFcwRangeEntry[i].ucVco_setting;
-- 
2.39.5



