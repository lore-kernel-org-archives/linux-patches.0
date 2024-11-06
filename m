Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5E61DFDB3;
	Wed,  6 Nov 2024 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898162; cv=none; b=N6T/Lbl7ccWFc8+UYAPcoh3E6pAy7T2srDf5s2xV3zLVgfLmKAhiYiNOqyOi+m/npnFiZPT5/Y14hF07wBBlI4vlDxE5HHrK3O0UIZ2Dut4u71S1J/C+a2xezWzfdfky8WGvtdGWcWLJjgBED9Lc9IUY0nS2FWdER/yW0gtP86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898162; c=relaxed/simple;
	bh=gLOt81j0x1ivTUq4CWG3TWVBll0Iu/lm9GpqlMPAMNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBRKKZse2/6ZcNEr84RMfKHE/OcAmcYKK34Oq2IRmb+lhjPgpVcLindHXVc9rXwuEWY1gKUXGZFoppIZ/FDsD7HCDarpuMlrVYOaKWmRoYv17WM8Z18FiQp8b/UEBV06FBV1KXwtW0MObrWzhN/r2kPz7mLUEMz9lDSvKDAyoIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a09ZG6mN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a09ZG6mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7C5C4CECD;
	Wed,  6 Nov 2024 13:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898162;
	bh=gLOt81j0x1ivTUq4CWG3TWVBll0Iu/lm9GpqlMPAMNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a09ZG6mNdhYV9JZDqArdUtxd9bMGa8Pp1xxlObyFOHatoFZl4kBeBBw412OZXmD4Q
	 3LJUUfZjy8Xf5XbucE3vi23xOIIu0t4LELwsGx5lzn4COJhK3yQvlpc7778fUGYfzy
	 NXjNfN1Yfm2ZrQjuz5mbWzIF/wQoVhHcNbQuc7xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 144/462] USB: class: CDC-ACM: fix race between get_serial and set_serial
Date: Wed,  6 Nov 2024 13:00:37 +0100
Message-ID: <20241106120335.067934586@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -938,10 +938,12 @@ static int get_serial_info(struct tty_st
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
 


