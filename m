Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9482A4779BE;
	Thu, 20 Aug 2026 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244549; cv=none; b=HLC5y3/vWfOJxPOoo7aAKKUuu9kOtil53JKVVChh/4O+tE2WwKEopYQCp8i+Rv5TNBN4vThaloi1eJX/eouvIAytnuDb5S6z3wsOq4GKO4xBldWxB+/d3CCGrktRpxcb8cIsupzpR0GHeJKBlxok7XvizUlPIMZ/ofFsF/Otw8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244549; c=relaxed/simple;
	bh=m0jYO6jvIKD2khB55SshsD4nwvR4PLIlhErxItxdjYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjbzTjbdyFIIwxf4MntCUqxhYhcSeiWaVgSJklMVoFhccXK/LizdrZaHdDHaL/BdARJ53tZphxVgI96aadPsGqpl/AllC+KzXQVSA1ANMCu9WmDowALPucoSY9YyGc/eua4BQ3m5tvA7zHP4uUfgI1HduEJbY76QQAoRrilq4F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gC9YSnwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gC9YSnwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC051F000E9;
	Thu, 20 Aug 2026 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244548;
	bh=PC9AtzMKc2ebEYjaCBKh/vVw+kXoyiKOqginK07IWhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gC9YSnwJJhY0OELcQ7evk6GyecfDw84rjVm8JMBlaxMBtlYEBKNL5AzWNolbBOd2u
	 oWlXxYlRUF1s6rXaNUVowgU25kqYzEB1C0QpFg9OTWpDVZBsSiFiXDvaL+Z9R/dMEL
	 PzqQmmqUlgFpxxgeiO2zdzYJ8uj4+t541+MR/EtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/235] can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure
Date: Thu, 20 Aug 2026 16:57:23 +0200
Message-ID: <20260820145222.847694617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 68c5724ecd159992f76edb7b57dc508a44c8b7da ]

If the allocation of the SKB in gs_usb_receive_bulk_callback() fails, the
driver returns from the callback without resubmitting the URB in order to
receive further USB in URBs.

This results in a silent performance degradation which, if it occurs
repeatedly, results in starvation of USB in traffic.

Instead of returning immediately, try to resend the URB. If this also
fails, this is logged as an info message.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Fixes: 26949ac935e3 ("can: gs_usb: add CAN-FD support")
Link: https://patch.msgid.link/20260709-gs_usb-resubmit-urb-v1-1-4dd40030cc84@pengutronix.de
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -332,7 +332,7 @@ static void gs_usb_receive_bulk_callback
 	if (hf->echo_id == -1) { /* normal rx */
 		skb = alloc_can_skb(dev->netdev, &cf);
 		if (!skb)
-			return;
+			goto resubmit_urb;
 
 		cf->can_id = le32_to_cpu(hf->can_id);
 


