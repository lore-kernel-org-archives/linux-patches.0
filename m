Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0473F4101;
	Fri,  4 Sep 2026 06:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501997; cv=none; b=thvereZ5hp8WijDNd4ol8ViCeLQXe+GY4jP72l56Coq+/Bwc2XSPe+C3YwUFI7PKeYu8+wHcRALWhjUaAFVulEIezJQEH6fP+gxWcZSBznbDIbKBINdoQsVECLdP5IuQNUmomsnLIfhiqBk514RuJ+a+73pQV4uHpFaFevQNM2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501997; c=relaxed/simple;
	bh=shwZDuJW054aZpD9XnzgFZqF3/2MXeYIzudHP+/OuLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKcqOy3Beg0V5e8PMMVKDidNs4wfb9usJhxgieXQq1RQQzriTrDWgpDQCypmUQljqSWvOEXSoH57uiiFRPwokOnDqHdIRb1cIR1hoDI+bfPoNsGGkBaIMCpx2exM6g/Xv0A78P6YHrN2IYqHIhVdSLQB2RA6nuwpLwvrOHS30YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9UEx0Rx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9UEx0Rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322971F00A3D;
	Fri,  4 Sep 2026 06:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501996;
	bh=LUrUq99SHCt+CEKIW0+4S8uzfh0PyiatzA02iUB6VPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9UEx0RxqX3fOOL1B1vqcXyFz5V83PBggNEqB04gNizeiYRfbmQwL7u9wIa1sIh4r
	 MA9vFTp6l0bx/+wTM7CrzpFHqsDeX0zv1RdF/iY7oxd6fJC1oUgvU+/VGeP9u+bo5U
	 8TD11C4P9xZIxhkqf9xTfNRx9aqalxZ2QHXY3gl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eaa106d192c9daf37f95@syzkaller.appspotmail.com,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 6.12 054/403] usb: gadget: midi2: remove default configfs groups on teardown
Date: Fri,  4 Sep 2026 06:57:37 +0200
Message-ID: <20260904045736.055642086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -2476,6 +2476,7 @@ static void f_midi2_ep_opts_release(stru
 {
 	struct f_midi2_ep_opts *opts = to_f_midi2_ep_opts(item);
 
+	configfs_remove_default_groups(&opts->group);
 	kfree(opts->info.ep_name);
 	kfree(opts->info.product_id);
 	kfree(opts);
@@ -2642,6 +2643,7 @@ static void f_midi2_free_inst(struct usb
 
 	opts = container_of(f, struct f_midi2_opts, func_inst);
 
+	configfs_remove_default_groups(&opts->func_inst.group);
 	kfree(opts->info.iface_name);
 	kfree(opts);
 }


