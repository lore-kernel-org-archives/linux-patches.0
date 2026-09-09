Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536ED54B1C1;
	Wed,  9 Sep 2026 13:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961721; cv=none; b=vFR7esGxCDCAnqgiBX8jLQui0EttR+uon+gWenEXGOw0fd0i9XhC8C2d4QZZiWQoKs/CMzyIhbQQ11h7GZqwByy+3iYIdp//LaI8H5d/72i7bLq0M72Dppuk8NC4mWyRpcmzpQ6teEjr8arvS8v7z4iUtyG2SxlKfzRJuxeHQxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961721; c=relaxed/simple;
	bh=MRhyWKtA20GrY8Z7p6YjT5QEJTcbFcN0/UgArz2Ggus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkUQKrFUDLep55kW9TRBI5cEi6qJ8feT/bJTOUP4ljHqIgdOPGen9NTW1l5AXJOlo4CS0ccvo1hW3uvtK0jKnS4GGIg85BObHM/vn6voNlB1NslVhfJvV7gAEdtYBMsyymKx7UWNaAVzOfNuboBK1gW13a5EtsVTavrS63NTvEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5Zb/ArF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5Zb/ArF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43431F00A3A;
	Wed,  9 Sep 2026 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961720;
	bh=CCeKPCNhrUtLnkLp/qF3yygscMDYq37JFLNCERu8k8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5Zb/ArFChrazEvtDyaUwcNQ1RjXsu/jkGmK58nEQeUQHkx8/PZaUHhyqEtJnWUt0
	 EgHTi1WHV1BA1j3qHWjL+R70Ui3esB95bf9XFxmJmOPK8xoee42lMCdY/d0bAoqlp0
	 Mh8JKGd49gQ/Z0T2FZadOcAQieAg3qkKRRZ3+K14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2280f1cca5e6b0c353e4@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ivy Lopez <skunkolee@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 046/556] usb: gadget: f_midi2: fix use-after-free in string attribute show path
Date: Wed,  9 Sep 2026 15:35:26 +0200
Message-ID: <20260909134232.105144996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2177,13 +2177,13 @@ end:
 
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
@@ -2277,7 +2277,7 @@ static ssize_t f_midi2_block_opts_name_s
 {
 	struct f_midi2_block_opts *opts = to_f_midi2_block_opts(item);
 
-	return f_midi2_opts_str_show(opts->ep->opts, opts->info.name, page);
+	return f_midi2_opts_str_show(opts->ep->opts, &opts->info.name, page);
 }
 
 static ssize_t f_midi2_block_opts_name_store(struct config_item *item,
@@ -2434,7 +2434,7 @@ static ssize_t f_midi2_ep_opts_##name##_
 					     char *page)		\
 {									\
 	struct f_midi2_ep_opts *opts = to_f_midi2_ep_opts(item);	\
-	return f_midi2_opts_str_show(opts->opts, opts->info.name, page);\
+	return f_midi2_opts_str_show(opts->opts, &opts->info.name, page);\
 }									\
 									\
 static ssize_t f_midi2_ep_opts_##name##_store(struct config_item *item,	\
@@ -2589,7 +2589,7 @@ static ssize_t f_midi2_opts_iface_name_s
 {
 	struct f_midi2_opts *opts = to_f_midi2_opts(item);
 
-	return f_midi2_opts_str_show(opts, opts->info.iface_name, page);
+	return f_midi2_opts_str_show(opts, &opts->info.iface_name, page);
 }
 
 static ssize_t f_midi2_opts_iface_name_store(struct config_item *item,


