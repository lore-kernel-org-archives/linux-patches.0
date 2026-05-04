Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4E83DDDD7;
	Mon,  4 May 2026 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903483; cv=none; b=NnExnkmpXAISAqBJwIPFQWr0cNHNdDGneFAfJhKkSstI6qEk0fuEwQyjePVZL2H3YVBmgFA2X/tP5Iwnr9j4sfycG41BwCAg5ffBnUnYBu6oPg2YoQN4deTwOKAAzkdwP11qR5jsunKlhlg2KNBtUQcr8vX9NySvZKxQYsndEx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903483; c=relaxed/simple;
	bh=znD6k7zJud0Qo9KLaJanpn5er1wddyEAsf7kzh9fZRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAeR/njG3pcjUg/Z6mwGFNemKEJw7wlsvmnB7tkjRpfTmDua3rVXX09zlziSsF4DnTZVDGKOsuOZQdpgDjsU9gBe2zXvV1VMEVADLm+as31/9Tfk29ycW3sbOZV2Fkc0+HpLWLerwGZNOH9kRcJGzPpWIpLN/Ex4H5FHptOtls8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luqYkZhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luqYkZhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7826C2BCB8;
	Mon,  4 May 2026 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903483;
	bh=znD6k7zJud0Qo9KLaJanpn5er1wddyEAsf7kzh9fZRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luqYkZhG0jeWdUVUTdkpX4PTIbfsuIfJV1uuFxGySHED2yLTr2x2To9k/8SDonNCQ
	 6D5gL6CbthC19lX68gryAhsW/rCxDYyKtTkY/8YNF/rzDFtHDn1YIa+QxbHRWAP3PW
	 aybwRW8Xl8zzliuWqOzfDo8c/6oBPPyp3WxK4MTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 7.0 252/307] 9p: fix access mode flags being ORed instead of replaced
Date: Mon,  4 May 2026 15:52:17 +0200
Message-ID: <20260504135152.302979445@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Pierre Barre <pierre@barre.sh>

commit da2346a48a5a1fed86c3fe3d73c0b60e7b3027c9 upstream.

Since commit 1f3e4142c0eb ("9p: convert to the new mount API"),
v9fs_apply_options() applies parsed mount flags with |= onto flags
already set by v9fs_session_init(). For 9P2000.L, session_init sets
V9FS_ACCESS_CLIENT as the default, so when the user mounts with
"access=user", both bits end up set. Access mode checks compare
against exact values, so having both bits set matches neither mode.

This causes v9fs_fid_lookup() to fall through to the default switch
case, using INVALID_UID (nobody/65534) instead of current_fsuid()
for all fid lookups. Root is then unable to chown or perform other
privileged operations.

Fix by clearing the access mask before applying the user's choice.

Fixes: 1f3e4142c0eb ("9p: convert to the new mount API")
Signed-off-by: Pierre Barre <pierre@barre.sh>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <0ddc72da-d196-4f01-8755-0086f670e779@app.fastmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/v9fs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 057487efaaeb..acda42499ca9 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -413,7 +413,11 @@ static void v9fs_apply_options(struct v9fs_session_info *v9ses,
 	/*
 	 * Note that we must |= flags here as session_init already
 	 * set basic flags. This adds in flags from parsed options.
+	 * Default access flags must be cleared if session options
+	 * changes them to avoid mangling the setting.
 	 */
+	if (ctx->session_opts.flags & V9FS_ACCESS_MASK)
+		v9ses->flags &= ~V9FS_ACCESS_MASK;
 	v9ses->flags |= ctx->session_opts.flags;
 #ifdef CONFIG_9P_FSCACHE
 	v9ses->cachetag = ctx->session_opts.cachetag;
-- 
2.54.0



