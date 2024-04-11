Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7B01E48E;
	Thu, 11 Apr 2024 10:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832625; cv=none; b=fa5V5w9DWRsLjkjWD6fhd2dTzaGIxRXJ76BUKJ1BIZEXtpbO7ZqQifXoKqRCiLgP2UZGDJlP3ns5Gk90QjCUCnbhghnpmxf6qNj4/ztYOqOwGSP8YrNyTHoe/0P3KA0ZzK46Kwv5l+04eNvfBQA/i6E411ePLf5WInXQAYEuJRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832625; c=relaxed/simple;
	bh=xFod9jHuRR1xa0MFi4Snsjp5xqLHnktLt43S/vnlHoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAZYVIHLM3+EOfVdW79PzwRq7apdFE8XxJKnIlMI6ij4hWj9bnQwBFCF1ZQO32hI0jHgZ20uQvbVy1MNhrxMajVC4yPneGKnAAJCbhGNfvmplu5lOv2aIe4MhoKKvt2iU7joaCHsDG/aT0GgAQQJ4B5zTX7ptShDhN9IVNs+P4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLspeVAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLspeVAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21778C433F1;
	Thu, 11 Apr 2024 10:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832625;
	bh=xFod9jHuRR1xa0MFi4Snsjp5xqLHnktLt43S/vnlHoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLspeVASEWjhuPMG+BUNbht34rjbSaUhvkGDBd/Vc9C3zXOCSoDNgJGqTkuSjPyqS
	 SRE77duSrRmKkXYOJ5UnLfNjeRlRcSJ/KY3VKaaTu/d1TMRAOYwxVnST42T4WRR1aV
	 gw+7jrlrJbvZyLbjEEvb9YDQe4b4v2lgOO0taGbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/57] drm/amd/display: Fix nanosec stat overflow
Date: Thu, 11 Apr 2024 11:57:37 +0200
Message-ID: <20240411095408.877133522@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 14d68acfd04b39f34eea7bea65dda652e6db5bf6 ]

[Why]
Nanosec stats can overflow on long running systems potentially causing
statistic logging issues.

[How]
Use 64bit types for nanosec stats to ensure no overflow.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/inc/mod_stats.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h b/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
index 4220fd8fdd60c..54cd86060f4d6 100644
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
@@ -57,10 +57,10 @@ void mod_stats_update_event(struct mod_stats *mod_stats,
 		unsigned int length);
 
 void mod_stats_update_flip(struct mod_stats *mod_stats,
-		unsigned long timestamp_in_ns);
+		unsigned long long timestamp_in_ns);
 
 void mod_stats_update_vupdate(struct mod_stats *mod_stats,
-		unsigned long timestamp_in_ns);
+		unsigned long long timestamp_in_ns);
 
 void mod_stats_update_freesync(struct mod_stats *mod_stats,
 		unsigned int v_total_min,
-- 
2.43.0



