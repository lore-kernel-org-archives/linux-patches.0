Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8812113B2AC;
	Tue, 27 Feb 2024 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042104; cv=none; b=AegY7av3Zr9k/Lz03PKLFk5hlaihNPWbzNfhQyxQLoy6LZdhmvmsXVnkeAOt+7gAl79RO1mEHmQk0VICM3YRqdYZh6upBuKUF+E/LYq4bQEITxBwXDJFISRYR5nwRxns/2vzaaLeU6Z4M+vUAM+Vj4lyDubME1HEi8VgOVc56o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042104; c=relaxed/simple;
	bh=CST0yNY+E4jTEouVy09CndSggp9RQhmZ/Mm1y0pNXzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9zX6RqZBgSXFNENqVlcKURhZPi+g94lC2hwunvpVgGkf4JIbu7Hp4yiUZIyulgHG2L7ILOEbaJQNsqLtpRhltX2MSmk6GKxAt6WhQI8m/CFJHTpj4VmPlerORhTxQOVbfEh+TAQ77KenmS2OMD7FOFzHXp/XcY24spTOslKudU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQ59Q7O0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQ59Q7O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170F6C433F1;
	Tue, 27 Feb 2024 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042104;
	bh=CST0yNY+E4jTEouVy09CndSggp9RQhmZ/Mm1y0pNXzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQ59Q7O0sm6ylKnu76lg/4lWhcMJIZHG1aO/rBXivay1gAw2coHJZqS6pFr92ZVGW
	 bpEp5rUgPe4xUwdggINYTGEPCbdUs+2Had8xY3OAhmDg1J72sCEL06pWt19Qw/kAhN
	 Ii5hp73ry17i5gGU6uCAJtEgglzyPFWbhzC1j7nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>
Subject: [PATCH 6.6 180/299] Revert "usb: typec: tcpm: reset counter when enter into unattached state after try role"
Date: Tue, 27 Feb 2024 14:24:51 +0100
Message-ID: <20240227131631.638534915@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Ondrej Jirman <megi@xff.cz>

commit 23b1d2d99b0f55326f05e7d757fa197c4a95dc5c upstream.

The reverted commit makes the state machine only ever go from SRC_ATTACH_WAIT
to SNK_TRY in endless loop when toggling. After revert it goes to SRC_ATTACHED
after initially trying SNK_TRY earlier, as it should for toggling to ever detect
the power source mode and the port is again able to provide power to attached
power sinks.

This reverts commit 2d6d80127006ae3da26b1f21a65eccf957f2d1e5.

Cc: stable@vger.kernel.org
Fixes: 2d6d80127006 ("usb: typec: tcpm: reset counter when enter into unattached state after try role")
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Link: https://lore.kernel.org/r/20240217162023.1719738-1-megi@xff.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3730,9 +3730,6 @@ static void tcpm_detach(struct tcpm_port
 	if (tcpm_port_is_disconnected(port))
 		port->hard_reset_count = 0;
 
-	port->try_src_count = 0;
-	port->try_snk_count = 0;
-
 	if (!port->attached)
 		return;
 


