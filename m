Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7961716F8F5;
	Wed,  3 Jul 2024 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004255; cv=none; b=Y4hW/vd8s9kPi3ZDnj5pFKblAcMB4j49LFrzQbVqbmogZwR1J8IzWFhuHM6vQf4FwKnb5qePfScXFr40hcmbDSNxsjoI6WnTUZbQNXOkrPZNfJuYSLHN9ypTcD7OiVlIU2KiO1Ze+mIQZKFrrYrl+r4zBp80O0pHr+7vZrAtvfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004255; c=relaxed/simple;
	bh=Tsr0A8yKd7TNe8szDrdTMvn0qsl9D8QWi4oD7LXsWYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdcwS3RtiuHw6UZePYpdUpcwDeUZJjFQvGDnDLO6L7o2729r2g2gsuIyhu0udyUagv87aEdneZrSCrt7zMSRa7DrplxotCPh/YxfTokozxBF8jR7WeHotsL9E9XnDjcWaQ6haNUD1ByjdOUfBA5Tx272HEUCZDcraNhBkX2oFfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOFmvbrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOFmvbrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40E6C32781;
	Wed,  3 Jul 2024 10:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004255;
	bh=Tsr0A8yKd7TNe8szDrdTMvn0qsl9D8QWi4oD7LXsWYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOFmvbrwlpYuibeOpZl2yR9hYW69prsRwPs7DGBQkIU/hX+r6bgFGa4Am7+FF8MzD
	 ZTzCnLdVriK5jrfWDcQTVZUz6dfRtiXJkva/TV8RqAYukDgj2t3K8db4q3O0nKro4M
	 DzrINpaQVUq7EzYUvo5W0OrRa9+0kcY5z5WkSWcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 172/189] net: can: j1939: recover socket queue on CAN bus error during BAM transmission
Date: Wed,  3 Jul 2024 12:40:33 +0200
Message-ID: <20240703102847.964972280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


