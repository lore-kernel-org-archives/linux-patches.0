Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED242EAE5;
	Thu, 11 Apr 2024 10:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829947; cv=none; b=i7fx2AVSLYZUzVbFfjVdkY76jm8m3Dvj9KZE2NyCvZtBAd23Or9e3CS9lahuaiNBAEdyN4YW7J8xmLh0Q24HTmXtm4w8c3o8b1rAJQmufUlXmKz9wx2sGteQpInIMk9wpkQaiBcvhCcjH2vpgEdT+rG1nClQdNBCrC1fyjj5TQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829947; c=relaxed/simple;
	bh=0x3ikcQZG/rfdvy9QmUdo+MSyRdLrYU9WtR1KrrUbxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSKIuPkM1F+2A3SX94xHyY9xxIrGv10INRv/BLPYFrOJxtrM2tpgmc3DSS7s1BErPJ2QPEr139VieS8PTFDvKKVva+Hd1/iye7qo9PmJZ+ZB2c4RyhH0pLsN6p9WO/zfIbsEnUQpgcBA5QvkQud9rzobrQ7IL8yLmD5d60EasHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzIo/dfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzIo/dfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92CEC433C7;
	Thu, 11 Apr 2024 10:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829947;
	bh=0x3ikcQZG/rfdvy9QmUdo+MSyRdLrYU9WtR1KrrUbxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzIo/dfuJ6a72B/1N3fBZ/eOxJ7AWaErCsf2Xrj61lhelnPXcu/kTua5yKtWyK2b9
	 UEkqDfjmpw2ADmskpr3LjhhhoHXun7j/RZuZT7upMvBDCxjvvejbVE8i/RR5q57KF8
	 gcnf9vgPLdoQxq0dq2bVFtwztdCvYjaKOhIsjlRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/175] drm/amd/display: Fix nanosec stat overflow
Date: Thu, 11 Apr 2024 11:56:21 +0200
Message-ID: <20240411095424.322092984@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3812094b52e8f..88b312c3eb43a 100644
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
@@ -51,10 +51,10 @@ void mod_stats_update_event(struct mod_stats *mod_stats,
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



