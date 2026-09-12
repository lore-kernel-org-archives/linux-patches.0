Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B6A376BCD;
	Sat, 12 Sep 2026 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219733; cv=none; b=MglD3gUzeN6BNgrQeZ9nEUe8pzEZi104WH6IKXugX5F2ZY5Is59aDt4bIquoNOEZtY9DkxAHzZ3ouU7cE1RWX0D+58IVV/DtI0GXdA47hfnYFp43dbvhEe+c0s9MuwWzCqhXfnJWTE2mCnNf8mfDnAqc9GhZfMi+dxAJlC6KUu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219733; c=relaxed/simple;
	bh=LV2xsdchtS8Yr9xOG+OWh6g3GyVvfErP0WLKx/NddwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHafHdHHgVfkkyddDWgUL/psx20vaMiYdmJ27hh3lLjQ4R6nHVudFCO/ZF5RSREXw8liez3iqQWnRrpNl+hf8+eJj5I25zAY1rR5icfktxZOVm5w0nMnWHK0tOCjT2ikMq/WbDzMlcHkG5LaLUy8CNcqavRqpa8O3zZ+TiyyujM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaoXA2FO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaoXA2FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E531F000FF;
	Sat, 12 Sep 2026 13:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219732;
	bh=xrajmEC3XPPkQLShBhlXrycS+BUZdcPXI8Xon0m4ALU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaoXA2FO8345TmFLfzM6PprRMMAtyXTPqp1ewUf8Vu2XZ1NCP9wiEBQPjKssEQ7wG
	 Qz0iqV1PuhRkl/LOoBIl++mzCfIZy8k/OmzK/VJOoyF9CxZxBo9Tl0vYzG1X0Sl2H8
	 id1cXME599xlHckfueizXO7u4D359j1aOtEGsJoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eaa106d192c9daf37f95@syzkaller.appspotmail.com,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 6.6 0034/1424] usb: gadget: midi2: remove default configfs groups on teardown
Date: Sat, 12 Sep 2026 08:41:06 +0200
Message-ID: <20260912065608.069478062@linuxfoundation.org>
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


