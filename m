Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A02196446;
	Thu,  5 Sep 2024 09:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529468; cv=none; b=nZXSPi2AvvT5myfwzB3lBMZKTghsYW6G0oMvd1UsjYPqXD+DHqEP8jA+j9iH/N8+IKel2eaPS1IXcZn2iZ7qNe3jL/fNLIRVPj+76l+0jlS96jXBvlcCkg6QN72coOzzPAZu7It2mqRbOrjyamTTZJZRop7ZYcQJqfQt39U+p9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529468; c=relaxed/simple;
	bh=jN/heiw4hOnjrq5sEe004Vt7RGRlPAaxeG5Oz+5yyZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpoPGGsCCqjIBdRLRETwQ3SZ97z4xYB337cXS0o7RbWBnoWCX5XvPy106ef8Cth+THWNwPaxBJn/+wFt9scBxLAIH/UCPY+Pn3I1EsTO/f63L3DlVisEgS6wAnmkDjm7GY6b+e2XwVqIxRS8ggVwDzsaTFQgBclHPnzh9zAYHO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyqQ2a98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyqQ2a98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25D6C4CEC3;
	Thu,  5 Sep 2024 09:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529468;
	bh=jN/heiw4hOnjrq5sEe004Vt7RGRlPAaxeG5Oz+5yyZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyqQ2a98IRVSUYExEyMIU/S/MuoQ8DRfgdKmGlLm7bvNAji8B6y5vNNJ91Qmw0npk
	 GXvfeLb7+B7f0D6/6tygNJqTpZU049cEKtjmgzK/nehLW/kzbtEWCesxnRDDIEstHi
	 RLR7ooooOt69XehGcEXibkEX7fBAXvZ7JVMNb7ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 042/184] drm/amd/display: Handle the case which quad_part is equal 0
Date: Thu,  5 Sep 2024 11:39:15 +0200
Message-ID: <20240905093733.891330443@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 02fb803db110dbdac9f0d446180f0f7b545e15ff ]

Add code to handle case when quad_part is 0 in gpu_addr_to_uma().

Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn201/dcn201_hwseq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn201/dcn201_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn201/dcn201_hwseq.c
index 6be846635a79..59f46df01551 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn201/dcn201_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn201/dcn201_hwseq.c
@@ -95,8 +95,11 @@ static bool gpu_addr_to_uma(struct dce_hwseq *hwseq,
 	} else if (hwseq->fb_offset.quad_part <= addr->quad_part &&
 			addr->quad_part <= hwseq->uma_top.quad_part) {
 		is_in_uma = true;
+	} else if (addr->quad_part == 0) {
+		is_in_uma = false;
 	} else {
 		is_in_uma = false;
+		BREAK_TO_DEBUGGER();
 	}
 	return is_in_uma;
 }
-- 
2.43.0



