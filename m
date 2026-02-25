Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F103033CB;
	Wed, 25 Feb 2026 06:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002703; cv=none; b=h2TqkvyYzHiXNina+k1B1IrXAud6pec4DH5EnAfYqgTN/L9GLZu7ck9lhxG5fawiiXfbkGuxtgbtqfkwsMiMLVl2O1E+PHGUmSFhGqpW5oAYMUBUMCPmGTnT3uU4q28aOWDvBqyrWPJfCdtfwBfWCBBvKTO+M/3wc0NqU0+Y1M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002703; c=relaxed/simple;
	bh=VbrUGBZGP0Umsdg/Wej9heXyuwnPZd4SNdgJAmVgoQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtYkyP9ouskXB2+8CcSI0WEJykMZY3PpB2V/fCIQ7jFWP3+2ec9Y+Yt+RVwcmJHeXt6SY7F2wHQPbK6rlvqvDeqn+dxXR6vsLsCd94OP7LEf2/xdCxU8wTdrnvBp26/HYwM2jsZe4I1hZexNYbJAuWUfRwGKwi+EBLGfQfXoXTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEeDyc95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEeDyc95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C97FC116D0;
	Wed, 25 Feb 2026 06:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002703;
	bh=VbrUGBZGP0Umsdg/Wej9heXyuwnPZd4SNdgJAmVgoQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEeDyc95ggZ6c46MkB+wq5Wuy5rLjIeVVCEzxIc2td6ttsDQzQDmTQH/Y4PcWB6KN
	 rXpbY5KnsF4nnXDaacOl1A9VmsLU27drstAy+mE2mNar9tAlB/uMQsL+8zpM52tw8Z
	 Zwa9OlKDhsP0fSdv6lg7qWNMpe99aqaIfinim7xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 502/641] fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
Date: Tue, 24 Feb 2026 17:23:48 -0800
Message-ID: <20260225012400.683486233@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit b2bc7c44ed1779fc9eaab9a186db0f0d01439622 ]

In the 'DeleteIndexEntryRoot' case of the 'do_action' function, the
entry size ('esize') is retrieved from the log record without adequate
bounds checking.

Specifically, the code calculates the end of the entry ('e2') using:
    e2 = Add2Ptr(e1, esize);

It then calculates the size for memmove using 'PtrOffset(e2, ...)',
which subtracts the end pointer from the buffer limit. If 'esize' is
maliciously large, 'e2' exceeds the used buffer size. This results in
a negative offset which, when cast to size_t for memmove, interprets
as a massive unsigned integer, leading to a heap buffer overflow.

This commit adds a check to ensure that the entry size ('esize') strictly
fits within the remaining used space of the index header before performing
memory operations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 38934e6978ece..28bd611f580d9 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3429,6 +3429,9 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		e1 = Add2Ptr(attr, le16_to_cpu(lrh->attr_off));
 		esize = le16_to_cpu(e1->size);
+		if (PtrOffset(e1, Add2Ptr(hdr, used)) < esize)
+			goto dirty_vol;
+
 		e2 = Add2Ptr(e1, esize);
 
 		memmove(e1, e2, PtrOffset(e2, Add2Ptr(hdr, used)));
-- 
2.51.0



