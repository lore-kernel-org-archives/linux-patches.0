Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2930392C27;
	Sat, 17 Oct 2026 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255969; cv=none; b=o/j7PZ3EdW5c8La6SlQ3tCBB6ny/BJWrb2Yz3q7lG0xKOD//+ZkAAuFt4L8nwdgjWGE5reEEyY7kc87Gnvlpe6JG8zubNM0h5sfGt9Z3X70761IOEdoYcKA6ChE5KY9BbQ3JU9YCdmPziZV7sfgBdevvExJON1IHIT0vWt3/ISc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255969; c=relaxed/simple;
	bh=2Yr7TX6rtHRCko5iLmVC63RLRczDHp1kux4CF2+edYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OjAB1eHABivlqOgb4DkLZKWvYEzycBeNAz8LNZA9ylGaQz6vn+fLiPP58PSXnwNluoViIKx6w+AOlRMQWT8KIwk8kPbviLgU5vSdBdssj5AEU1C0rNZnH9fAeWnGFVKC0zBYT0oVbGf5blCRfIdwIEfeNC8PPyk/OCz+T5BkDDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3cCAStq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3cCAStq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A621F000C4;
	Sat, 17 Oct 2026 16:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255968;
	bh=sxi2e6aq8gymzohTFQhiYesDx41yovS6XRTTLxdZ2Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3cCAStqk66+UzIUhh0E2RJKH4bwsr+KiDeqEAMcz+9k1ppW6nrvFIONv/ke7EWX1
	 taVbaE+QgUbRo+eOdHVF4W6lavHIqbIprnDkyA7tjHDMsWWURvuTGES/ReQeKuRCpI
	 1hGL5p4lMMg2GZnMAxIeeZw9grymykJl1Oshu4L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0082/1674] usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()
Date: Sat, 17 Oct 2026 17:39:14 +0200
Message-ID: <20261017160433.236545431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffin Philip <jeffinphilip14@gmail.com>

[ Upstream commit 2c0f5ca48674a5b5f9fa4a9c3325aa48053af0bc ]

Previously fsg_num_buffers_validate() was removed as it was not
necessary due to Kconfig setting the limits for n from 2 to 256 with
default as 2. However, setting the page content in such a way that
kstrtou8() reflects n value as either 0 or 1 bypasses these
restrictions leading to a null pointer dereference if n is 0. Fix
this by adding a check for n < 2 and returning -EINVAL if n is
either 0 or 1 consistent with Kconfig logic.

Reported-by: syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=791be35f1fbcc85d06d7
Fixes: fe5a6c48fd95 ("usb: gadget: storage: get rid of fsg_num_buffers_validate()")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260818035904.10324-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adjusted context to retain the branch’s existing kcalloc() call instead of kzalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 01c35deaefe1b..4a7de2ba91cb2 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2748,6 +2748,9 @@ int fsg_common_set_num_buffers(struct fsg_common *common, unsigned int n)
 	struct fsg_buffhd *bh, *buffhds;
 	int i;
 
+	if (n < 2)
+		return -EINVAL;
+
 	buffhds = kcalloc(n, sizeof(*buffhds), GFP_KERNEL);
 	if (!buffhds)
 		return -ENOMEM;
-- 
2.53.0



