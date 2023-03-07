Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFC6BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23955C433D2;
	Tue,  7 Mar 2023 18:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213851;
	bh=7pcQKjnYXqWQSypu+vZwn5kDD4FPO2Z05CoGPXsuXK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZFjBmq4AFXaMOcSdo/yGBANHYy40dAWr46Sz36FsudKNpEbc3a+8R9eMi83F31pg
	 G87Nwp8mUh1128MwFJtWoK9XNWkXbjRpoQ90tRrDkFcYYXXNLTsZHRiAvDpeUwGuz4
	 KuBCjNpegmUPlQxk+TK7G7HmIn8JTH9PRyrrLSyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Syed Hassan <Syed.Hassan@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 600/885] drm/amd/display: Defer DIG FIFO disable after VID stream enable
Date: Tue,  7 Mar 2023 17:58:54 +0100
Message-Id: <20230307170028.415554987@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 2d90a1c054831338d57b39aec4d273cf3e867590 ]

[Why]
On some monitors we see a brief flash of corruption during the
monitor disable sequence caused by FIFO being disabled in the middle
of an active DP stream.

[How]
Wait until DP vid stream is disabled before turning off the FIFO.

The FIFO reset on DP unblank should take care of clearing any FIFO
error, if any.

Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Syed Hassan <Syed.Hassan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c   | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
index 38842f938bed0..0926db0183383 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
@@ -278,10 +278,10 @@ static void enc314_stream_encoder_dp_blank(
 	struct dc_link *link,
 	struct stream_encoder *enc)
 {
-	/* New to DCN314 - disable the FIFO before VID stream disable. */
-	enc314_disable_fifo(enc);
-
 	enc1_stream_encoder_dp_blank(link, enc);
+
+	/* Disable FIFO after the DP vid stream is disabled to avoid corruption. */
+	enc314_disable_fifo(enc);
 }
 
 static void enc314_stream_encoder_dp_unblank(
-- 
2.39.2



