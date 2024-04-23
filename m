Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD086145B05;
	Tue, 23 Apr 2024 21:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908746; cv=none; b=lClUqQBCAo4BTQBqtwPqBdy5CCJDlULgNCkVvrVVnLiAoILsXlDQF38czSsy4GHk6iI1pXBWjVrskX6VuPzMKNlH+dF72S4KGNfdBEweBYuaZ38TOPbnCiRu1VHiAYpJ0RA5SBXBdSxPbXLk3zlkgIWzHeRFmafG6o+TOPQN6Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908746; c=relaxed/simple;
	bh=avmrYdWoAvwgdI7Ns3ZjNVlS4mj24+xlfAWILD7NsZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK6PUjDPgQD/WYpJmRHGIBNuRH/rRFa0vlhAoNAiflXQT4jLRogwqsSaTFubAU4c2E0a2BfkYV9zwh6FnkwmiPpQNjXrgt0eF4qoJUxeUS9TylNbZXzgzyl1m5mDjiOnC3ksJXOAqAwRV3GZliCpCHkhx0o79bacEHC94HZjDXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fS/CdARi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fS/CdARi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93D1C116B1;
	Tue, 23 Apr 2024 21:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908745;
	bh=avmrYdWoAvwgdI7Ns3ZjNVlS4mj24+xlfAWILD7NsZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS/CdARixeh+ymtZYqZ4rc+RIYDKNDyglfWn50xBnkzmLxTm1OjU569dHjwvhTgyP
	 xaATMD+1gNQP7zp9+vy9ZDAAVcEETJHXbQvNopaIeRh4PmziFeDx2qh9plF+HNw2wK
	 ZmZcEy6LRdS9J3Qcq+U5Bk5GyRGEoOM50O+z+nEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.1 119/141] speakup: Avoid crash on very long word
Date: Tue, 23 Apr 2024 14:39:47 -0700
Message-ID: <20240423213857.071116957@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit c8d2f34ea96ea3bce6ba2535f867f0d4ee3b22e1 upstream.

In case a console is set up really large and contains a really long word
(> 256 characters), we have to stop before the length of the word buffer.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: c6e3fd22cd538 ("Staging: add speakup to the staging directory")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240323164843.1426997-1-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -573,7 +573,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


