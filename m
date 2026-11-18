Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057760;
	b=OdUHx8zscClCgfMo876tTbF/Evo+xYyFrwex07vASiQIJGw3jH82nNyMHEHCffuocrDf
	 CM1VyohhZ1GnkWePIUtYH4H6rAsQLi3rWMQDy4QGAdPqPPZscZLWJErPXcQQVh+ltuVrD
	 0llzW2rD8F7wLMGTcd/fjrPYneznlsXEOE+bjKtlKCikpdVRzCU8Q9uqbYy+wyJbkznJZ
	 Q8r+kauqjwBRrIkkW121eU69cT5eb/1jBfJ3D9vPbaTm2Q8xreOicqvUGQJC6BgqN/3ip
	 G2enNaaoiyO6O/AxXLJxjtiX4+gD3TWKe+njh1le0F9BNrQAvm5cdScWK0nOS6rMb+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PyA0eTi/YbEdNPoiy1JTuIwYuNZd9Wu+KJPDbOCfAxQ=;
	b=e2/nAb7vrHsF4GmY5cOGSuqQQ6gCNDrRpKebTtzeb7SuCOKV1+HWHsVefWMyNJT3xGlu
	 O8pnRBV0eFbDBDPgOslp3ZwcbKbdtWFyn42+Us9Pnby0joEVAVwPQ2iMhMwULuE66dKIn
	 DlebX/KC4ZSUnIuNJApnI7NPM89FOgS/a5m6+6k9N+fFZSogXl5xc/wxTe2i/+hcQ6xzY
	 qckKMD5ApyjCwaRCM2mo3HSDa/PlJ5dzC9FPu9vKoCRbiRaQEzxW8h/UtiDXeleqc4W7E
	 ZWsyDFnq5+mSLfBLTmvgpd9/IjClAFcfY7jyetotboVzARBbrCnctoqFuJaqMkGimSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZBim9DM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9933606A31C;
	Thu, 19 Nov 2026 03:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZBim9DM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F31F000C4;
	Thu, 19 Nov 2026 03:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057760;
	bh=PyA0eTi/YbEdNPoiy1JTuIwYuNZd9Wu+KJPDbOCfAxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZBim9DMOeY4ltLYagW4tqsaJwDtb79WnNJaj/HnrC029eiBlyZ2JpaHDxThAHfqC
	 ph2LrdGfSZr4OhZSpfpYOXELcq/Ciw2taSR6B9N/33cTjNUUxIQ6BoqZmY4GZHbNhU
	 MMPROkcuOIH3Tucr6LcJfgy+rb01S50iAYYK4ivM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 5.10 0244/1848] media: imon: fix use-after-free in display_close via dev_dbg
Date: Wed, 18 Nov 2026 15:38:02 +0100
Message-ID: <20261118145922.111583214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 118a3590a4080c71c565265b05b3f92e814d7647 upstream.

ictx->dev is a raw pointer to the usb_interface's embedded device.
On disconnect, usb_disconnect() can drop the last reference on the
interface and free it while a userspace fd for /dev/lcd0 is still
open. When that fd is later closed, display_close() dereferences
the now-freed ictx->dev via dev_dbg(), causing a use-after-free.

Remove the dev_dbg() calls that dereference ictx->dev in
display_close() and free_imon_context(), rather than taking a
reference on the device.

Fixes: 21677cfc562a ("V4L/DVB: ir-core: add imon driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bfac891bdd42eb708fc
Link: https://lore.kernel.org/all/20260918054851.26083-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260928121230.35359-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/imon.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -497,16 +497,12 @@ MODULE_PARM_DESC(pad_thresh, "Threshold
 
 static void free_imon_context(struct imon_context *ictx)
 {
-	struct device *dev = ictx->dev;
-
 	usb_free_urb(ictx->tx_urb);
 	WARN_ON(ictx->dev_present_intf0);
 	usb_free_urb(ictx->rx_urb_intf0);
 	WARN_ON(ictx->dev_present_intf1);
 	usb_free_urb(ictx->rx_urb_intf1);
 	kfree_rcu(ictx, rcu);
-
-	dev_dbg(dev, "%s: iMON context freed\n", __func__);
 }
 
 /*
@@ -582,7 +578,6 @@ static int display_close(struct inode *i
 		retval = -EIO;
 	} else {
 		ictx->display_isopen = false;
-		dev_dbg(ictx->dev, "display port closed\n");
 	}
 
 	mutex_unlock(&ictx->lock);


