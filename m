Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D3A1448EF;
	Thu, 11 Apr 2024 10:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830331; cv=none; b=cmP2FBSMnazW7PMoT65O+hWUsQeUucfUJg5vV1ap3+8KN+B07TWesQQmnACY84IMJ3aVrDH6FTKLO5Y4tyq/fOXwakIB41lmKwqurhbgBEMP+JeTIpUbHJwUT7RsGl7pOnF87NmXH4DXmNtEpUzpFmVQnBLcfG6qiBTGCvw6g+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830331; c=relaxed/simple;
	bh=FzjpLgJVeT3I3PuMr7TVFCW9vBbGrUyKwj7KKZ+jcLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDrWfDpQTDnxXy/A8ajYt9pjQZ6ql5avv+HizR/ExBP5LVCtErh7xYbS0GqCzGkcfHv1FVn5xSGbaiKnX8Q/OMHbGJz0Pev3rujXAlr9BUxtwmUh9UUHeom535A2LlW5i+Z3h6TD7yzMm1HVBus/AViFCHkvK7bM14bq3FQEtTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0UzP34o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0UzP34o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB263C433C7;
	Thu, 11 Apr 2024 10:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830331;
	bh=FzjpLgJVeT3I3PuMr7TVFCW9vBbGrUyKwj7KKZ+jcLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0UzP34oQkpPRAvCUohU0Sp3tDxinnvslgVfmUi0N14CPC7YwajDgfomtRhdXyrHz
	 57WAmNRLBDEqVqPev1TLscy/F4YoQBOqcrJpj8cgHia5lM1UnSgCp8EarjlvnJHpRV
	 lFFYXJnMUsPrniO3BQfiGpfvGnyEFePek2Lqqzvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 112/143] thunderbolt: Calculate DisplayPort tunnel bandwidth after DPRX capabilities read
Date: Thu, 11 Apr 2024 11:56:20 +0200
Message-ID: <20240411095424.279259043@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit ccd845021147dc8257a05ed8f5a7f9c61a9101e3 ]

According to USB4 Connection Manager guide, after DisplayPort tunnel was
setup, the DPRX capabilities read is performed by the DPTX. According to
VESA spec, this shall be completed within 5 seconds after the DisplayPort
tunnel was setup. Hence, if the bit: DPRX Capabilities Read Done, was
not set to '1' by this time, we timeout and fail calculating DisplayPort
tunnel consumed bandwidth.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tunnel.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index 6fffb2c82d3d1..4f09216b70f90 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1196,17 +1196,13 @@ static int tb_dp_consumed_bandwidth(struct tb_tunnel *tunnel, int *consumed_up,
 		/*
 		 * Then see if the DPRX negotiation is ready and if yes
 		 * return that bandwidth (it may be smaller than the
-		 * reduced one). Otherwise return the remote (possibly
-		 * reduced) caps.
+		 * reduced one). According to VESA spec, the DPRX
+		 * negotiation shall compete in 5 seconds after tunnel
+		 * established. We give it 100ms extra just in case.
 		 */
-		ret = tb_dp_wait_dprx(tunnel, 150);
-		if (ret) {
-			if (ret == -ETIMEDOUT)
-				ret = tb_dp_read_cap(tunnel, DP_REMOTE_CAP,
-						     &rate, &lanes);
-			if (ret)
-				return ret;
-		}
+		ret = tb_dp_wait_dprx(tunnel, 5100);
+		if (ret)
+			return ret;
 		ret = tb_dp_read_cap(tunnel, DP_COMMON_CAP, &rate, &lanes);
 		if (ret)
 			return ret;
-- 
2.43.0



