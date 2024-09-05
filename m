Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0454019884B;
	Thu,  5 Sep 2024 09:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530248; cv=none; b=uS37xbFA7ZILmzT0U/IZulywVoU6J2oHB4ujGOR/EPwO8xB1k13U7m9t8yIi9htsCoN3YCigAvpT9mBC7f4E18gc/4vg0QvUFAoUZd60K/VKVRD6UrJwH+n0GdOU8iZvxeztxIDsEXy1tv1+0NOQN/eG5sk4ixvCr0DhvJ6XEFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530248; c=relaxed/simple;
	bh=kemq5CCtLeupnCjYitz2gA+MP4gQd8Rwk4qnFlMgFzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFHpA4SM9/nGKyV7xGnZKNb0cO8kzWF3QhtEL98P7GHx9BEny7h8yvDjRy7QhdvqEU/sPbbix/M7KeAat0/LYkxhl/DuIbkk4C1/hVtZDgFdnQWpMna1t8LAvD9BisnhOEYz6UiMPbfeA58xkNNS7Ksoh+WymYPlErM0J21M84s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7Cj7Uhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7Cj7Uhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A62AC4CEC3;
	Thu,  5 Sep 2024 09:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530247;
	bh=kemq5CCtLeupnCjYitz2gA+MP4gQd8Rwk4qnFlMgFzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7Cj7UhxAJj0esvLUH2rMUhfaDNPr/1Bbr7n/lFEEZekMQ+11LO5GDh1d6Njb7UdB
	 fzsp5rumsdMPYxK6X3nsT/QgAePKHUyUMhg7OFLtG9+QEUos05REBWOjvXIAYjbaxF
	 wzd2mZubwwe+TyFoyotYIMk6Atu/dIxgMbSeKVdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/132] drm/amdgpu: Fix the uninitialized variable warning
Date: Thu,  5 Sep 2024 11:40:55 +0200
Message-ID: <20240905093724.901744148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 7e39d7ec35883a168343ea02f40e260e176c6c63 ]

Check the user input and phy_id value range to fix
"Using uninitialized value phy_id"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c
index 8ed0e073656f..41ebe690eeff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c
@@ -135,6 +135,10 @@ static ssize_t amdgpu_securedisplay_debugfs_write(struct file *f, const char __u
 		mutex_unlock(&psp->securedisplay_context.mutex);
 		break;
 	case 2:
+		if (size < 3 || phy_id >= TA_SECUREDISPLAY_MAX_PHY) {
+			dev_err(adev->dev, "Invalid input: %s\n", str);
+			return -EINVAL;
+		}
 		mutex_lock(&psp->securedisplay_context.mutex);
 		psp_prep_securedisplay_cmd_buf(psp, &securedisplay_cmd,
 			TA_SECUREDISPLAY_COMMAND__SEND_ROI_CRC);
-- 
2.43.0



