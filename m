Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F209248F6A;
	Tue, 11 Nov 2025 01:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823278; cv=none; b=goZfOf+1BHcVBpTc8FYh5huG2Sd7svF2gEFXYyxAC0XgL1rUsDX2DyRDVzUPfCzCj866l6lcJMcmbcPx1r++sXisD8haQddhRleRVzCc7PnxyfzZnZ4tu15ZL4qQW3PFUJDfZln8nipzLR1zZ122sh3kcEM5oHRLXcYmvcrlfCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823278; c=relaxed/simple;
	bh=p8zsIi9iV2Jg/QMyA7YeG4QVH4ttlruPdDlAqAL5NzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQko80cQJmqYtyPfeE+pHIAz0uNe+1T//g1xItazQlJiyarTD4aj1MLRBxQtFIWLE0dVT6Yo7cJFwpXH5WYfsyWWjyin1Ww57wd+V9gyctbro7h+uy2yt36J6RX0kXAv68YR8bP+0H+LFxk3T+wG6pKfGDFOl3wcmsR0Jc1hocw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSS0M8OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSS0M8OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C19C4CEFB;
	Tue, 11 Nov 2025 01:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823278;
	bh=p8zsIi9iV2Jg/QMyA7YeG4QVH4ttlruPdDlAqAL5NzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSS0M8OAF6KWcAj1KTyomC9uJT1NG4u7IB4POgo2JWcde3OF8QJLtpdF5Z6rL2ZX1
	 7/ObOL33M+afHOZT7ha8ulatN7EeY3cBceadDer58eZdnNm9QthpIAWqGBNerZOi8e
	 5NNKQ2nJYHGzsMfXTCHzluQh6UPMJNl6ZnSTYHIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	TungYu Lu <tungyu.lu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 267/849] drm/amd/display: Wait until OTG enable state is cleared
Date: Tue, 11 Nov 2025 09:37:17 +0900
Message-ID: <20251111004542.887357803@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: TungYu Lu <tungyu.lu@amd.com>

[ Upstream commit e7496c15d830689cc4fc666b976c845ed2c5ed28 ]

[Why]
Customer reported an issue that OS starts and stops device multiple times
during driver installation. Frequently disabling and enabling OTG may
prevent OTG from being safely disabled and cause incorrect configuration
upon the next enablement.

[How]
Add a wait until OTG_CURRENT_MASTER_EN_STATE is cleared as a short term
solution.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: TungYu Lu <tungyu.lu@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
index ff79c38287df1..5af13706e6014 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
@@ -226,6 +226,11 @@ bool optc401_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
+	// wait until CRTC_CURRENT_MASTER_EN_STATE == 0
+	REG_WAIT(OTG_CONTROL,
+			 OTG_CURRENT_MASTER_EN_STATE,
+			 0, 10, 15000);
+
 	/* CRTC disabled, so disable  clock. */
 	REG_WAIT(OTG_CLOCK_CONTROL,
 			OTG_BUSY, 0,
-- 
2.51.0



