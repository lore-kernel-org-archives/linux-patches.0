Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0DB6BB29;
	Thu, 11 Apr 2024 10:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832215; cv=none; b=jY8Hn43kWgoHMvBFuqJdcLSZ2929ff047cuDaWUwLd0OEbV2tU4doA4H76jAASMOl0WWzqYplW/VhqMOWOlJRiwggI8v9eiaV5RI8EBDu6SCUpuANdVgLUybngXxQKW2iWSq6D2fnZc5b2xUyvZ3a6CqpLAAl7ta96kScYBO6sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832215; c=relaxed/simple;
	bh=LoA4Z59znQ5Qt4hcUTqWqNsFrzlY4BqODf7Pu2AwDwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5PNCuFtgMc1ZDHRZ8VVlWmNCOmNPswFtxyqG006Xuf3K2CKd64kRvwgxrg50cR4ta8ekSx1hu/Tz0C0/MTr/WgvMUV14xRcYpXQPA54H1PRmCfflaT7444Ce/IzdpChBuWfldx5QVI9gbYrsu5qyLz6HhDzrN+wg3iXlDGTr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly6cjQ18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly6cjQ18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F75C433F1;
	Thu, 11 Apr 2024 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832215;
	bh=LoA4Z59znQ5Qt4hcUTqWqNsFrzlY4BqODf7Pu2AwDwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ly6cjQ18EHZ5K7coutV1h0AI6JZk6t/LqR2TUQDnP030jHtE/JhKJEXjMBXNeib7n
	 70GtHqKZccAg6m8A0I0jd0IZc/9BPK+9VHzH+3Y8dVVlpXTU+tZqYW+SkPfNXiJsbC
	 ua1htiT+5g+NWT5kDkuEFpVtxVixqDe4ZFSxv97w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/294] drm/amd/display: Fix nanosec stat overflow
Date: Thu, 11 Apr 2024 11:57:09 +0200
Message-ID: <20240411095443.562888849@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



