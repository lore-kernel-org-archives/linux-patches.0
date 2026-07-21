Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB72E736D;
	Tue, 21 Jul 2026 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654568; cv=none; b=UO3WIjOfGFVxeBlMnQPaYfgOHEtyWwATn0eQsm88bvRMFkCIzX1eZxPXwxpEcWii3a7Zpku8h5frAgFurAUAmSoXk95N+KQhsmu8JGM+glqmS54xmP4hvbAjJc2dIFMxrQV9WILPOFIgeYr6KLcfnCyPHZAI84YvnwRD+4ZQ3Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654568; c=relaxed/simple;
	bh=cb2IOrqgAz1BVGAM1Zz7qBmyx/QVxO3fYkz4yx0Y4Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f50bnEoSJoyS8cCS/wvv3PDOEZEzfPQoah2SH/vTlxUO4+OQSTA1oc1ALzdHuflogvDTPKCb7eGXVMl0YYeVsCCFz6IxfINvWF9gqp3oNosZsomEr6k6j2KMZEsbW8aZXSyEIpHNe/QAPznURL5w3++2eqrJMaEvkL6m1vlBXMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=al5Wm7KY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="al5Wm7KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1D91F000E9;
	Tue, 21 Jul 2026 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654567;
	bh=OkJYg3DmnFea+lbfmn1jTd2JrhusjySLjxy0fBxW/9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=al5Wm7KYmBjAXyYXGuwPJDR7UqMKu1PMQGzO/SYH9S9O5JKT5kEs0FHdrFDsRmxYc
	 N7FgEVPuqLppS5LRZh5lmciZDekJNqk/GeDgYVMwbDoUsWTHAnDiib0dyIBBMxojs+
	 fDdCQ4h3cjrPQytYVbpI67mxrLtkNr1S9DyDVYvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.1 1711/2077] ntfs3: fix out-of-bounds read in decompress_lznt
Date: Tue, 21 Jul 2026 17:23:04 +0200
Message-ID: <20260721152633.114645281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 7160a57192fb16d7a6fa9b7f5c7ac341d2444a89 upstream.

decompress_lznt() does not validate array index bounds before accessing
the decompression table. A corrupted NTFS3 image with invalid compressed
data can trigger an out-of-bounds read.

Add index bounds checking to prevent the OOB access.

Reported-by: syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/lznt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/lznt.c
+++ b/fs/ntfs3/lznt.c
@@ -240,7 +240,7 @@ static inline ssize_t decompress_chunk(u
 		if (up - unc > LZNT_CHUNK_SIZE)
 			return -EINVAL;
 		/* Correct index */
-		while (unc + s_max_off[index] < up)
+		while (index < ARRAY_SIZE(s_max_off) - 1 && unc + s_max_off[index] < up)
 			index += 1;
 
 		/* Check the current flag for zero. */


