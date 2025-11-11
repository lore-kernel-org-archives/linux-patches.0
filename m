Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B62214210;
	Tue, 11 Nov 2025 00:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822381; cv=none; b=tgm+jPZGlryqLGlw/xzlELnPa4FCHQ9IA2bh4A8MnsmGkr0z7QE/D2MsoC5wgWGyiW4TTYT0H55ySBuzmQUbceh6syNO2JQeJq3wuoxg/2yNsH2dSJmhudfRbcTdUlnj2Q4E2A77euJ4zPcpDizPYr9QkRRfZvzSlFpzVDzRlW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822381; c=relaxed/simple;
	bh=MULBda9FXiu8hpGZPpEbREbRYW6BtbIUwrgj2FfaN30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7c/ViWZytEy38SYjJAKZMyc+UbTpzdXaL2Sa4HoKpE0dSIxhN70INSNwpE3XphIgORWCd7lr02C+TtKZymQT5a9uXjI32Rr1gbMXwlP+ztZEP0+GAB/mmGclUkS4nbWbU+P00CiockOL1lJS+EIEvigBbz1BiH90VO57seL5Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8BbjFmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8BbjFmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC67AC16AAE;
	Tue, 11 Nov 2025 00:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822381;
	bh=MULBda9FXiu8hpGZPpEbREbRYW6BtbIUwrgj2FfaN30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8BbjFmzUcEh3Bs9NRUwXAF2pKZa4zR5sHr34lkZNH4pcb1H+bo3AFGxPwVqE9Nro
	 D1t2wDv3BcsIGM/TqpluNLFdM98aipbxYwtOeWIsYSf10NG38BrEBhVBKiSw5MsVdR
	 y5Dcop2XS5lAOdmIQ39CEf07NXQJciUXRHA7Hwyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.17 097/849] s390/mm: Fix memory leak in add_marker() when kvrealloc() fails
Date: Tue, 11 Nov 2025 09:34:27 +0900
Message-ID: <20251111004538.753043770@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 07ad45e06b4039adf96882aefcb1d3299fb7c305 upstream.

The function has a memory leak when kvrealloc() fails.
The function directly assigns NULL to the markers pointer, losing the
reference to the previously allocated memory. This causes kvfree() in
pt_dump_init() to free NULL instead of the leaked memory.

Fix by:
1. Using kvrealloc() uniformly for all allocations
2. Using a temporary variable to preserve the original pointer until
   allocation succeeds
3. Removing the error path that sets markers_cnt=0 to keep
   consistency between markers and markers_cnt

Found via static analysis and this is similar to commit 42378a9ca553
("bpf, verifier: Fix memory leak in array reallocation for stack state")

Fixes: d0e7915d2ad3 ("s390/mm/ptdump: Generate address marker array dynamically")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/dump_pagetables.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -291,16 +291,14 @@ static int ptdump_cmp(const void *a, con
 
 static int add_marker(unsigned long start, unsigned long end, const char *name)
 {
-	size_t oldsize, newsize;
+	struct addr_marker *new;
+	size_t newsize;
 
-	oldsize = markers_cnt * sizeof(*markers);
-	newsize = oldsize + 2 * sizeof(*markers);
-	if (!oldsize)
-		markers = kvmalloc(newsize, GFP_KERNEL);
-	else
-		markers = kvrealloc(markers, newsize, GFP_KERNEL);
-	if (!markers)
-		goto error;
+	newsize = (markers_cnt + 2) * sizeof(*markers);
+	new = kvrealloc(markers, newsize, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	markers = new;
 	markers[markers_cnt].is_start = 1;
 	markers[markers_cnt].start_address = start;
 	markers[markers_cnt].size = end - start;
@@ -312,9 +310,6 @@ static int add_marker(unsigned long star
 	markers[markers_cnt].name = name;
 	markers_cnt++;
 	return 0;
-error:
-	markers_cnt = 0;
-	return -ENOMEM;
 }
 
 static int pt_dump_init(void)


