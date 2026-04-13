Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A692223DCE;
	Mon, 13 Apr 2026 16:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098823; cv=none; b=H6m6/mi1opArjm7xPdz8kxeNIMhRdppcbzUY0utUr/EQAUnh7WLxpU5T/Om8VkNEXPNRSLxfYyQLTW5h9Pr+Gua097e3kpVfKMnFGpC7ui5/6tK4ZM4vjX+dFgvhk9hSg7Gd7etX2suMZX4pp/I73CFHlHj868x73M4nrSdyxzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098823; c=relaxed/simple;
	bh=U66awp2D1lRIrjHcrG5xgXWqb+abkrF9bY3BmpX0kqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5dLnjwUAenqo3UU8g4UjaQ2kGkGSQr9jdec55OLuUIqQh01r5QJSbh9mCXhlj3YQhfhZVlOacnrHoqGaUFC+zyTAtcdn7iaKlIyj/bKOv+GchBNYG8Wjn0sThXi7SqbTuPF8lJqR4k82J6KvJ9dPC8fj4qbu01aAZAEIlESLS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvfGUVAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvfGUVAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7ACC2BCAF;
	Mon, 13 Apr 2026 16:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098822;
	bh=U66awp2D1lRIrjHcrG5xgXWqb+abkrF9bY3BmpX0kqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvfGUVAUioKV6azTgjNaSvyvYO69sG2Bhmn6BhVJxfKFJFCubrHEB+zida81qj3Jk
	 jIVXd0qnWGh08l0gE/sfctf6MDuV1ay7QubGuc1kpxVEClfvREn3Z61+yWxBkTceMq
	 N5zHZda8gUBtiwp52d/p+BkWW0b4RKCQzWUl+1/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	Gui-Dong Han <hanguidong02@gmail.com>
Subject: [PATCH 5.10 101/491] usb: class: cdc-wdm: fix reordering issue in read code path
Date: Mon, 13 Apr 2026 17:55:46 +0200
Message-ID: <20260413155822.826495590@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 8df672bfe3ec2268c2636584202755898e547173 upstream.

Quoting the bug report:

Due to compiler optimization or CPU out-of-order execution, the
desc->length update can be reordered before the memmove. If this
happens, wdm_read() can see the new length and call copy_to_user() on
uninitialized memory. This also violates LKMM data race rules [1].

Fix it by using WRITE_ONCE and memory barriers.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Closes: https://lore.kernel.org/linux-usb/CALbr=LbrUZn_cfp7CfR-7Z5wDTHF96qeuM=3fO2m-q4cDrnC4A@mail.gmail.com/
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260304130116.1721682-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -212,7 +212,8 @@ static void wdm_in_callback(struct urb *
 		/* we may already be in overflow */
 		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
 			memmove(desc->ubuf + desc->length, desc->inbuf, length);
-			desc->length += length;
+			smp_wmb(); /* against wdm_read() */
+			WRITE_ONCE(desc->length, desc->length + length);
 		}
 	}
 skip_error:
@@ -519,6 +520,7 @@ static ssize_t wdm_read
 		return -ERESTARTSYS;
 
 	cntr = READ_ONCE(desc->length);
+	smp_rmb(); /* against wdm_in_callback() */
 	if (cntr == 0) {
 		desc->read = 0;
 retry:


