Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620460;
	b=tnW3alUdSj6fzlSgIyA0+RFlbAzDEd4pikDl2jH5Zd67Ou9slm6RefiPvwxns8HxttMh
	 kH7d4aTYKxXo2QTUCRVheXfq3oM4pNBBGIlYsJvtFUz0zCB1g14cF5pI5RbGxwsdCMipJ
	 rx7chp2+MFyZ8naOdg6YpPljMzz+H8mYHhpTYQcqdYhEJptGaHuLXo5u5t+64ft0LVeTR
	 p7Q+BA5IMpinXbNzef0dCbFT6R6saZB+8X5OCJwvjk7EA4vJpHPECRRS+zyPxdQnObkEm
	 L8FVaeodt2hy2yIA7n12/d9jjO7vQizyzWsXqVqWGQ59PqxEj/8kiroqnO2njNVH3og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h4O6Hz+UvCVxfBmtT4BoJo2hQBlLg8XbQ8S27PJtRvI=;
	b=h2VXRVtHiaOIHm83GbsZiow8IFW19qqqsJwUzaqAdn9LOu3TP3qR+5YGLbywj9zafiMH
	 pdqTKbty4LJgvwzAPYTcKK8UVYiZVmujZ+Zor+rLL8K96vHyS31f88dRG4OVZFDq1uiIO
	 S4oUONmlhTEdXCGLM5I6Zrr3I5Tk5/8uULK56VgHM/s7XaZ54iR56Ix/X27mGC/dWTzRN
	 dGHMbyaH8maBDipggGxCHY8tUfmrkQuLxidHQS8wcJt+pdFecbY7uwlBZ7+m+D21tdVGT
	 FrFvPkZedYNKeUhqSSq/yeV2YYXZEIO5XfNlqLFAPjW6gwsW0SvUsW78pKJWppHTiDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0RJQIeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB4D606A323;
	Wed, 25 Nov 2026 15:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0RJQIeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9773F1F000C0;
	Wed, 25 Nov 2026 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620460;
	bh=h4O6Hz+UvCVxfBmtT4BoJo2hQBlLg8XbQ8S27PJtRvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0RJQIeMJ1jYfHfnWr15RLavLlpUoT+mvBkj7sWNOiUKIo8/FmdiTlMJZk/cOS9Ek
	 +BYDezz9CDdg8U0k+iBwFFq5ICKQfS66wcdR7eTichScB1U/6GEosIPbz7hkwF5CfZ
	 ++U2gJU4Vznp9sRM1YDj6N8OubnxPXkBN5heplsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0888/1005] comedi: fix endless recursion in comedi_event()
Date: Wed, 25 Nov 2026 15:37:06 +0100
Message-ID: <20261125143842.499838996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit d432e5d3dbd98589029905e898bfe7005be69b68 upstream.

When comedi_event() was split into a wrapper which takes a reference on
the running command and _comedi_event(), which does the work, the wrapper
ended up calling itself:

	if (comedi_get_is_subdevice_running(s)) {
		comedi_event(dev, s);
		comedi_put_is_subdevice_running(s);
	}

As long as the command is running every level takes another reference
and recurses, until the stack is used up.

Most drivers go through comedi_handle_events(), which calls
_comedi_event(). usbdux, usbduxfast and usbduxsigma cannot use that and
call comedi_event() from their URB completion handlers, i.e. for every
completed URB of a running acquisition.

Fixes: 51495254fda4 ("comedi: Use reference count for asynchronous command functions")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-comedi-v1-1-1899771ee15b@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -3494,7 +3494,7 @@ void _comedi_event(struct comedi_device
 void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	if (comedi_get_is_subdevice_running(s)) {
-		comedi_event(dev, s);
+		_comedi_event(dev, s);
 		comedi_put_is_subdevice_running(s);
 	}
 }


