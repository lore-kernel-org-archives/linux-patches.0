Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC295341AC1;
	Tue, 11 Nov 2025 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823174; cv=none; b=ogtFOsBklWkNvVZ9BIusyTqs1gkgOpTskKSjInDMHxXlCBQC4nIfXumOUjjnsJVebn5RDhDYqJ+nMeVEI5nSW+RZnLn2fmMK5ouxq6N8Xb9HwMQd4sAGKZuzNg26m6AHBtrUTjmS7U3Y6NKizp8uAvzeqbdL26J8xifNUkHzzFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823174; c=relaxed/simple;
	bh=Z/fxLIQ0JUyn+HNiQwVP3LKMxdZCTKK5MNud0eJKRtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoBSIg75q9J4defsGWWUSbPeqzlX35XINLo2Pm0dGAe+zkHz47MJiJC5677UEn5/2KXDFiozEdMWQsK6y0bxe7kWGaHY4D/SlK78aHC6Z9FCDFpNHG45INa5S222Ra49FNwKVqbd9HuP2XQCBpoRRjwHxAJxQ5SLAZ5KyOmDFKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rETwzNH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rETwzNH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6E9C16AAE;
	Tue, 11 Nov 2025 01:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823174;
	bh=Z/fxLIQ0JUyn+HNiQwVP3LKMxdZCTKK5MNud0eJKRtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rETwzNH98xnSszbbHDlVJXovRh7wg7JA4aAF9+ZxCqGGye0irVxhtBDV7BrR7TOg9
	 7oUQe0YKeVdfr0ctkRjNefq2Lb1kgnnzdn+P5HhpsgvqBH8FTCPO7Whcku0QOjZpM5
	 rm0PCc7Rgy7oe77mbWmaIPkCYreHVGZ6ncgJw2k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/565] drm/amd/pm: Use cached metrics data on aldebaran
Date: Tue, 11 Nov 2025 09:40:41 +0900
Message-ID: <20251111004531.096357368@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit e87577ef6daa0cfb10ca139c720f0c57bd894174 ]

Cached metrics data validity is 1ms on aldebaran. It's not reasonable
for any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 5a1f24438e472..dcd0422b67895 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1716,7 +1716,7 @@ static ssize_t aldebaran_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



