Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3F4E3245;
	Wed, 30 Sep 2026 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786797; cv=none; b=NJ0sXLH+lqrmf2QWkqJRIH+B7yewdUhnFlqH44rEGuNO+cOyZQf+zGEfFyXhHtpLKDUKKRG6EU/JxWNXsvM0A/ayY5GpT75Y1R+ulNqZAqEGda9NSBlevRH0ihwe2FH5JFTacNWZ4ezbaFHhcl44GHuTrz5nU/VeRb9sp6Xgw0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786797; c=relaxed/simple;
	bh=d2X7ZeS5S7eaqVYddLSY//6JLX4jvwEeBms50+nsSTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWUC+prBPtA9+0Fw7ZPAk1v9lE3aJqai7Xu4CwoFhko6+H+VKYTVgoD2CpnyJ/0rAGWJccR0dM43I8izL8rI1ehxDcmksNkCgW6jZ08ZcXBM2eNr3HoXVTFVMf6Xs5PIVOc+k1MaxEEtxXsajD7QRJ/3TfUOPAFP2xmyeXfckIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAr5NzA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAr5NzA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3961A1F000FF;
	Wed, 30 Sep 2026 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786795;
	bh=M+eIgC/Pof8+EXkD+dPwBVJEJQUKgPUMeQ99AcdeccI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAr5NzA2Ktak/MmP6+GAl/Lafcvg6gz6MHGI9WTyjuv6A+Dv21KkIQT6BggX6iEM/
	 sZplmctalDeIG9fpf16yqR9BLd7ADcN2loU0cnlzw4aUz3BTFCpECpnggqRrNW0MSG
	 ZM/RAcg2Mn6/FszN2lWke43W9VaJJ7yF+bZRO+nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 6.1 981/982] drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()
Date: Wed, 30 Sep 2026 17:28:37 +0200
Message-ID: <20260930152437.815062742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1228,10 +1228,15 @@ static int amdgpu_atom_execute_table_loc
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


