Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9478835209D;
	Tue, 26 Aug 2025 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219050; cv=none; b=bWF/BvN1ZVAoxmWmlIDQ7MvmoodZiKnUqZ4wESrWAp2yDG/pTDUg74ReCnQkSv04U0wwWiakpuC0oastrHX4nzQqRyyurL0oC8g2HSpBwe5IC4N5iS/kdKiZUTN2jSiWpARqAt/QV6YqMHo9QfdmtVp1yKXLSxwAqhSFxuBDv7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219050; c=relaxed/simple;
	bh=UUH84azPrOBw8yMfH3P6owR9ZG4Bx/bsv/K5C58aPv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IL8VgN8hFSVgvrWaY3rkndx/OuiB/qOSIAiDqORLqVarEOMHzUcHOXLlSf1G7I8xb2Lr+iE/nL7XqU54Hsd8vuSlpgEF7ODTOKb2YIzPHznnX/AJB4UJnP8jXUgsUIaHC3qEI7bPAUgkHlxf/TDRpT/bBDOCivrtgsC6mUkULlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEdsO7e2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEdsO7e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9D2C4CEF1;
	Tue, 26 Aug 2025 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219050;
	bh=UUH84azPrOBw8yMfH3P6owR9ZG4Bx/bsv/K5C58aPv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEdsO7e2I2VSOMsxc9WkFphw5mBn4vvBuZSXRXqMRE/afrc61/MmxFPeddYLn2H6n
	 VcA7FLsPTILSh4T4Yi2hqLy20sg7vPjDM/mRktQQ/c3zTDybsH9Vv3RkIk0+ZASZLm
	 RI3GRw3k9iB+f2Kw8daynqiqbhPbWjACNgV7V7J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Showrya M N <showrya@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 234/403] scsi: libiscsi: Initialize iscsi_conn->dd_data only if memory is allocated
Date: Tue, 26 Aug 2025 13:09:20 +0200
Message-ID: <20250826110913.292404193@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Showrya M N <showrya@chelsio.com>

[ Upstream commit 3ea3a256ed81f95ab0f3281a0e234b01a9cae605 ]

In case of an ib_fast_reg_mr allocation failure during iSER setup, the
machine hits a panic because iscsi_conn->dd_data is initialized
unconditionally, even when no memory is allocated (dd_size == 0).  This
leads invalid pointer dereference during connection teardown.

Fix by setting iscsi_conn->dd_data only if memory is actually allocated.

Panic trace:
------------
 iser: iser_create_fastreg_desc: Failed to allocate ib_fast_reg_mr err=-12
 iser: iser_alloc_rx_descriptors: failed allocating rx descriptors / data buffers
 BUG: unable to handle page fault for address: fffffffffffffff8
 RIP: 0010:swake_up_locked.part.5+0xa/0x40
 Call Trace:
  complete+0x31/0x40
  iscsi_iser_conn_stop+0x88/0xb0 [ib_iser]
  iscsi_stop_conn+0x66/0xc0 [scsi_transport_iscsi]
  iscsi_if_stop_conn+0x14a/0x150 [scsi_transport_iscsi]
  iscsi_if_rx+0x1135/0x1834 [scsi_transport_iscsi]
  ? netlink_lookup+0x12f/0x1b0
  ? netlink_deliver_tap+0x2c/0x200
  netlink_unicast+0x1ab/0x280
  netlink_sendmsg+0x257/0x4f0
  ? _copy_from_user+0x29/0x60
  sock_sendmsg+0x5f/0x70

Signed-off-by: Showrya M N <showrya@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://lore.kernel.org/r/20250627112329.19763-1-showrya@chelsio.com
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f3cee64c6d12..9b94218ff04c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2893,7 +2893,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	conn = cls_conn->dd_data;
 	memset(conn, 0, sizeof(*conn) + dd_size);
 
-	conn->dd_data = cls_conn->dd_data + sizeof(*conn);
+	if (dd_size)
+		conn->dd_data = cls_conn->dd_data + sizeof(*conn);
 	conn->session = session;
 	conn->cls_conn = cls_conn;
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
-- 
2.39.5



