Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3031C4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99EBC433D2;
	Wed, 15 Mar 2023 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883468;
	bh=u43F4xL5o6RvI8DWP3xUqSOGEUgFrGIGlZP+lYqUWag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnrZseckNf29erKrpeNOR7U3g06Zhqv1Dbzq4uA8tOIjSzg7OuIwgYmWq/5Tma0Z+
	 XwY6DyGubAJWMB8fb7PeXl4lB9h8Oetxf7JJ7nE1JufNoeDyZn9tSpS1f3fXsAaqVw
	 3AzVzEnu0HtEvVk2pTyTv4Msmv4vC8mRkhhUmZOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 010/143] drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15
Date: Wed, 15 Mar 2023 13:11:36 +0100
Message-Id: <20230315115740.767313969@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit 0dcdf8498eae2727bb33cef3576991dc841d4343 upstream.

Properly skip non-existent registers as well.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2442
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -439,8 +439,9 @@ static int soc15_read_register(struct am
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(soc15_allowed_read_registers); i++) {
 		en = &soc15_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-			reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
 					+ en->reg_offset))
 			continue;
 


