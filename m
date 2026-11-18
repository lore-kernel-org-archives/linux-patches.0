Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023420;
	b=UI49aJYN0zJF9BDdDUHU/PnJsnS9ghXGSZJHdcEop+Dh/l0V8bsJOlYHvHen1i99YEDM
	 nUMO+5aiUKU3QcomIuCA6sTIed2LptV3gZsEvj8is5ud+Ibhc0O/CecZFrz3Xbnbfb3WP
	 55uMaS2kA4lnvInxbsMrbenoLjBKVOt33JKWtHGMKhAQHtJsd/R7ADBgV+IHYNiJGpKny
	 aqOWIF7pXmf7nI+uiNaKCApLlVSBZGsfG/05KxtKW2J5khDuvxdwr9vSiwY8P6wsQyh+m
	 hCmD3rvZj6G+hXaog1gijrr4LvDWN9nXBIE598EnubCQWzDuqH3/F3QKpnuvabNsnVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nTIychbPi977nFUAjW9J2zYJq9xoRxCDLVvlpVlSNBU=;
	b=4zvoEezVBaPrholnydzqdvz0bHBqg5kafMZAu5TMUVTbIagPBue5cI0r0H9SbPK8OEv4
	 61mz/HoyschR/cTs5hXZVrk8DCaTBlCfvxdpKW33sLPiJcht8BYvMyhjcTu/HRR/XiMev
	 AdhMKy+MtI1IwcwRMUb8St8podp124iw1M7JSnwxkQ/QJybEF/Jfl6atlfrDfgJLcbNrv
	 SZWI95dsp8gFE2HNYaz2UzBGflApefGPzacyEaGVxSwT53XEbnG2YnNFljkHtIsmLThAs
	 jb/RBXCFTHzqh+Evsfr/g5p+V5+ElDonppcBdWtm3fy15hdvFTWH83nM/cRkTlhBu5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiBSINL7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035A606A325;
	Wed, 18 Nov 2026 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiBSINL7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37401F000C6;
	Wed, 18 Nov 2026 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023420;
	bh=nTIychbPi977nFUAjW9J2zYJq9xoRxCDLVvlpVlSNBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiBSINL7RlK05X3ShoWvkOs11MJVAJCAnfmsi0nXamXuDNcpYqHt+wOqol1MRZz5D
	 FWzkHmAs6pD4mKHBzSOlaVjlwdOcO/OTCIsksOgo8A2tpOhaxi78e/V0dMhC5c0S5N
	 jAAuamP2Oeg+hBqsdC0nIRp1+ZuEXh2hDndsrF20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Roland Dreier <rolanddreier@rivian.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0363/2151] firmware: arm_scmi: Fix error path leak in scmi_raw_message_send()
Date: Wed, 18 Nov 2026 15:34:58 +0100
Message-ID: <20261118150135.318190041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <rolanddreier@rivian.com>

[ Upstream commit 1adabdce41b93ee6f72f29daa1d3e1750e7b7bd1 ]

When the is_transport_polling_capable() check fails in scmi_raw_message_send(),
it returns -EINVAL without doing scmi_xfer_raw_put(), which will leak a
struct scmi_xfer.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260909-scmi-async-done-race-v2-0-cc5dec25c6be%40rivian.com
Fixes: 07cb8c324b63 ("firmware: arm_scmi: Add polling support to raw mode")
Signed-off-by: Roland Dreier <rolanddreier@rivian.com>
Link: https://patch.msgid.link/20260909-scmi-raw-v1-1-de3fa75d2c6f@rivian.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/raw_mode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 415506f61e6a9..c04d2d2e0c9ec 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -711,6 +711,7 @@ static int scmi_raw_message_send(struct scmi_raw_mode_info *raw,
 		} else {
 			dev_err(raw->handle->dev,
 				"Failed to send RAW message - Polling NOT supported\n");
+			scmi_xfer_raw_put(raw->handle, xfer);
 			return -EINVAL;
 		}
 	}
-- 
2.53.0



