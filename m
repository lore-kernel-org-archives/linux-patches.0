Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540F022A7F6;
	Sat, 12 Sep 2026 13:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221188; cv=none; b=A2thYmiI4hlIgZhEe4dM76tfYrJCSlSino06cibzXrh5U33WMP4i7jdeoJxQRDn0Yp5U9StP72J7RCsYr1mUxbIndwIV1utlxlqX0H5KVG6XF+vwr3WDMyIOxL2/Gk0Qb7HJaYF5qFphgK+6zLWtv6Nd00+817iOTk5560PU9qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221188; c=relaxed/simple;
	bh=TyqbQPoiW41utsOhUlQJKghXSlytzbnXX8rJVb3J1v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3fcmpqr3fG0IV/mvo9T+ZbpEKmafh40ePP6jHQvvZ5ji7STDHkY5H5bqdzd6zqSOnM4UsrmNgj1m7YGH/93LU+ZNmfAz3TYRrIX/aMVQxeTtnVdQGS3bzxiVedBHC2Q71oJxYJ3DPcOiI2PW3qfDE5Ll3bt3n6MNbkl+Kgq+QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0RN7UAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0RN7UAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9161F000FF;
	Sat, 12 Sep 2026 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221187;
	bh=SmQccNkd0bKNOpSs4eC82gu4c8LsmLvqGzRz80h3ODk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0RN7UAq5d8hULcqbQqB/cdeEryb3EuH6lE0PrGOntdM2SZUo0fwuVwhgyeqTtP6+
	 yu14cNNUYbXpcJvtlumS5PGWznxSMFbi0GVxV3X8WsJICqlhfhcR2o6F/2M7P5gYzk
	 w5z4DlGhuDbUeb3hnDW1UfTia70iL3yBdX8zmbGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2280f1cca5e6b0c353e4@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ivy Lopez <skunkolee@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0331/1424] usb: gadget: f_midi2: fix use-after-free in string attribute show path
Date: Sat, 12 Sep 2026 08:46:03 +0200
Message-ID: <20260912065614.700340339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivy Lopez <skunkolee@gmail.com>

commit fed0aa7c6eaedc6c0d4e362fc91724aa47be4a7b upstream.

f_midi2_opts_str_show() takes the string lock internally, but its
callers dereference the opts->info.<field> pointer before calling it,
outside the lock. This races with f_midi2_opts_str_store(), which
frees the old string under opts->lock when the attribute is written
concurrently, the show path can read a pointer that gets freed
before the lock inside str_show() is even taken.

Change f_midi2_opts_str_show() to take a pointer to the string field,
matching the existing pattern in f_midi2_opts_str_store(), and
dereference it only after the lock is held. Update all three callers
(iface_name, block name, and the EP string option macro) accordingly.

Reported-by: syzbot+2280f1cca5e6b0c353e4@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=2280f1cca5e6b0c353e4
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260816005434.34018-1-skunkolee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -2180,13 +2180,13 @@ end:
 
 /* generic show/store for string */
 static ssize_t f_midi2_opts_str_show(struct f_midi2_opts *opts,
-				     const char *str, char *page)
+				     const char **strp, char *page)
 {
 	int result = 0;
 
 	mutex_lock(&opts->lock);
-	if (str)
-		result = scnprintf(page, PAGE_SIZE, "%s\n", str);
+	if (*strp)
+		result = scnprintf(page, PAGE_SIZE, "%s\n", *strp);
 	mutex_unlock(&opts->lock);
 	return result;
 }
@@ -2280,7 +2280,7 @@ static ssize_t f_midi2_block_opts_name_s
 {
 	struct f_midi2_block_opts *opts = to_f_midi2_block_opts(item);
 
-	return f_midi2_opts_str_show(opts->ep->opts, opts->info.name, page);
+	return f_midi2_opts_str_show(opts->ep->opts, &opts->info.name, page);
 }
 
 static ssize_t f_midi2_block_opts_name_store(struct config_item *item,
@@ -2437,7 +2437,7 @@ static ssize_t f_midi2_ep_opts_##name##_
 					     char *page)		\
 {									\
 	struct f_midi2_ep_opts *opts = to_f_midi2_ep_opts(item);	\
-	return f_midi2_opts_str_show(opts->opts, opts->info.name, page);\
+	return f_midi2_opts_str_show(opts->opts, &opts->info.name, page);\
 }									\
 									\
 static ssize_t f_midi2_ep_opts_##name##_store(struct config_item *item,	\
@@ -2592,7 +2592,7 @@ static ssize_t f_midi2_opts_iface_name_s
 {
 	struct f_midi2_opts *opts = to_f_midi2_opts(item);
 
-	return f_midi2_opts_str_show(opts, opts->info.iface_name, page);
+	return f_midi2_opts_str_show(opts, &opts->info.iface_name, page);
 }
 
 static ssize_t f_midi2_opts_iface_name_store(struct config_item *item,


