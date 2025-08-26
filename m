Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20AB2139C9;
	Tue, 26 Aug 2025 13:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215449; cv=none; b=Ll83+1OIXXhP6g01E5uVJQoYPw6ekdlP9xJz2c7QnYN9cMN8Rs0plUGHSifSsG5/d6eIcnAdBsy2GYdbgld6bTDBachl6GEcIZ7EfyQxySDSayx081JAbUjlFxYXRNTviZ9t/rw10oJxMIFQZKLGSdXPkiHKFGtktQ5gsCIqS6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215449; c=relaxed/simple;
	bh=N5NQa/2TB5/tN6EjdJISBf5oSjWxBcYT9lM/RSCkzZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4ziSA4YeUKJG+QJ3NDeYrWoB1pgx3IGl1pbnWXEC1zq8KyIpHKOMytgbMjGn0iUH+RqfMAoAu1f4YCJ5rktu5HdUCLeQxiUvqklHCaYSTOvKy8VsbT/3VWQZ3hwxEM9h/VCPPr3ueEG9q6YV8DkQ4mlaHBPNBG9FTkoHjC8Szw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2TBt1qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2TBt1qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85344C4CEF1;
	Tue, 26 Aug 2025 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215448;
	bh=N5NQa/2TB5/tN6EjdJISBf5oSjWxBcYT9lM/RSCkzZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2TBt1qZ2ZBiMHbQYIb8kWUOmIqloqFo83XB0fAw2OrIaxczrLD3U9aCxXZVIxn2V
	 crZ34FpjyUwlj6hOOgxt9eIerZKUgSzG0DbgjOspaAdSnQAlTdfUmqHLQM6SSPR8vY
	 WprTfmqWDX3J5fSN7mnKrD9xlX5cUo0vN2gDaTcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/644] net: emaclite: Fix missing pointer increment in aligned_read()
Date: Tue, 26 Aug 2025 13:02:09 +0200
Message-ID: <20250826110947.455476297@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 7727ec1523d7973defa1dff8f9c0aad288d04008 ]

Add missing post-increment operators for byte pointers in the
loop that copies remaining bytes in xemaclite_aligned_read().
Without the increment, the same byte was written repeatedly
to the destination.
This update aligns with xemaclite_aligned_write()

Fixes: bb81b2ddfa19 ("net: add Xilinx emac lite device driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250710173849.2381003-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 84e459358b055..81135fa5bd08b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -294,7 +294,7 @@ static void xemaclite_aligned_read(u32 *src_ptr, u8 *dest_ptr,
 
 		/* Read the remaining data */
 		for (; length > 0; length--)
-			*to_u8_ptr = *from_u8_ptr;
+			*to_u8_ptr++ = *from_u8_ptr++;
 	}
 }
 
-- 
2.39.5



