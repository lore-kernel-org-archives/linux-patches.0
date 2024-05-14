Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E1E57CBC;
	Tue, 14 May 2024 11:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686929; cv=none; b=qg5opiji5eIIJsjzLiLkEiQiK3Uj6fSrBp180AJIR1ZdG5nR9IoFvkHcQ7ksJhaIeXbuJCQePlRWiWm1fHFz7Krv+hlODORB+LEgka2DiWRyaaAlrdrml9cF9PiL+zTwFIQgNcSS2/6AKrd3OHVeZuxWYwzSU+VDxVU3oS+6o2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686929; c=relaxed/simple;
	bh=TE+61QEM7dOjg3NwArmrbgmQIeZ/xjB7qGdt1f5Gyg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSIkH1wO/M+cHoX2KFE0TcjAOIKefdcfn/yep69WUZMitKpRMJhhL2ybT+1Ikw8j4imOFbtUH4/JjlU8vThK9DyfyBkwIQ1Mu/+FgWgQU/t2lIxgYJmo56Zedc2f/MTEhAQY7TycQMsHNS5vm+pykes22x6OcL1UQlNHD7y1PVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiOP5asm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiOP5asm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF76BC2BD10;
	Tue, 14 May 2024 11:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686929;
	bh=TE+61QEM7dOjg3NwArmrbgmQIeZ/xjB7qGdt1f5Gyg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiOP5asm0IAiNDizP5QvwBD0VVali3a/C5Ml09j7wITu2aQHJr/2t4N45jxDcdbka
	 6UXBizmMtSsby4VMWkN0DKZP/juWoqZ8f2z6uOs5qw5OPgShqKLMNgArYOK77QZW7/
	 hmf55/PxJuOwzh5ymcFx/2exa1SZ2ck/UmFPd8+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Chris Wulff <chris.wulff@biamp.com>
Subject: [PATCH 4.19 58/63] usb: gadget: f_fs: Fix a race condition when processing setup packets.
Date: Tue, 14 May 2024 12:20:19 +0200
Message-ID: <20240514100950.200509560@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wulff <Chris.Wulff@biamp.com>

commit 0aea736ddb877b93f6d2dd8cf439840d6b4970a9 upstream.

If the USB driver passes a pointer into the TRB buffer for creq, this
buffer can be overwritten with the status response as soon as the event
is queued. This can make the final check return USB_GADGET_DELAYED_STATUS
when it shouldn't. Instead use the stored wLength.

Fixes: 4d644abf2569 ("usb: gadget: f_fs: Only return delayed status when len is 0")
Cc: stable <stable@kernel.org>
Signed-off-by: Chris Wulff <chris.wulff@biamp.com>
Link: https://lore.kernel.org/r/CO1PR17MB5419BD664264A558B2395E28E1112@CO1PR17MB5419.namprd17.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3304,7 +3304,7 @@ static int ffs_func_setup(struct usb_fun
 	__ffs_event_add(ffs, FUNCTIONFS_SETUP);
 	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
 
-	return creq->wLength == 0 ? USB_GADGET_DELAYED_STATUS : 0;
+	return ffs->ev.setup.wLength == 0 ? USB_GADGET_DELAYED_STATUS : 0;
 }
 
 static bool ffs_func_req_match(struct usb_function *f,


