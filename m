Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF551A76A4;
	Tue, 30 Jul 2024 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359837; cv=none; b=KVIk2tZdOObFsR919BMgqN3VuMh7XLlQlJP+wGRtP27hUm2S95i429FRMFwr3Men9wX1TC7+daWzuOMEdm+twiZ/CWG+kyYkLhLTEFBYaHh6m7IBqny12rFL9+y0Wcf0KpgUE/ypsxu/Qh6VwxC1PUewRLG+HXM9TdBhqukKMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359837; c=relaxed/simple;
	bh=NrSUOSvtW8lOeg7bTeLNpZeKNkVk8b9/f12j4sDTyKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYScBVZ8/M4xPsMPbw20dcB+Hb14gtCrR669zJhne/XJvLmX9LdTtgLgz6SPydw4Owh4/vS4eX1QHqkl5dcidJhn14CWU+JIBlBjhJ0iEqk9u+pxIWr+SroqqjUCjRC/wlT0p1atARJuuWInNs5IYwNeaUGO+hT7BJQZ4UoDanQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3CyTI7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3CyTI7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7F5C32782;
	Tue, 30 Jul 2024 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359837;
	bh=NrSUOSvtW8lOeg7bTeLNpZeKNkVk8b9/f12j4sDTyKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3CyTI7djNfiHD5jtg46ZwIAGasSgJT9aMU/OMHztKwg/KCDMGYejh2B4xdF0OcKR
	 j3B76Pf4Qta/PSpCTaDRRRfZk+v55KP3FqxtgiXfw4UPta5PWT4Kp2SF4JRVKTezdw
	 rIlXgOxDdCMM1uUOCBhAoIb9CIx4Hu6IbZS6Wn6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 544/568] mISDN: Fix a use after free in hfcmulti_tx()
Date: Tue, 30 Jul 2024 17:50:51 +0200
Message-ID: <20240730151701.423643199@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 61ab751451f5ebd0b98e02276a44e23a10110402 ]

Don't dereference *sp after calling dev_kfree_skb(*sp).

Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/8be65f5a-c2dd-4ba0-8a10-bfe5980b8cfb@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 2e5cb9dde3ec5..44383cec1f47a 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -1900,7 +1900,7 @@ hfcmulti_dtmf(struct hfc_multi *hc)
 static void
 hfcmulti_tx(struct hfc_multi *hc, int ch)
 {
-	int i, ii, temp, len = 0;
+	int i, ii, temp, tmp_len, len = 0;
 	int Zspace, z1, z2; /* must be int for calculation */
 	int Fspace, f1, f2;
 	u_char *d;
@@ -2121,14 +2121,15 @@ hfcmulti_tx(struct hfc_multi *hc, int ch)
 		HFC_wait_nodebug(hc);
 	}
 
+	tmp_len = (*sp)->len;
 	dev_kfree_skb(*sp);
 	/* check for next frame */
 	if (bch && get_next_bframe(bch)) {
-		len = (*sp)->len;
+		len = tmp_len;
 		goto next_frame;
 	}
 	if (dch && get_next_dframe(dch)) {
-		len = (*sp)->len;
+		len = tmp_len;
 		goto next_frame;
 	}
 
-- 
2.43.0



