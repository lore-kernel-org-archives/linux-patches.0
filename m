Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AC41A0BFD;
	Sun,  7 Sep 2025 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277208; cv=none; b=qCitq1xGqnE9UhStOU5qcKTdxuzg4ys4bLIH11EzqKVqUyUoev5HiR7bhztdKWMtSS8e1W0xLjYkpNa362W5kOpvRV3mhtSwI+ccnpVcm+gBh2ZZ3ylDNDXyZLdkB56lAtwXDMiYUYe0lL/Dip5JxC08Z9vtipC/e1j//YNw/5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277208; c=relaxed/simple;
	bh=B7psiQ3aryK0aUF5azCxPxtBUNE2REWNsZ0JjzFXQjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEvbGrT1z6RfYPI4D05OxS0fsERnks7RHrwwXJ4i+P4KMBf8EE0/r9kRrZjrVw8dlH0FMYEm4jx8j7X8CBO0wOEUxykF/FEmix4L001cFiYecMaFmobGah1KeTLLCOEaqrQAIx6OI9CQg4u/8cqIvffbipCdqF7IMs7fsFK1Lcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7kgbYfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7kgbYfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127ADC4CEF0;
	Sun,  7 Sep 2025 20:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277207;
	bh=B7psiQ3aryK0aUF5azCxPxtBUNE2REWNsZ0JjzFXQjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7kgbYfq+BXERj1tuYlNeMPj/rTe0T5Upd+1w/MfwPO+RJuO232v1C8fuDX/xxVP+
	 2hEX6YzNO20WJ6cOLSlTqkzrKVMk8ofSxQ81dDJsgikfhqFtyaLobBtXWdBwiiN4IG
	 7Lpho1+YdRO/3u2wcP1n28KG+Fy3EchoQ2Q8Bzz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makar Semyonov <m.semenov@tssltd.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 118/175] cifs: prevent NULL pointer dereference in UTF16 conversion
Date: Sun,  7 Sep 2025 21:58:33 +0200
Message-ID: <20250907195617.649199321@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Makar Semyonov <m.semenov@tssltd.ru>

commit 70bccd9855dae56942f2b18a08ba137bb54093a0 upstream.

There can be a NULL pointer dereference bug here. NULL is passed to
__cifs_sfu_make_node without checks, which passes it unchecked to
cifs_strndup_to_utf16, which in turn passes it to
cifs_local_to_utf16_bytes where '*from' is dereferenced, causing a crash.

This patch adds a check for NULL 'src' in cifs_strndup_to_utf16 and
returns NULL early to prevent dereferencing NULL pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE

Signed-off-by: Makar Semyonov <m.semenov@tssltd.ru>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_unicode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -629,6 +629,9 @@ cifs_strndup_to_utf16(const char *src, c
 	int len;
 	__le16 *dst;
 
+	if (!src)
+		return NULL;
+
 	len = cifs_local_to_utf16_bytes(src, maxlen, cp);
 	len += 2; /* NULL */
 	dst = kmalloc(len, GFP_KERNEL);


