Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C024A1D07BD;
	Wed,  2 Oct 2024 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878752; cv=none; b=a40Oq0XjYsReF8/p3ofGrGvK+enUPPEvyA5LC2nqleAeMRJ1XsHodcu/GmvyOS5UWWZJSoBvobW6BWdMVUCmxgx3YwG2B1+3TiDDRqSr0Npg3t8yuayYVgEfdYXb51OnJHZm0ribq/O4iQVw9WH2+d5RVYzqbHDQUggQUEL/GgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878752; c=relaxed/simple;
	bh=3s3eqUD0KCoWdoy5KxYzUn+tPej742I/0OhilVgBE0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIxypSIskO5+6TLMLm4KebWDo0YV+kIB5M7Rql0TIhcBMSLWXkmmS45Lj1fJecMF2J52aEcweFr/+BanrolEDoOA90BZp+KeqrYRqFs5yZv9G7AsczQjP25GhNDQAymYJv/a5NsDIPIN71lGCsTIaCLnfagkVeF3NhpvIa/XOfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pYheyM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pYheyM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02221C4CEC2;
	Wed,  2 Oct 2024 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878752;
	bh=3s3eqUD0KCoWdoy5KxYzUn+tPej742I/0OhilVgBE0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pYheyM39OKVHvRxZBIc5w+EIa1mjyhxbflmxIgU5DauZMKhRAuJt8WROYrGWQVNK
	 dHRBVRduofiTxZ16Rd5CDHWBH6ARX4+8F3C6+eUehef33EAlDY+VyBFGYuGEyxjIKq
	 vjOvGmoqkMgEfBapUWd6zdL+n+SLp8ck1+M82bMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.10 521/634] USB: class: CDC-ACM: fix race between get_serial and set_serial
Date: Wed,  2 Oct 2024 15:00:21 +0200
Message-ID: <20241002125831.671961577@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 


