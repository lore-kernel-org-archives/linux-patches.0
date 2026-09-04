Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710AD318ED6;
	Fri,  4 Sep 2026 06:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501710; cv=none; b=XMkKefKJRFiV8N8/z6gALDQm1CZP+z/XAUDzI836im8+rIqXrPZbfvKwhb5Z9GpmXqSxnFwuKZ9OpZpO4rzw106fEiwli18pNwoXvBwPlvS0EwtEd6LfRL66vcqyAqSBl00nJcEW8Ox3zhLvqdDRREwJTZ9nXT0UpAOmiBsduDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501710; c=relaxed/simple;
	bh=nrtMzhDW4WcGsqMJNeZKCpFbbfLl06+d2wBDap7l/I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GflE0bhWNMCw0Klrd8bRpVgjRU/cy+wsNVQUb3VM+NnFQ04eb/bfBLK0xrDs0PjKugQCQEbGs4f4y4h5lpU0SxeWg8V8gYXL8md3MOjyDly4edNxXbFe7vZED/u80lQB4B2L4BN+u9vORRMBmRUkMnYrO8O5sgZwlMwGHnF/Nyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t89uFqsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t89uFqsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1EA1F00A3F;
	Fri,  4 Sep 2026 06:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501709;
	bh=EHR4f9DAYo6FflUX5IGz/dXvuVVF1RNMO9KAUBDQthk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t89uFqsXw1eJJhFmHnzc7L5FVPEvtwloG+sgAoWFlrF43celywVc4ypyGwQzMYolW
	 5xcUdIs6W2HFMEteUoSWNOs+ip1CyvhoQyWId2WKaRT+KHvs6bHQulP7UtXDID2U0g
	 F0mIG8AgenpcEJ5JmTTwpuFWHkOaC76fIPzjc654=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 505/552] dm-switch: use WRITE_ONCE() in switch_region_table_write()
Date: Fri,  4 Sep 2026 07:01:02 +0200
Message-ID: <20260904045802.097297661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit c7391ebe33162c7962b313caea4d8e6b0bc2a671 upstream.

switch_region_table_read() accesses the region table with READ_ONCE()
and is called from the lockless switch_map() IO path. However,
switch_region_table_write() stores to the same array with a plain
assignment. This results in an inconsistent access pattern for a
lockless shared variable and may trigger data race reports.

Use WRITE_ONCE() to pair with the existing READ_ONCE() in
switch_region_table_read().

Cc: stable@vger.kernel.org
Fixes: 99eb1908e643 ("dm switch: factor out switch_region_table_read")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -184,7 +184,7 @@ static void switch_region_table_write(st
 	pte = sctx->region_table[region_index];
 	pte &= ~((((region_table_slot_t)1 << sctx->region_table_entry_bits) - 1) << bit);
 	pte |= (region_table_slot_t)value << bit;
-	sctx->region_table[region_index] = pte;
+	WRITE_ONCE(sctx->region_table[region_index], pte);
 }
 
 /*


