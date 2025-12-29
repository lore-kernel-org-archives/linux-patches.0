Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500563191AC;
	Mon, 29 Dec 2025 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025687; cv=none; b=YWtwlV2u1IILQGYeF6llzkFztRSdy5ErgX008ks7vqYLq6jBlV6TdL3pN6RrEjm2evflsz2pNQEl7gnlKX3uXZKOd+hu26mElrvNiz12rP977N4EofBAQ0/HBfsSfhjLyH0AyRtx4zZqC2MX+YbQMJqBkwef/Q+VhCHcIBnYxL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025687; c=relaxed/simple;
	bh=UXgVkuGW93uykhIjngBvG8xl5qh2V0mnBb8DXFs6jPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h67RJGeMDFhXteh69GIolrPQ/VP7G66AHkYageAecYkg/eba6ZHjr5Q0QXPoQWB96w5m+DTMTaz6EqcDDw/EnJMmyIoLYlxGtzjrWqh4wZClkbkXRU5FsDH/QjDYz8GOMKSmgJIUy1ajYtQ4SKuELqJBG95DXBT+TS68Uucd1kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfsXT9Mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfsXT9Mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11D6C4CEF7;
	Mon, 29 Dec 2025 16:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025687;
	bh=UXgVkuGW93uykhIjngBvG8xl5qh2V0mnBb8DXFs6jPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfsXT9MmlopxRk+1mqAtAlQC9tUr6qyZqE1zB/z1wtbtrC6kFT07yqJlfyNLaZkBu
	 6C+s8MX0nutS0TMwYNiaZGBZlEtsi2DcRgl8M+nKUgh/uM8lo5y8i+bMOUZoPVB0mb
	 flx9t8VgU8xxBNM+jhUOR/FoAAeS8z5uBko0UjN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Michael Walle <mwalle@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.18 301/430] serial: core: Fix serial device initialization
Date: Mon, 29 Dec 2025 17:11:43 +0100
Message-ID: <20251229160735.413665140@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit f54151148b969fb4b62bec8093d255306d20df30 upstream.

During restoring sysfs fwnode information the information of_node_reused
was dropped. This was previously set by device_set_of_node_from_dev().
Add it back manually

Fixes: 24ec03cc5512 ("serial: core: Restore sysfs fwnode information")
Cc: stable <stable@kernel.org>
Suggested-by: Cosmin Tanislav <demonsingur@gmail.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Tested-by: Michael Walle <mwalle@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Cosmin Tanislav <demonsingur@gmail.com>
Link: https://patch.msgid.link/20251219152813.1893982-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_base_bus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/serial_base_bus.c
+++ b/drivers/tty/serial/serial_base_bus.c
@@ -74,6 +74,7 @@ static int serial_base_device_init(struc
 	dev->parent = parent_dev;
 	dev->bus = &serial_base_bus_type;
 	dev->release = release;
+	dev->of_node_reused = true;
 
 	device_set_node(dev, fwnode_handle_get(dev_fwnode(parent_dev)));
 


