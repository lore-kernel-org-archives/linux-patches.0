Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEDE34CFC3;
	Fri, 21 Nov 2025 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733143; cv=none; b=H71oksDy1goZR38z/PchfI9QOvNODH3sNrFDp0MlGh85k0SgibAYzVss2egoMqEILFMn3DWb4mdk2z0SSuYNcInVe2fmUUIocgAj99+0mCI3dIhVAOOQU0V8Ds93DMZ+Yg0wsT1rqDOxEoy4FdKtrb6wioJo7eaZpwDKw6drtdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733143; c=relaxed/simple;
	bh=aMtYupM/pn3CmTsBlxUe8Q/tZQ3OoE5nbbDobLEFzhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upyF5kSJBfZFvYZ3wke/U2v/LuxDQIwpgz57kl+TAglzLTdVBn8mAdoYhf9gmQ33NeT2D57KoiF0z0ZaIZMXxAwwam646ichb0x4MlOFL/IvvMPrCTQCMlj+PvUojki/KsnebfXjyhx/KhUum05As/lOJbFXMZPmViPxFhvzYmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXRgx4Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXRgx4Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A39C4CEF1;
	Fri, 21 Nov 2025 13:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733143;
	bh=aMtYupM/pn3CmTsBlxUe8Q/tZQ3OoE5nbbDobLEFzhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXRgx4SdNNWCDfGvRiTfP3fFXPbxygrEMsn6dIQ0V95ka+hadMXjpfitHYNbVu00t
	 bGndGW0EQPdKhc53zqfGXMpcTPclXewLu2Qc+JTYSoTPSGup5oFCffIzsJYD6Ev5MF
	 DCT30CQJB/UNbfqOXYoWoCV+NRfKqTM1Us9STF/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 349/529] sctp: Prevent TOCTOU out-of-bounds write
Date: Fri, 21 Nov 2025 14:10:48 +0100
Message-ID: <20251121130243.448352882@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit 95aef86ab231f047bb8085c70666059b58f53c09 ]

For the following path not holding the sock lock,

  sctp_diag_dump() -> sctp_for_each_endpoint() -> sctp_ep_dump()

make sure not to exceed bounds in case the address list has grown
between buffer allocation (time-of-check) and write (time-of-use).

Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251028161506.3294376-3-stefan.wiehler@nokia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index d92b210c70f8e..7799e5abdbd05 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -88,6 +88,9 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
 		memcpy(info, &laddr->a, sizeof(laddr->a));
 		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
 		info += addrlen;
+
+		if (!--addrcnt)
+			break;
 	}
 	rcu_read_unlock();
 
-- 
2.51.0



