Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B13154C15;
	Tue, 27 May 2025 17:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365304; cv=none; b=nvtpRmqGPQzXQ0WaJBku3PHrqSg06ke5qvvv8RadwbtNxKqBlafxGP16M76w6Mh0zgXXnlrBqQV/K2aJjIL7E04Edx81vKnjyetJJ+NahDERmkM+f8+Fk26XAu9l+NoVg69nRZ5FMWqhEfeFavAaLs/AlkHNuQLkgcH9S/0tm/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365304; c=relaxed/simple;
	bh=oLPGH4bWWAF9nTJ6GssR6AA5vXRd73jVk1YVVjSNnf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2g5hjvfWKoW59QdYYYr0iNiZidRQLKEIVyAGkYwd6Z8lsymgnDrswyPF7zVIrU10FK5w5dqeEoHOfnuV13yQYmekfANMzY7a5XssXazvIAZOYaEmdxgf7vIFkPO/QurClnW5oY7ZtY6VaWtg/OlN6xb/pwVwCY5aNL6uyo7zFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bi4e+ujn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bi4e+ujn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7628CC4CEE9;
	Tue, 27 May 2025 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365303;
	bh=oLPGH4bWWAF9nTJ6GssR6AA5vXRd73jVk1YVVjSNnf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi4e+ujnIZOgeP7krNJRWBti7E+HmhjAlG9HTosoI/Kc9hTjTwOArrDrc5ffRU6ke
	 7UGQ2diaPUvG85KE+u0EPlGJ5SMHS+0mj8hdYtTObGTRaBe4+oNSPi4A60tWk2ohYC
	 3Pov2X1tYzI/lVbofSBYvBKmoq9hYEnz1pmQEOuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/626] drm/amd/pm: Fetch current power limit from PMFW
Date: Tue, 27 May 2025 18:23:45 +0200
Message-ID: <20250527162458.513741143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b2a9e562dfa156bd53e62ce571f3f8f65d243f14 ]

On SMU v13.0.12, always query the firmware to get the current power
limit as it could be updated through other means also.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 99d2d3092ea54..3fd8da5dc761e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2772,6 +2772,7 @@ int smu_get_power_limit(void *handle,
 			switch (amdgpu_ip_version(adev, MP1_HWIP, 0)) {
 			case IP_VERSION(13, 0, 2):
 			case IP_VERSION(13, 0, 6):
+			case IP_VERSION(13, 0, 12):
 			case IP_VERSION(13, 0, 14):
 			case IP_VERSION(11, 0, 7):
 			case IP_VERSION(11, 0, 11):
-- 
2.39.5



