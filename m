Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182314FDA4E;
	Wed, 30 Sep 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784017; cv=none; b=kU9N1K9F0N3/l0xal5jlyARzpjXngDsldMmwy5GHJCgItSQiMuwCM7h5SMhUiljWBWuBDb5TCGqQCsE2swogaKekl6Tl520pquJE1wqslS4ZmfkMF5YsLES7sRH62VgKydrHZjX4hISbeT3/eFEiYTNXzN4r6l6uUJb0Fc59apA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784017; c=relaxed/simple;
	bh=V/r+tpy3eQ4q8ed5hNqng8tRLmbiT4IOY3Obu0fm/L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDAau6fnQz+/RqJqber17h/UoqA9SwfVEEISOVK9qzEovACN2xvshYSInY6j4x5a41GzwzqFgi7pLN97UN3C9EygR3eimqyceZ0pJaplrJVK8mtE0Q6qjqDed6umSH4YMP9oDvg0VzBE6wVZazBhplJgcuWyBA1nE/2ipttrdCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUm4Hp/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUm4Hp/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAF91F000FF;
	Wed, 30 Sep 2026 16:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784011;
	bh=hlg0dtj0rcXFHQpTXrfxAeg5bDAjvQ2IHlqHJqp5SmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUm4Hp/OeDKyEkVmH4pBJXpu5vazP6Dfut+ba1SnShMk+wVepkfCT7YSd3CsHV2Cy
	 LZuWd4gcGkhfDdVyEjO2DHAASKabaa/niYWFSE/m22i8S4tYCiavqU9kvV9kYdpToL
	 chhYw2EkjNzMDVJx2QXnmV/Kzl6OY2yaCSjIMpbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 594/595] drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()
Date: Wed, 30 Sep 2026 17:28:07 +0200
Message-ID: <20260930152400.514952069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit cc9a8e238e42c1f43b98c097995137d644b69245 upstream.

kcalloc() may fail. When WS is non-zero and allocation fails, ectx.ws
remains NULL while ectx.ws_size is set, leading to a potential NULL
pointer dereference in atom_get_src_int() when accessing WS entries.

Return -ENOMEM on allocation failure to avoid the NULL dereference.

Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Roman: added parentheses to the 'if' statement, matching the upstream commit. ]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1225,10 +1225,15 @@ static int amdgpu_atom_execute_table_loc
 	ectx.ps = params;
 	ectx.abort = false;
 	ectx.last_jump = 0;
-	if (ws)
+	if (ws) {
 		ectx.ws = kcalloc(4, ws, GFP_KERNEL);
-	else
+		if (!ectx.ws) {
+			ret = -ENOMEM;
+			goto free;
+		}
+	} else {
 		ectx.ws = NULL;
+	}
 
 	debug_depth++;
 	while (1) {


