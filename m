Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C39D3446C6;
	Tue,  6 Jan 2026 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721192; cv=none; b=UCaVHqAZUVPFgck+Iljc152STJt9RaxsHrb2yMeMDe4/3I6GffI0r4HUqxqWDlQ+sAldBB5mNAcLtA3W2Q2k4RLsZk2Hu+x86yBERbmxEEHI/uD8FNRdO8K5wUMGeDj/eGysNSDO+/XlAfJMLQaL0qk6f3lu3kJBSo4RUhIieHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721192; c=relaxed/simple;
	bh=UP1TJUkCnXeWtCApFKX45BCGQZ3SFLGC7G7tyqir67Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J83KSOfzdRYBWnbhYfm+LwYRZJuQzmpU1UdBRHAg309mVkA8KbpzvHw5tFoHI+RbRqMbTCmnMPw20cWwk9FqNqJhqNyfrR8YbxTAildkd5aQzEVRHflOStow4LBsZolVMeT6UB0UFAfVAT63aHwk0Rnkn06mnAD5F0h0SluLk44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdMPJMvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdMPJMvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA9EC116C6;
	Tue,  6 Jan 2026 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721192;
	bh=UP1TJUkCnXeWtCApFKX45BCGQZ3SFLGC7G7tyqir67Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdMPJMvr6OUMjF5kyTsnaeerVogBb4btNt2Re0qoTgyoyd4ubx22/7CfEo8IW9TFW
	 9WC/Uha9G1dTqYzKBxPZxxYCZ4Pa7NA9Kw1prCfvA/vO6luXUCvziSkvhZpJnYhjT7
	 gO8/a5MvcvXD745xpoBQav3z4XsSwr/JLJ4IoFIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Konstantin <answer2019@yandex.ru>,
	Matthew Schwartz <matthew.schwartz@linux.dev>
Subject: [PATCH 6.12 456/567] Revert "drm/amd: Skip power ungate during suspend for VPE"
Date: Tue,  6 Jan 2026 18:03:58 +0100
Message-ID: <20260106170508.214913258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 3925683515e93844be204381d2d5a1df5de34f31 upstream.

Skipping power ungate exposed some scenarios that will fail
like below:

```
amdgpu: Register(0) [regVPEC_QUEUE_RESET_REQ] failed to reach value 0x00000000 != 0x00000001n
amdgpu 0000:c1:00.0: amdgpu: VPE queue reset failed
...
amdgpu: [drm] *ERROR* wait_for_completion_timeout timeout!
```

The underlying s2idle issue that prompted this commit is going to
be fixed in BIOS.
This reverts commit 2a6c826cfeedd7714611ac115371a959ead55bda.

Fixes: 2a6c826cfeed ("drm/amd: Skip power ungate during suspend for VPE")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reported-by: Konstantin <answer2019@yandex.ru>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220812
Reported-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3092,11 +3092,10 @@ int amdgpu_device_set_pg_state(struct am
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
 		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SDMA))
 			continue;
-		/* skip CG for VCE/UVD/VPE, it's handled specially */
+		/* skip CG for VCE/UVD, it's handled specially */
 		if (adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_UVD &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VCE &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VCN &&
-		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VPE &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_JPEG &&
 		    adev->ip_blocks[i].version->funcs->set_powergating_state) {
 			/* enable powergating to save power */


