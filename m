Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00712264A3;
	Fri,  4 Sep 2026 05:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500503; cv=none; b=I0phdSz0QKv88Vto/33gibRkAQ7czuam7RhK18bpo+K6WohMN7YCLfZ6k+0abXrYeIknn1vNNs15rUK0kjIn2f1jhoYuMQARb+4dhm0bQaBw3GktZ623q2IP3XKNjbfIBycHTJbGYSxSazxcQonilyQ86wimKdQ6UkJybQFVY3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500503; c=relaxed/simple;
	bh=LaMCHyfHkfT0Bi24OexJFxhgvpSdkMVbq6AGBmkwRNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eP6gfLPLZqluNa3Cbqt+N7zvfsMAO0qpyjEBCgxRHsXURh6TEV76IIMVx4jPuITpVIdTKh0rMnywcLxKZr3PqNCvzmdIhuqDGTBIAYh3OF2XJOk3QO3QJguJVNCCvm/vK4db5xY+XfIDITo0YxkmcSj7EMhxrbEEtD4tVm/7z+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9JFWABj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9JFWABj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8ED1F00A3D;
	Fri,  4 Sep 2026 05:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500501;
	bh=hk34o49HNlQvQSoItalMUHI1TB0lWw3PBp0eiXC9stE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9JFWABjaUXrmNfmDIovsMhhkgfA2hwozk7XNjyCAOU2WP/Yb4PZX2Rbsaz+/OMW7
	 Vw3Otw3xTGkKg97r3CMtPRexFlJjxWbTIkc9NF8b0/XD7IBr+EFrrcQ7ZNHlf88TFK
	 HyPg2n5cfHhZX+Ir5r87ksNwvcaw+SkqPP9iEYfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eaa106d192c9daf37f95@syzkaller.appspotmail.com,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 6.18 080/552] usb: gadget: midi2: remove default configfs groups on teardown
Date: Fri,  4 Sep 2026 06:53:57 +0200
Message-ID: <20260904045749.679532806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2474,6 +2474,7 @@ static void f_midi2_ep_opts_release(stru
 {
 	struct f_midi2_ep_opts *opts = to_f_midi2_ep_opts(item);
 
+	configfs_remove_default_groups(&opts->group);
 	kfree(opts->info.ep_name);
 	kfree(opts->info.product_id);
 	kfree(opts);
@@ -2640,6 +2641,7 @@ static void f_midi2_free_inst(struct usb
 
 	opts = container_of(f, struct f_midi2_opts, func_inst);
 
+	configfs_remove_default_groups(&opts->func_inst.group);
 	kfree(opts->info.iface_name);
 	kfree(opts);
 }


