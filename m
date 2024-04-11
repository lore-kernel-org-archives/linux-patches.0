Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FD3143C76;
	Thu, 11 Apr 2024 10:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831345; cv=none; b=fg+jL4ByLwsBCZK9tktkpyu5oBdBCDM/ZxNtbkBGbM4sX0KlddmrEk/FzPew1W/u4oL3epW70rviZDX0csaqLIpunLZ7dWtTgRTC3LJirafT/9qLEZNCe4mrxEM6NmBpXfzjcrjNpNlmMcp6CrBjEoYG2eXqfkHu059+tzouCag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831345; c=relaxed/simple;
	bh=Hcr+pFo6Ev3ObNMu+IwePOqUDyzo+2Vx9q0ypdLOzG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rL/CZD5e/ZVInIXCbZL0MMC7+AxSVPBLmFlJYAEHGdB1ksmOPNSx8H84YQ0HsifQ01KY/bIaR9o1hA+rzGIejdUKpXQYxghJiQiW5AL1OjtEVEFKUdzmJsqV+uBJJq+q2eAlLBWDdkjWIU08LIvmWJlWLPZ7CJD6p4ybLzjE0g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VreaN5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VreaN5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B22C433F1;
	Thu, 11 Apr 2024 10:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831345;
	bh=Hcr+pFo6Ev3ObNMu+IwePOqUDyzo+2Vx9q0ypdLOzG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VreaN5/kW6YpZp8RRtK/R6MsU00Fn+HsCZR318/HIenccZUBsOfyKSWy5avtgy3S
	 fhBgwsGQsSlL1+SlpjLLLs5ba802TmJxabxrQEMVqn0F+nN7kAgnTlVfoOfAO/uUyx
	 R6q6AD/OjJGkIZjYGorTqhewoinRv7Ufhysv7ucs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/114] drm/amd/display: Fix nanosec stat overflow
Date: Thu, 11 Apr 2024 11:56:31 +0200
Message-ID: <20240411095418.817942460@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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



