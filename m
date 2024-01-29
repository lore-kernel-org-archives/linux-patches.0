Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E66A15A483;
	Mon, 29 Jan 2024 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548253; cv=none; b=rGN2Y37CbwgZpkntrlXaaVTjkBqDw0NVXLqNRFGRR0KzgxpxHDjEtPAo5MHluBZ7IKo0GD5kkT5Dha06ylNzvn0wajkcCpLlbK9EZvzg5oXz/WtH7gmPgU4xkDk2LYF+YgMra2hmyho8e6CZ2rjnAzsDXWPP3HpHyuUo9PFd2oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548253; c=relaxed/simple;
	bh=HHFBvMlrjlv8Ox879KTf2M6hmOdHmi6lqkO+W9ONorI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF06IuWbUgAlT7L9NJK8sOXZCEZnmPJcZmv79Ex4S4Jb8/2M+qtlaeZ5ea18lzRnoTphBKR58KRTB4W0UeWjmuHyPxw+3cC68olAcTBD7PH1TsnVyVlzZ6X+1aNDM365aGlJWE5ak9d8R17UFd3mTvN1m887ALx/d5xz0eM4Auk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK0Up0X6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK0Up0X6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6CDC433F1;
	Mon, 29 Jan 2024 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548252;
	bh=HHFBvMlrjlv8Ox879KTf2M6hmOdHmi6lqkO+W9ONorI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK0Up0X6ZQqUhc5bakhf/cl6qpJoo9St0RZsmlf6UR0ohGstJmSC+wBqnr3oIE0CF
	 Zv+CNu3KD2je121wG+DaSp7whXhmmwnOxtTwd5Pwt1NUF5IUkMuUK/KlCACZtTALQD
	 VfmZZRfALBkwwnQoQbWNtyr+8PNZtR/ghRPcTYcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 274/346] drm/amd/pm: Fetch current power limit from FW
Date: Mon, 29 Jan 2024 09:05:05 -0800
Message-ID: <20240129170024.439763337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit f1807682de0edbff6c1e46b19642a517d2e15c57 upstream.

Power limit of SMUv13.0.6 SOCs can be updated by out-of-band ways. Fetch
the limit from firmware instead of using cached values.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2502,6 +2502,7 @@ int smu_get_power_limit(void *handle,
 		case SMU_PPT_LIMIT_CURRENT:
 			switch (amdgpu_ip_version(adev, MP1_HWIP, 0)) {
 			case IP_VERSION(13, 0, 2):
+			case IP_VERSION(13, 0, 6):
 			case IP_VERSION(11, 0, 7):
 			case IP_VERSION(11, 0, 11):
 			case IP_VERSION(11, 0, 12):


