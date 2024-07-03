Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A3181B9D;
	Wed,  3 Jul 2024 11:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006176; cv=none; b=UO9vfryEVgLv6IjL141zcQGxSFTmK+IGvpRCMy2PCFgfWk3t9sBFXiBKweWeJDbQXDAUFFrXR8zN5hy6k5l9dY1bT82kDm/Sw37m9uSrPT2VP3x3uCIt11xkcUKcNe3vHOkkXI+xWRK2y4DxLdCqZ8XfNJXy9aB7KyCXYHwvxqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006176; c=relaxed/simple;
	bh=I0xIOhOir7pqS1QsF9YrPwntNQCv5QkBuVnAb6ippfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+Jut3JNPCz1yseRs897USW/DKxl8jSfWE6K2Jh28KVSBbt0LJwOIFhm5+cfWgSOxCrtBkBHRrrHwu2g2mr1auMpfpLmgnXQDsjDskpqEiwNJGEdGubZyPF8ab5GnkEDL4hpAb4AUnnYPcV043v71C49Cx5ct9OW6HHYkvTwJE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXkXi6VX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXkXi6VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA08C2BD10;
	Wed,  3 Jul 2024 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006175;
	bh=I0xIOhOir7pqS1QsF9YrPwntNQCv5QkBuVnAb6ippfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXkXi6VXiqW9rWI0yZSzxANdlMTbU7VEpoRmcgYfxa3nnU3mZTuzYDBf+1mtFH+DH
	 hdOVrR1pWFALCJsuKQjyFRZiF1DjFmifeJ6QGMC9tPW/Ed2TeHse/QjSYLX00kBpVW
	 gCep/GEi347nVb3UNkQe2szC+Hj+6yqBUgrMuLVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 326/356] net: can: j1939: recover socket queue on CAN bus error during BAM transmission
Date: Wed,  3 Jul 2024 12:41:02 +0200
Message-ID: <20240703102925.446895565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1681,6 +1681,8 @@ static int j1939_xtp_rx_rts_session_acti
 
 		j1939_session_timers_cancel(session);
 		j1939_session_cancel(session, J1939_XTP_ABORT_BUSY);
+		if (session->transmission)
+			j1939_session_deactivate_activate_next(session);
 
 		return -EBUSY;
 	}


