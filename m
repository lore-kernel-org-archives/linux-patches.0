Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB09D3B6C1E;
	Fri,  4 Sep 2026 05:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498584; cv=none; b=J8QSZ6l0DqVQNRp1hke/1Qd1sW6ookpNCW/iDoYZFnL4LiucvnVMNKQGcDWna8gVmyHyxR+8Hb30Dz6G3vAreqdZtvzXPYUa6BCSECz83cZdxJ0tyNrNhIpRP5r8Y55QKcH6d6QDkNfdEocc29brITmeN7QAOVJb0T3wpDZE9Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498584; c=relaxed/simple;
	bh=tBJRFAGIrNk7sfi5A9C1pnwzd3SKs9ZFHm+0aS+uNTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ka+kQ1Nhl7QnsIt7LCMoNpv0SjUgjUrS8QE7cfrXoxEIELHkzO2eHdgzLk1It/FGnhwWygog0iMwOm27lXhjI0990ZJDbdc0qHdIMQKXlPSt6KZPzcxFZmq8J5vcViQtAIsH8ApLg93Xsat/cz+CDx240b+zIS2dEhokoKOgsbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXnL3PQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXnL3PQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3F61F00A3D;
	Fri,  4 Sep 2026 05:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498581;
	bh=+pBzQEV0LUihjdRKJovSE85xTh9m9VqPO4spl89pP+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXnL3PQtuh5/z+AseOTiuFImJex1miD0DTz8H94IK0kUTlkXXTsiBRu251XPatgZe
	 0QyG8iP1iFU4qQV8x07EpB48RP3vHQBhkiZ1AihzoA7dn8B+Y/TuPHptCCNa+/An8X
	 qu3o0tqtKelb6BLHcr38YMYSggHn4w7yf0SytiuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eaa106d192c9daf37f95@syzkaller.appspotmail.com,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 7.2 113/713] usb: gadget: midi2: remove default configfs groups on teardown
Date: Fri,  4 Sep 2026 06:51:21 +0200
Message-ID: <20260904045806.371903840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 0f6bffb5008f0cba9cad5ded2caccc64466a6e54 upstream.

f_midi2_alloc_inst() creates default configfs child groups for the
default endpoint and default block using configfs_add_default_group(),
setting their internal refcount to 1.

However, during function teardown in f_midi2_free_inst() or EP cleanup
in f_midi2_ep_opts_release(), configfs_remove_default_groups() is
never called, therefore never dropping the refcount and leaking struct
f_midi2_ep_opts and f_midi2_block_opts.

Add the missing configfs_remove_default_groups() in the afformentioned
functions to free the structs properly.

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+eaa106d192c9daf37f95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eaa106d192c9daf37f95
Tested-by: syzbot+eaa106d192c9daf37f95@syzkaller.appspotmail.com
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://patch.msgid.link/20260730135811.1498-1-joshua.crofts1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -2473,6 +2473,7 @@ static void f_midi2_ep_opts_release(stru
 {
 	struct f_midi2_ep_opts *opts = to_f_midi2_ep_opts(item);
 
+	configfs_remove_default_groups(&opts->group);
 	kfree(opts->info.ep_name);
 	kfree(opts->info.product_id);
 	kfree(opts);
@@ -2639,6 +2640,7 @@ static void f_midi2_free_inst(struct usb
 
 	opts = container_of(f, struct f_midi2_opts, func_inst);
 
+	configfs_remove_default_groups(&opts->func_inst.group);
 	kfree(opts->info.iface_name);
 	kfree(opts);
 }


