Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A141146D51;
	Thu, 11 Apr 2024 10:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830247; cv=none; b=JyLOgwSpGu4BF8PSlpbjfv848eW25FJhcoSPAp8Jt5AU+q+GTa8Y1JnWJkMmJQEsk3jfseOT775/xzzyrS/KysQFp4KIxhqtI3ZhrD16qB6WIOEyzuXJMux0ZLS/okO8hrefAlG+v6k4jpII6PS5X0UOPwdEOPcZoyZOSr/gLRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830247; c=relaxed/simple;
	bh=2RGnegmN+RCRGduqGVnkJPBJPNJDWF3O3orcRaKFNxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snRZhuQnICcH3tNwZ++uwohvAe9eWxqVdEEqkDJc+7hcgw7ICufG/RzUEwyGJkQfMS4Dg6MqotR8MzlF9MyL5R2A6l/SkcY3yotVs/CUk+cFjxbXAQ7CplPL+QNQQlDwKWWskFBX2+nIot6py4n8ASx/wUxI1tTkg1DmWZK2IJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs0vx7S/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs0vx7S/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D7CC433C7;
	Thu, 11 Apr 2024 10:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830246;
	bh=2RGnegmN+RCRGduqGVnkJPBJPNJDWF3O3orcRaKFNxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs0vx7S/p+Y94XSUGWY34bJS3zw9woVQ7wPScbrpY+aWmplg8nkxhtvnvXxmEb3Df
	 MvH7LAjiGG5KSSfjfPyZ3RgCwwg3rfeb5a5yxhMuLwLCZFNH4MecMhcHoCn6qcxAFX
	 Rsr+d9Q2LY/r0USCiZ87XUxnm7gyAS3mstfGKgCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 083/143] drm/amd/display: Fix nanosec stat overflow
Date: Thu, 11 Apr 2024 11:55:51 +0200
Message-ID: <20240411095423.410356337@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5960dd760e91c..8ce6c22e5d041 100644
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



