Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D52D3D330B;
	Fri, 15 May 2026 16:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862674; cv=none; b=IXrKkivX8/mYzRnur3ux6xkFKABDNi9GoptozjfIbgrNZmS3T9AV2vfVXInvTxFKjt7NUEmjot5gN3b7kgGr1Mn9YaPyn9xh9pnGrpUg9mUAk4psEJ9zCF0Co1JpHwctlNpFJKph01Saamh8O69ywdwFkDbOj2/8H4OjW6qGTlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862674; c=relaxed/simple;
	bh=hDnEKVKDySC3YbKQsRm18Txf5otohbr2fCH+PsmUeRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpAgkHSr/rptFKRFKNWL7pmLabDLVodUZgJskZPwrnIJAdtrVrltAgK5LGG/VQV48hP4veAV/FJGzzIgFeP9pTxcyx29oCPdO7C/LdJNBZPSGPp4NZWj2iRF+ZfxR3jTcnH2x5S0kVZXdka9EIdvqh+PRQS/PChWywTBFm4R8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoAse76Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoAse76Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90EFC2BCB0;
	Fri, 15 May 2026 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862674;
	bh=hDnEKVKDySC3YbKQsRm18Txf5otohbr2fCH+PsmUeRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoAse76QTmBwXaLZvoKu5jJZQv79nQqDXbTC9Cc6QruH1wb7/SJpMZSE2NAr2UiAE
	 LWZq4E2mxApL1FTwgxdd0MhqId2Ejy3JzwunuYPnkRULOFI/Ya8TFbDwYYxg1rLn5l
	 bnx04N6tXi8oob44fpZqWThUN3zg59ZoGj781KVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 140/201] drm/amdgpu/vce: Prevent partial address patches
Date: Fri, 15 May 2026 17:49:18 +0200
Message-ID: <20260515154701.601159976@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit de2a02cc28d6d5d37db07d00a9a684c754a5fd74 upstream.

In the case that only one of lo/hi is valid, the patching could result
in a bad address written to in FW.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -698,6 +698,9 @@ static int amdgpu_vce_cs_reloc(struct am
 	uint64_t addr;
 	int r;
 
+	if (lo >= ib->length_dw || hi >= ib->length_dw)
+		return -EINVAL;
+
 	if (index == 0xffffffff)
 		index = 0;
 


