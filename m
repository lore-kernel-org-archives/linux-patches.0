Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036517;
	b=BD9nFR4fkDViMPvbOzowVOnOJh7+wpFrcL2lzWft3cbei3yeEIexVxResCrWPpGVgxUR
	 mahkvFhxtDBT4ILSMObVaNXtO5ihL0o7l1wLUAfhb0maCc2iJe5irizg86C2fUegn91yr
	 KLGOAwmZFvL7C/qhslOSVECV6whYOTT6wup/V6TLfFCH+tl/XDZMb+lSYhmzQORU41+Dw
	 H9yVZLpcUYBY0agetJLMZauTpWvwm1bBuxB0ENSq9kuokFBgCrPOQ3p0I0Z6qsJwuGcVV
	 2+v6SH1utZlChSY81Z2IRGKcjO2xXMA5lWWkpInwAKyVKUsNGPHqhAPYxfcytt5kJhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jl3hERef4TnbPe474gY8J/Lb2RwPX5fegk/5midlNVE=;
	b=zm2dc5VbwlqSXTwOGYs52e7aeUiS1gRqn3htb0FgtG9shrcZ3EqS7CDWsJDjB8yHglJh
	 b4LUbD7Fg5n9C2P/ePW1uOcE3fpk4S8jKbB8lsCWE8FAT1IHsi/c6IyY8x2Fs27URUJAM
	 GFP3/7FBVROZwS4r959onC2TOKlseVn5+Jsu8kNN+DvJbydFdM/eNPQDO8VhDVLA0UlZW
	 MvYQJuSwKjya4h+Dhk+bvNrmv6h/Giix4jjPlin87kcJRNrl/V3aKRgfn5ZSHkboKRBiC
	 wGaoFP6DZIiTR77UMJTS4QcJF5Pk6arG4iEIe8wE9fAq2ZeKt+o2Q//Eh4IEZ3h8p8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUSLLLlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7513606A339;
	Wed, 18 Nov 2026 21:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUSLLLlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417D51F000CD;
	Wed, 18 Nov 2026 21:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036516;
	bh=Jl3hERef4TnbPe474gY8J/Lb2RwPX5fegk/5midlNVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUSLLLlvNTugf1ZY/LzoC7gzyDOLnr/WYgZt+EkK14TpGhYdLuYLs12v0k6RZnVsa
	 xHj5TDN/h1g1pq4zKpBClFWxIiFo4btQR/pXgEbybmPWcOgcHrxFeDyEf//dPY1Da1
	 3LZR3/2NVrr5pVoTNob/Tu42Z3U2MSp+psNZpWug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e5693071d903b832@bugs.sh,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1088/3318] speakup: Fix NULL pointer dereference on VT switch + selection
Date: Wed, 18 Nov 2026 15:28:30 +0100
Message-ID: <20261118150352.616122828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit e1301ab8a8411fccc7effe0711fc09939a94953c ]

When selecting/pasting very quickly after VT switch, the tty is not set
yet, leading to a NULL dereference. We can just abort the operation.

Reported-by: co+e5693071d903b832@bugs.sh
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: stable@kernel.org
Tested-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260829164945.2691317-3-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/selection.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accessibility/speakup/selection.c b/drivers/accessibility/speakup/selection.c
index 7df7afad5ab42..463a7ef19315e 100644
--- a/drivers/accessibility/speakup/selection.c
+++ b/drivers/accessibility/speakup/selection.c
@@ -61,6 +61,9 @@ static struct speakup_selection_work speakup_sel_work = {
 
 int speakup_set_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	/* we get kref here first in order to avoid a subtle race when
 	 * cancelling selection work. getting kref first establishes the
 	 * invariant that if speakup_sel_work.tty is not NULL when
@@ -120,6 +123,9 @@ static struct speakup_selection_work speakup_paste_work = {
 
 int speakup_paste_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	tty_kref_get(tty);
 	if (cmpxchg(&speakup_paste_work.tty, NULL, tty)) {
 		tty_kref_put(tty);
-- 
2.53.0



