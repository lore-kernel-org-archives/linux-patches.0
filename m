Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49E1161321;
	Mon,  6 Jan 2025 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177572; cv=none; b=bJn43kClDLBkYDomZQFsnmXxF21k7ybVrir2MJvOPFK+7X0gIISZ2zbmmRQeDm+ZX9WSDCkCVEYjl4n00xPDk6bJrdn17WcL7yAFA6lbJNxe+L838ep+OYoTCb6igdf8gb1oXfP8CvmELPlrY+I1LiYEkeJxbbaUcmhS8D2rMJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177572; c=relaxed/simple;
	bh=Kxx+UYyn+NbsciuHQ1wS2FDNq8GGFOtQO5WZsp0rTFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+UR3Aty6zBMNR0eQOX4RhFCVGB5bKFwcpVy3282RzPLVPFRzUKD//BFje5Hkuv0GpAj5XPXDEoQpHdTVmKHLn/iA0GwxlBkP7QG1fMrEIJsnzu5SNZGh+/OY7x9qabpjtz4HWyUfQ1hZSieU2ofZDSMglzhzep5b97u2zHANYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+xLjrmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+xLjrmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035EBC4CED2;
	Mon,  6 Jan 2025 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177572;
	bh=Kxx+UYyn+NbsciuHQ1wS2FDNq8GGFOtQO5WZsp0rTFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+xLjrmOSTTpw39bPTjtQtRI/JvWmLh27eZU7Ag8J1HVVRM62jwMgF9kYxxjl7Xe9
	 AhqkoVqGAxlAGCZHuT8Y68r9dfglctcyN3bFzKA5ykAS7VDk1jS8Q0/MAy3QkQG7JA
	 xwtk1/FBdFjF+JWTY6PFpe/jFPh8QYSGEqyhsWfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 208/222] net/sctp: Prevent autoclose integer overflow in sctp_association_init()
Date: Mon,  6 Jan 2025 16:16:52 +0100
Message-ID: <20250106151158.639521205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 4e86729d1ff329815a6e8a920cb554a1d4cb5b8d upstream.

While by default max_autoclose equals to INT_MAX / HZ, one may set
net.sctp.max_autoclose to UINT_MAX. There is code in
sctp_association_init() that can consequently trigger overflow.

Cc: stable@vger.kernel.org
Fixes: 9f70f46bd4c7 ("sctp: properly latch and use autoclose value from sock to association")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20241219162114.2863827-1-kniv@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -137,7 +137,8 @@ static struct sctp_association *sctp_ass
 		= 5 * asoc->rto_max;
 
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_SACK] = asoc->sackdelay;
-	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] = sp->autoclose * HZ;
+	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] =
+		(unsigned long)sp->autoclose * HZ;
 
 	/* Initializes the timers */
 	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)


