Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2313D6CB7;
	Wed, 20 May 2026 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296961; cv=none; b=bwht48ZDdAajLsDlh2Ov4mNP6lAFzeCDqWUo3jNRKSRwfRrvcKffXKT7ZvtUTgtnh2JkTD9o5C7lwU+sRzz/e/d0V9z6yTha04gc/IsFmr7PWmLCZO3+jttZVuieTz21Jwt+KUiPAeUlHhCeORQPZ8NykNTAKjrUFjzd3jogAhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296961; c=relaxed/simple;
	bh=iK+4RYet7qYOEvsUCxQjFd+TFqvlAGIyzAikKn+k1Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvYi7gZuLzPkRLqootobebI8i+s3KiPaszw7NQMzZIjjmK+1NHSkLxSt7Ud4TTRqE3yVrGHtfJ7DUuR0bGJWPipRrYrELq01ANkeMmq/BOhjb2POF9h11HsYHwOpstiEtJe3ujrpi8bqPe8GITx2wiHdmQni+zbnMJ1u7Z1rgfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPw174cL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPw174cL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B3E1F000E9;
	Wed, 20 May 2026 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296959;
	bh=FmHE8E991tUBtQeEyd0oFY74k+o52IVuvF+wemacYRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPw174cLq/krSt/vLLvkXOkWLQy9gP0JSlt1psf49c2G1Xhiq4Wol5JUUbr8QYyte
	 LAX2ExLEXjyxptoNib6bg86yC+5dRpYx5LTSdT53iMeGdTCFfSr/nOWg3KNdGLknFa
	 A71giwKD5UCT8NpSM8YC5p8HfYPOdFWYxmVu6yjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0995/1146] netconsole: avoid clobbering userdatum value on truncated write
Date: Wed, 20 May 2026 18:20:45 +0200
Message-ID: <20260520162210.748446750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit e6dd94252b0fa7b4fcc00577c6898432c5d97a08 ]

userdatum_value_store() bounds count by MAX_EXTRADATA_VALUE_LEN (200)
and then copies straight into udm->value, which is itself 200 bytes:

	if (count > MAX_EXTRADATA_VALUE_LEN)
		return -EMSGSIZE;
	...
	ret = strscpy(udm->value, buf, sizeof(udm->value));
	if (ret < 0)
		goto out_unlock;

If userspace writes exactly MAX_EXTRADATA_VALUE_LEN bytes with no NUL
within them, strscpy() copies 199 bytes plus a NUL into udm->value and
returns -E2BIG. The function jumps to out_unlock and reports the error
to userspace, but udm->value has already been overwritten with the
truncated string and update_userdata() is skipped, so the corruption
is not yet visible on the wire.

The next successful write to any userdatum entry under the same target
calls update_userdata(), which packs udm->value into the active
netconsole payload. From that point on, every netconsole message
carries the silently truncated value, and userspace has no indication
that a previous, error-returning write left state behind.

Tighten the entry check from "count > MAX_EXTRADATA_VALUE_LEN" to
"count >= MAX_EXTRADATA_VALUE_LEN". With count strictly less than
sizeof(udm->value), strscpy() can no longer return -E2BIG here, so
the corrupting truncation path is removed entirely.

Fixes: 8a6d5fec6c7f ("net: netconsole: add a userdata config_group member to netconsole_target")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260427-netconsole_ai_fixes-v2-2-59965f29d9cc@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 76d7fbf9e1883..595e09bd1ccfc 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1076,15 +1076,13 @@ static ssize_t userdatum_value_store(struct config_item *item, const char *buf,
 	struct userdata *ud;
 	ssize_t ret;
 
-	if (count > MAX_EXTRADATA_VALUE_LEN)
+	if (count >= MAX_EXTRADATA_VALUE_LEN)
 		return -EMSGSIZE;
 
 	mutex_lock(&netconsole_subsys.su_mutex);
 	dynamic_netconsole_mutex_lock();
-
-	ret = strscpy(udm->value, buf, sizeof(udm->value));
-	if (ret < 0)
-		goto out_unlock;
+	/* count is bounded above, so strscpy() cannot truncate here */
+	strscpy(udm->value, buf, sizeof(udm->value));
 	trim_newline(udm->value, sizeof(udm->value));
 
 	ud = to_userdata(item->ci_parent);
-- 
2.53.0



