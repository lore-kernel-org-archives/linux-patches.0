Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059467;
	b=ZAnUJsiBwEhslgWwlJf/5oXaVZNEhzlraa0c7F74TsDijq7G7CLNom+Zvp02mOwJkoJI
	 Tyh6e1rH5lI44oArKBB2MRzePs+3kv+spoOT07DPyacKpBOwMSHHTxuzIsASrw2Kl48od
	 kttq+NzyMznJCghFl6FMa9pHpv9zIOdv8O3NrMYHyRY0xYfy41oz79aI3DcX7Czsx8NvY
	 IBBejK9KzW/ARJSxQ/Vd03mIEsji/QpdKQ+i5KiJgk3g5prhij5IsiF7ZLRwTTHqiCy+w
	 Mh9zKX1Ntky+vi7r8YwtD4Rv0KG2UtCnUAQTHLaH6nmpqPBlak5r3DX6PgkhTktKrxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ay7gIlzBokujsw81GArTojZJyorCXMP1TTM8zSMBpAI=;
	b=UZGMc5g6pr2SaQTVtsVjvmmq2zflLNodKJC28zTplwiL7xIMb+9gfuWXAOZYtlDuYd9Q
	 bShjWzlCurZpM1IcRMM9SgTcUDwSfeY6HaRIdwgO7vnXYUV6flme8ksKskffb9bKQjVE8
	 S8niMmg5BCWAQSmmiJ9R2n1WaLKA5FGBxJpm1beByEtmny8baHvHPuSlsx9Zw8jKDIW+U
	 Y7uSbSEpBma5WIlDpT9pgCFTcBOSmDpfx6Zccr9i92k9gT3U7pux/RSzzKjXcMSRQoZBW
	 96t8J/JkpIczalY66zm/L25WPKAHnvaZ94hlshXSVNlmFFIhdcXxDv9Fk1mgcxNlUag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvZTu8+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F730606A31C;
	Thu, 19 Nov 2026 03:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvZTu8+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8487E1F000C4;
	Thu, 19 Nov 2026 03:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059467;
	bh=ay7gIlzBokujsw81GArTojZJyorCXMP1TTM8zSMBpAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvZTu8+aECunRCM6CHGNxLAJM+01uvqp37sUp3735ZkedcB5xRowKelnIEV/opk56
	 O0P8ogecOQ71Pf8aif4HL2d45il8E0FrXdN8U9RF+3qCfxqKLmAFUII3jW5krNO0TV
	 igdbtExnO0QXCTzydXtHqjtLdB8lLvGTtkESEfWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0853/1848] take the guts of file-to-pipe splice into a helper function
Date: Wed, 18 Nov 2026 15:48:11 +0100
Message-ID: <20261118145952.266574715@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit faa97c48c33454ac0107db930a491b692dd1dff1 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 79b496ebe382 ("splice: avoid stale f_pos writeback on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 070b192b56386..8237ed720a35f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1005,6 +1005,23 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
 
+static long splice_file_to_pipe(struct file *in,
+			 struct pipe_inode_info *opipe,
+			 loff_t *offset,
+			 size_t len, unsigned int flags)
+{
+	long ret;
+
+	pipe_lock(opipe);
+	ret = wait_for_space(opipe, flags);
+	if (!ret)
+		ret = do_splice_to(in, offset, opipe, len, flags);
+	pipe_unlock(opipe);
+	if (ret > 0)
+		wakeup_pipe_readers(opipe);
+	return ret;
+}
+
 /*
  * Determine where to splice to/from.
  */
@@ -1084,13 +1101,7 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		if (out->f_flags & O_NONBLOCK)
 			flags |= SPLICE_F_NONBLOCK;
 
-		pipe_lock(opipe);
-		ret = wait_for_space(opipe, flags);
-		if (!ret)
-			ret = do_splice_to(in, &offset, opipe, len, flags);
-		pipe_unlock(opipe);
-		if (ret > 0)
-			wakeup_pipe_readers(opipe);
+		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
 		if (!off_in)
 			in->f_pos = offset;
 		else
-- 
2.53.0



