Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B281E7C00;
	Tue, 15 Oct 2024 11:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992341; cv=none; b=P2XILp/UM6sptwekonD09URgo0v4w70+7gUpgv5ot+KMkb+HmKYzFD0d7jsjpLg94Myni63ImiVxzkaGAaZ29ES5P7yAk4/oDlIfSSlQD+Q7+eT9PAGVCKv9lFMwZAxCkiVP5aWGPN9XMzg5tSiYa3v/NPmuOaaFoTeTezu04D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992341; c=relaxed/simple;
	bh=HeDl1+JPcpmz1wYXxJJbHZPkErgid0rlYl/Agj5Q4UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq2quBHA80Zc1mzcgb4zyocU1oFngyt4DKYaCsNeA0RIz1VV5OPLzMzW8IYoDv6bp/PUvZVK5+YDoxomkHbk4bRE+Cpmsdb1WvpbpObOa8GFVbXn0WI5u4gpXc5niKarDXaGh0Km62YPus9Aqz8X70jMxs44jvpPZ0SDGYv2mN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXZJf1Cp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXZJf1Cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82196C4CEC6;
	Tue, 15 Oct 2024 11:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992341;
	bh=HeDl1+JPcpmz1wYXxJJbHZPkErgid0rlYl/Agj5Q4UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXZJf1CpkeydMJnHS+/wFagF1sfdlX0FfjagPInE4INFgzlvbHJ8APDsQWTUJcLbE
	 fLrIB+IzSXIl2BOK8/c0pNy4zKo6fgRb2tAZ2xA7TQ+MKwyMz6pmvOXDMxMkuu87Ci
	 +liJnp8jhZKrj3K5bPM09uX6hpX6U7unVwMrPB/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	stable <stable@kernel.org>,
	syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Subject: [PATCH 5.15 089/691] USB: usbtmc: prevent kernel-usb-infoleak
Date: Tue, 15 Oct 2024 13:20:37 +0200
Message-ID: <20241015112443.897186341@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 625fa77151f00c1bd00d34d60d6f2e710b3f9aad upstream.

The syzbot reported a kernel-usb-infoleak in usbtmc_write,
we need to clear the structure before filling fields.

Fixes: 4ddc645f40e9 ("usb: usbtmc: Add ioctl for vendor specific write")
Reported-and-tested-by: syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9d34f80f841e948c3fdb
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/tencent_9649AA6EC56EDECCA8A7D106C792D1C66B06@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -754,7 +754,7 @@ static struct urb *usbtmc_create_urb(voi
 	if (!urb)
 		return NULL;
 
-	dmabuf = kmalloc(bufsize, GFP_KERNEL);
+	dmabuf = kzalloc(bufsize, GFP_KERNEL);
 	if (!dmabuf) {
 		usb_free_urb(urb);
 		return NULL;


