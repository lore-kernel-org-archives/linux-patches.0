Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E73A3559FD;
	Tue,  6 Jan 2026 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721526; cv=none; b=lOiqOJMP3o3m+XTx4MaZs6a5urjwEdHMFkEv75KRRvLIVwo9vCQmLiVXfn+J5Vu6DOYiXRlxwov6Aq5lE7NruExn0FjIFhw2NpRHyss62/lok0p4DWRfjHK4K2+pJTJt5X9J32Uc2yYmiKsdoXNHoSwgOGvzVDk3WkORKRfGbsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721526; c=relaxed/simple;
	bh=iWVhLUey+Y3NadkMP0BScf4Fj1U6HV9GGKzmam1/N5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJXOKvaKv19G/EkN+3gFtvtr+55ZvcP+XMwgNzrlOPqPtbqjM5IBuhRD9QlOR//V2jjMgkFGwLxqZ0FYybwArn8dUieuL0MdNg6Mor4BnrSv20lXb9VWgkNQYz6XTHhFQq99zj1AkQ9VzZA9GDUDFGS16nix8pJ2VVwLFlVCX5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSojw1KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSojw1KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7089C2BC86;
	Tue,  6 Jan 2026 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721526;
	bh=iWVhLUey+Y3NadkMP0BScf4Fj1U6HV9GGKzmam1/N5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSojw1KSVBmz/c90r+XXZKnC8TEkceMapnnXIQISyWA3Sl0sOop73cLUjAy8DltZk
	 pc5pizYrgDNEdbd2E071+K5VIuSokYmSBw5FMWjQ+lL0EwcNN37gt0JTca8jFpR9+B
	 WvhKN/pBpc228iyU7yZmfIxkSYVHxNZYCMjo+ocM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Michael Walle <mwalle@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.12 530/567] serial: core: Fix serial device initialization
Date: Tue,  6 Jan 2026 18:05:12 +0100
Message-ID: <20260106170511.002582854@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


