Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D32251AFE5;
	Wed, 30 Sep 2026 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789659; cv=none; b=Rwp43ULT+VJZVrwgQRZqhZ6CYUM13w9j8ZKClUHbU1bXmelkJzjISBsDZJ5hAxHY/JidqH1lDBuWQJcjiYZtsSdsPMY1K92VoO2/QU2vleB5A3QoXg5n1itvE1edMtvm5twfNU6ANDd1RfG4NK2FS5/+mtql2yoYihlaQRH1tFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789659; c=relaxed/simple;
	bh=9plsavT4VWLMjQLEfkXvRvose3rRCNbo5dv7NC3H7Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jba7GX/1i50JU2ConCedhBxoQqr/Dz44sKIq1CCuQCe2GPgjjxr5ybLxVRPhFrctFEURAk4KgNoKzn9QmdAyj3lpi8T/KoYXxNr9wcknVziAbeJLgHupvEwhmaDs3HEUrqtuNH3hkLKTEMkITicQvngWm/Yt45u1UgDRXnzLn+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2w/NBv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2w/NBv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74D61F00898;
	Wed, 30 Sep 2026 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789658;
	bh=JoB8WUrzarH7sxf3OFVZvnJGtK2rImsNo1WuNK55/nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2w/NBv0Lx6IuiKHxde2CV1Zn9izGfZ0nkB1zhbNylqxUkwZPAK97HOsPPKO71a0g
	 mYQccKIvWpVN4nTq2Bs5Vb0iuq6Y9vcS0AQH25K27kdO8YEiDRJeNlH7SCf4THBRYo
	 HVrwzaYDJ1Nti3EGIHK6VA4ieLGLij98cge46P1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 556/877] net: tls: fix silent data drop under pipe back-pressure
Date: Wed, 30 Sep 2026 17:24:27 +0200
Message-ID: <20260930152426.642393820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7e7be31bfdb066c1c780dcd6b1224078fc54063f ]

tls_sw_splice_read() uses len when advancing rxm->offset / rxm->full_len
after skb_splice_bits(), rather than copied (the actual number of bytes
successfully spliced into the pipe). When the destination pipe cannot
accept all the requested bytes, splice_to_pipe() returns fewer bytes
than len, and 'len - copied' of data is effectively skipped over.

Fixes: e062fe99cccd ("tls: splice_read: fix accessing pre-processed records")
Link: https://patch.msgid.link/20260429222944.2139041-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index a41fd85279bcd..323ac8b1ad0c8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2337,9 +2337,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (copied < 0)
 		goto splice_requeue;
 
-	if (chunk < rxm->full_len) {
-		rxm->offset += len;
-		rxm->full_len -= len;
+	if (copied < rxm->full_len) {
+		rxm->offset += copied;
+		rxm->full_len -= copied;
 		goto splice_requeue;
 	}
 
-- 
2.53.0



