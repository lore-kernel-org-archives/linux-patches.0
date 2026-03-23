Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34A623EA85;
	Mon, 23 Mar 2026 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277204; cv=none; b=H/jdXmocLpTb4olb6PB9uz1dXAOS8TxGlo8FXpJ6avu7WIh7tjz4J0qna8Kkbp1CmL2dYxM+iFwN+ijVSZ5OuEyfvN1RF4i5NHRtY5HLTKLBY6H8AM73QIo2O4kM3+hIYfZzvsZa9nG7WwXLhcnv3aZ4AkZJMFguchyJjPwN/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277204; c=relaxed/simple;
	bh=Pjcxg5/YtemkxKM4nQ+p+rY2XeCgVux5nLDSTQLr+I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS7puHoll3LYYYfmnc4C4b9xcPJJdIqNbOb/7Sn4DCalFLzUoo71flpuWr2NVIYfM4fVtDK746TOIxCvrnI5VICU0IkF3Gt4IFjrPf7qG6fYnZAsPJcwKBKni8C174bQ/WkwZBqIJD7k3wAQzZqzwVbtEXuIF10q7q5xfMoD/LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdCf587T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdCf587T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523C7C4CEF7;
	Mon, 23 Mar 2026 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277204;
	bh=Pjcxg5/YtemkxKM4nQ+p+rY2XeCgVux5nLDSTQLr+I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdCf587TamHeFlv5Dlo30gU1zUfmEfLom2bJoFBuK3gWnnsX7J1K/HhqJVzWnZbVZ
	 yE7vLh+PlXWuGOgbOaFt7N9yfBUGUs3TnTXpColR3tdGvorbzt7Mm5lCyjSob7oVle
	 k0QA0d3fdYtYhfFzPg2xiQupBD4NLCq8m+85OEH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 354/460] drm/amdgpu/mmhub3.0.1: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:45:50 +0100
Message-ID: <20260323134535.249674035@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 5d4e88bcfef29569a1db224ef15e28c603666c6d upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5f76083183363c4528a4aaa593f5d38c28fe7d7b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
@@ -117,7 +117,8 @@ mmhub_v3_0_1_print_l2_protection_fault_s
 
 	switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
 	case IP_VERSION(3, 0, 1):
-		mmhub_cid = mmhub_client_ids_v3_0_1[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_v3_0_1) ?
+			mmhub_client_ids_v3_0_1[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


