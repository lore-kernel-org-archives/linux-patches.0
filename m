Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058526;
	b=FmMBxkLRrvKsjRaN1bNoqE5GG/qiSAwqvdSbTUsKGGeN6Fyk0vm1XVdsqaSDVvCpoUp4
	 HeRyx+aFMMYGNzkOpTqPFr6szq/LPj1FjceSCMxGNuemzIk+D9A33Aj9opLwQCn1IFeZx
	 XTzUeVwxuj6yDmS1QwjIe6mjs1o7hKdkBKNT327g6sY64Q1XxuxWxNrRKJk1oaeJa3aHR
	 pEpbcJsF4gGDkQMchAjYKlo2gLlBOZpu4la0E+2YZY/16d3LxdgByDh3tl0OfeJM087zc
	 Q9ZQ4sM5ffdA0Lvj8eWadcOP3kiWOe/8qPCqK3jI9WP7+0xeKlw4+qy817ZVbs1VkaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NqZTCZ1PlAKb3r7AsfC92h8+TP3esLssdxNcNlUs3Sw=;
	b=FolPag+TALihrglix+wscvBgtgH1sNIyL5X7Anvf7soND+JSkmUxL9X0UrnjtjwJx9Q+
	 xkkvIWVub/6BHm12/EJol7DiLlfN1JOCROJNi+ViF9AJOFd0A4w36ILyeMnil25+t4y/d
	 9E37bODnws9xu++0zrEXxi/AX5Cle9nG5ZuQGTqTqcrC4vEcdTAalH1MFmq2DCPi/UwF9
	 fF4NQVdFSg75A98jYS/VbVLVdMKma6a5upobydwhFzK5mw0gPetAZHeIz6gWC0zwynZpO
	 rK9wL8QIy3PtEECBSdfBv9aq0RBAH9V2ymjso7MbjE0vvNatxppoaKn1tEf1rBVpGaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxywOGkd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8A5606A32A;
	Thu, 19 Nov 2026 03:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxywOGkd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E401F000C4;
	Thu, 19 Nov 2026 03:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058526;
	bh=NqZTCZ1PlAKb3r7AsfC92h8+TP3esLssdxNcNlUs3Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxywOGkdIRameqkt6LIHO/Wga76v+SuRAYal5UCnmTcbZAPaYmcjeXkDkDp1UyX+v
	 /rhIsQLJiP0aXp1F3VTd4loCJ/PAEEXu8GGgdw0BcnBqH3jfc3MQEzFAbRnkFisfEi
	 yeNu/YqMCSAKXqHM+CFyDLoz2pAcpTwRT+pf3zr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0516/1848] serial: pmac_zilog: push received data to the port that received it
Date: Wed, 18 Nov 2026 15:42:34 +0100
Message-ID: <20261118145936.297292286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Douglas <me@timdoug.com>

[ Upstream commit f3dc727da3af64abc12b625bbf1eb68d55d882cc ]

pmz_interrupt() drains both channels but, since commit 2e124b4a390c
("TTY: switch tty_flip_buffer_push"), pushes the flip buffer of the
port whose handler is running rather than the port that was drained.
With both ports open, data received on the other port can be left in
its flip buffer until something else pushes it, so its reader may not
see it.

Fixes: 2e124b4a390c ("TTY: switch tty_flip_buffer_push")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-2-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 1d0717fc3729e..a0857b911cdf8 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -455,7 +455,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_a:
 	spin_unlock(&uap_a->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_a->port.state->port);
 
 	if (!uap_b)
 		goto out;
@@ -480,7 +480,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_b:
 	spin_unlock(&uap_b->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_b->port.state->port);
 
  out:
 	return rc;
-- 
2.53.0



