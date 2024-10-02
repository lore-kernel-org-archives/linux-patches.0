Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1572A1D0799;
	Wed,  2 Oct 2024 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880466; cv=none; b=NZeYWXq1M6h7FUFHgk9BYPDcF9O6myTJsoZiG+CrrR5hbXEoqok6qv9hEHLMn7uQyIIWfe+ZR8TzhymD0BY8CTx/77FhYtv+6eddE2lTCLx06XZE9egDtckBoJYHL/y9t4sjeQUiwYTDWgWrJApOvyDQPRvhuiIsy3e62HcAqJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880466; c=relaxed/simple;
	bh=p9ERjc5xT2JWmcwFExmXHuh1fD+kRle6aonBzSKfL0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFRf84klDrW8oz1NKdfkZyWhxSm2i89df63KJdGmfeNSe9CTn8VA+azOeg05Qk7UCoh8s/LhUjmyLPahJwexmK1Fla8WHrkLKvG+lt7MRmLt3HaCMvwZXYAZa6KhYMh4VS0oeVB3+2LAVt4XtZLnoJlizpi3OI75t8p+Pj+uSuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlMKLOGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlMKLOGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F27BC4CEC2;
	Wed,  2 Oct 2024 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880466;
	bh=p9ERjc5xT2JWmcwFExmXHuh1fD+kRle6aonBzSKfL0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlMKLOGoPZ2tncc4gXnceDmsFHeBnP/QpIlJYMOKE71HMDqAB87sJvc6MpDwwHVp8
	 NRdGn/3yM8ZPtkusKUGPQmYEWg9zNoJDO1Nd4DEzYsinIpGlVaetUmxMQz4l88+6yP
	 6W3mhI/9uysRiSOOwveIZ7nPBNCkseJWt5gyd9VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 436/538] USB: class: CDC-ACM: fix race between get_serial and set_serial
Date: Wed,  2 Oct 2024 15:01:15 +0200
Message-ID: <20241002125809.650230187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit b41c1fa155ba56d125885b0191aabaf3c508d0a3 upstream.

TIOCGSERIAL is an ioctl. Thus it must be atomic. It returns
two values. Racing with set_serial it can return an inconsistent
result. The mutex must be taken.

In terms of logic the bug is as old as the driver. In terms of
code it goes back to the conversion to the get_serial and
set_serial methods.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Fixes: 99f75a1fcd865 ("cdc-acm: switch to ->[sg]et_serial()")
Link: https://lore.kernel.org/r/20240912141916.1044393-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -962,10 +962,12 @@ static int get_serial_info(struct tty_st
 	struct acm *acm = tty->driver_data;
 
 	ss->line = acm->minor;
+	mutex_lock(&acm->port.mutex);
 	ss->close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
 	ss->closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
 				jiffies_to_msecs(acm->port.closing_wait) / 10;
+	mutex_unlock(&acm->port.mutex);
 	return 0;
 }
 


