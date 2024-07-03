Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EE218F2DF;
	Wed,  3 Jul 2024 11:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005206; cv=none; b=t+xqQoa+rZ/AmMXZqWqyU8hfoOnjeBYJ3PkGk827PHL+B1zaFSGu5pphDu+oXRwky/lFF8IOkcIlK9GIGj9igXH0BeVdq6vURCtvVNkuqJQyACgNnYzFS0FPzRA3fdWsmtcsw3LZtid2OBdFetTf+zO1Gl3JfNg+PjHHQoAZF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005206; c=relaxed/simple;
	bh=wj7bZlepNdXs1Fj7bam8bL9FQVT60r7H8Z3mdFw1MDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MD3nHAtC8GOHfpEhOhgKtU/CmLv5sykezNaWequMp/24JfWpUs3zjavf29suIFfuD/FcxYGBIGXJB+JN7ywfzEVzUON/jDp9O3uHMqKfyxCxM99cEk0iguX/yKYWUux8wFOp6wMOo601dhghsOVoZDXJgZzU3Sn1tcpMMQSLZc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOaK7MvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOaK7MvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19652C4AF0B;
	Wed,  3 Jul 2024 11:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005206;
	bh=wj7bZlepNdXs1Fj7bam8bL9FQVT60r7H8Z3mdFw1MDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOaK7MvHxbvSCZSaeSOHYbi8IQ6U2xkOOAcZLwcVRbaCICYkwQ55bayqMGUTco0Ed
	 SGp9gM869QW1XWVFsQb80HWqVfGWF1xr44xHmgxYi7SBY7mKdFH+wzKpYi4j6lUWfi
	 efNijgZrOvTIKWlbsJDZwDEkSaz/vctEhP0ZdGvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 262/290] net: can: j1939: recover socket queue on CAN bus error during BAM transmission
Date: Wed,  3 Jul 2024 12:40:43 +0200
Message-ID: <20240703102914.039363611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 9ad1da14ab3bf23087ae45fe399d84a109ddb81a upstream.

Addresses an issue where a CAN bus error during a BAM transmission
could stall the socket queue, preventing further transmissions even
after the bus error is resolved. The fix activates the next queued
session after the error recovery, allowing communication to continue.

Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
Cc: stable@vger.kernel.org
Reported-by: Alexander Hölzl <alexander.hoelzl@gmx.net>
Tested-by: Alexander Hölzl <alexander.hoelzl@gmx.net>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20240528070648.1947203-1-o.rempel@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1662,6 +1662,8 @@ static int j1939_xtp_rx_rts_session_acti
 
 		j1939_session_timers_cancel(session);
 		j1939_session_cancel(session, J1939_XTP_ABORT_BUSY);
+		if (session->transmission)
+			j1939_session_deactivate_activate_next(session);
 
 		return -EBUSY;
 	}


