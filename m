Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC168446C9;
	Tue, 20 Feb 2024 21:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465053; cv=none; b=p5/8vuirr7vM1GFQjnqgvTTlKDK4DKeZjra7VwhCtuhQ8w7COBRJhbL38wmUKKCBc27JgW1g7rEnXejKt91Ne/3uS2iFDqce/W1jyo5DR4MlxbFglRULdsf+KwrKiu6WPr50F05Epzlrh3LnpD4crtIfIsNVa/XqyV+FTRJPn7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465053; c=relaxed/simple;
	bh=s3OjQNZaxooQAf3uAajXY8/xdUNb7MHgK3CjzSc0Ahc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyMO14+VzCgb6lnJH6jHBKEj0MhEaT99ssQPU6e1djEoUvuvLe9w3MKuIIthDGWXtkZgGlCBlszQ/Z+nYk+T+AFALzxFILmGFk8hJWHZjoA1qFrJmm7oQVkKUpa76kxx8LOiLv6cuPYJ22vjD0avCT+cmUfnW50NJycaHAT8oms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R47n4Knk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R47n4Knk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B502C433F1;
	Tue, 20 Feb 2024 21:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465053;
	bh=s3OjQNZaxooQAf3uAajXY8/xdUNb7MHgK3CjzSc0Ahc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R47n4Knkt7rm7XjAQOF0dbGSRxTihehLcbdySWAyVCSqS2oZLkCRCHpR85KzBSh60
	 NdhXepKAGp3t0BslboKhQaIUwxlfUEEk2QmNg/MVJBZMTkYhMruTSQ3hZpBqVQs0Ib
	 V19d8KmlhnuC9tLd4mDauY0ENGdVByfVPaJGBYlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <2045gemini@gmail.com>
Subject: [PATCH 6.7 220/309] serial: core: Fix atomicity violation in uart_tiocmget
Date: Tue, 20 Feb 2024 21:56:19 +0100
Message-ID: <20240220205640.043786638@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <2045gemini@gmail.com>

commit 30926783a46841c2d1bbf3f74067ba85d304fd0d upstream.

In uart_tiocmget():
    result = uport->mctrl;
    uart_port_lock_irq(uport);
    result |= uport->ops->get_mctrl(uport);
    uart_port_unlock_irq(uport);
    ...
    return result;

In uart_update_mctrl():
    uart_port_lock_irqsave(port, &flags);
    ...
    port->mctrl = (old & ~clear) | set;
    ...
    port->ops->set_mctrl(port, port->mctrl);
    ...
    uart_port_unlock_irqrestore(port, flags);

An atomicity violation is identified due to the concurrent execution of
uart_tiocmget() and uart_update_mctrl(). After assigning
result = uport->mctrl, the mctrl value may change in uart_update_mctrl(),
leading to a mismatch between the value returned by
uport->ops->get_mctrl(uport) and the mctrl value previously read.
This can result in uart_tiocmget() returning an incorrect value.

This possible bug is found by an experimental static analysis tool
developed by our team, BassCheck[1]. This tool analyzes the locking APIs
to extract function pairs that can be concurrently executed, and then
analyzes the instructions in the paired functions to identify possible
concurrency bugs including data races and atomicity violations. The above
possible bug is reported when our tool analyzes the source code of
Linux 5.17.

To address this issue, it is suggested to move the line
result = uport->mctrl inside the uart_port_lock block to ensure atomicity
and prevent the mctrl value from being altered during the execution of
uart_tiocmget(). With this patch applied, our tool no longer reports the
bug, with the kernel configuration allyesconfig for x86_64. Due to the
absence of the requisite hardware, we are unable to conduct runtime
testing of the patch. Therefore, our verification is solely based on code
logic analysis.

[1] https://sites.google.com/view/basscheck/

Fixes: c5f4644e6c8b ("[PATCH] Serial: Adjust serial locking")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <2045gemini@gmail.com>
Link: https://lore.kernel.org/r/20240112113624.17048-1-2045gemini@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1085,8 +1085,8 @@ static int uart_tiocmget(struct tty_stru
 		goto out;
 
 	if (!tty_io_error(tty)) {
-		result = uport->mctrl;
 		uart_port_lock_irq(uport);
+		result = uport->mctrl;
 		result |= uport->ops->get_mctrl(uport);
 		uart_port_unlock_irq(uport);
 	}


