Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83132459CF;
	Tue, 20 May 2025 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749416; cv=none; b=pqCsVwx4K9/pmYoSSpJADPiCIALRVGm8Q+fsGmyG/a/BlBiVOw7Fc9UxGDBjVY3ieC1vcP5xr9UqENrJbfUUZDlQ4bSYvhCzSYIebNFgWGix5JMVgb9Y2MmdB0W8tMFj7eOSJ3LdI5HgYOzPV+jZhsn0SC7h2bi4gnO5sH+jebM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749416; c=relaxed/simple;
	bh=FAI+kCtSbAEIobj7BSZn6HS2ruQNkJ2/ewzauVXfMyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xrh5e86W3aJZK5f6t1OkqdehFqgwaWyfbGGsbkmMSZeVY3e0PXEtq4X8qOhMIV3QLYuJZrlqC/hqdOdXV26hogFWrRRzex8UR4g2AADRBek7W99SqPbZwolGti5ii2JraanHgHW46fLmxghXn9k3QroXbpEoclUhoKTqAdRSF9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbnlVZhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbnlVZhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA6DC4CEE9;
	Tue, 20 May 2025 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749415;
	bh=FAI+kCtSbAEIobj7BSZn6HS2ruQNkJ2/ewzauVXfMyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbnlVZhiMSFy4Ktp7I/CiRfbBpgikd4qcQLuY8zB1zSTgtKwZ76A+lCv9rDhLtNaf
	 zQMjBjId0rBdlZ8qYIXREF6I8tpzJlk7Jg7SN1Z+GqH7w8Exe/JpUbyEGK6kF8CuWN
	 A1Qm42DjZn7FksXvGWWN4W8OOpFv0jmCOZNSi/aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengtao He <hept.hept.hept@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/97] net/tls: fix kernel panic when alloc_page failed
Date: Tue, 20 May 2025 15:50:03 +0200
Message-ID: <20250520125802.153094609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengtao He <hept.hept.hept@gmail.com>

[ Upstream commit 491deb9b8c4ad12fe51d554a69b8165b9ef9429f ]

We cannot set frag_list to NULL pointer when alloc_page failed.
It will be used in tls_strp_check_queue_ok when the next time
tls_strp_read_sock is called.

This is because we don't reset full_len in tls_strp_flush_anchor_copy()
so the recv path will try to continue handling the partial record
on the next call but we dettached the rcvq from the frag list.
Alternative fix would be to reset full_len.

Unable to handle kernel NULL pointer dereference
at virtual address 0000000000000028
 Call trace:
 tls_strp_check_rcv+0x128/0x27c
 tls_strp_data_ready+0x34/0x44
 tls_data_ready+0x3c/0x1f0
 tcp_data_ready+0x9c/0xe4
 tcp_data_queue+0xf6c/0x12d0
 tcp_rcv_established+0x52c/0x798

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Pengtao He <hept.hept.hept@gmail.com>
Link: https://patch.msgid.link/20250514132013.17274-1-hept.hept.hept@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_strp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index f37f4a0fcd3c2..44d7f1aef9f12 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -396,7 +396,6 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 		return 0;
 
 	shinfo = skb_shinfo(strp->anchor);
-	shinfo->frag_list = NULL;
 
 	/* If we don't know the length go max plus page for cipher overhead */
 	need_spc = strp->stm.full_len ?: TLS_MAX_PAYLOAD_SIZE + PAGE_SIZE;
@@ -412,6 +411,8 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 				   page, 0, 0);
 	}
 
+	shinfo->frag_list = NULL;
+
 	strp->copy_mode = 1;
 	strp->stm.offset = 0;
 
-- 
2.39.5



