Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EA7432BD1;
	Thu, 16 Jul 2026 14:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212061; cv=none; b=LoS0ySAqdXCm6faZApZg9nrJXQa95wRx6BBEaGzvSGdCeK0Ie/PB4UZmx0PNoAmC8+0Ya2GSOKsDmMT7e7ENc5Rs362rVlpf1/pSQcRlDQ2paiLb4UEwRueRVqwrpdEs/2bD+HS5YwruQWJuY3v4GTT6w8zVg3WP/HEAHcQJedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212061; c=relaxed/simple;
	bh=gIX2KTTmQamgIapc9R8VR5rjzqR5vWD+lDrfjWEJP54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0jcH93uX96OoB5Kh0RewKxeTaBFporkuF1G2MvSLe9BqjgSB9OX/NLq1QF1Qn1mJFIA//rOCe/sBj1bXd/X21MDN+W9E/UBAHx4J/B2CELrtmUHQ3qhQUlptGNVQJpkXfNXjjkheKxrh+KaJr4lDa+mZp6baC1g9FeZX0wlHqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRCM3b+Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRCM3b+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74371F00A3A;
	Thu, 16 Jul 2026 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212060;
	bh=ulDQn431jU+OkPSliJ/+H9w3AY6ahxI2FnAfd3+FpIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRCM3b+QTbNK3jjzTwS9ZbRufkx1ZZFz5nvk3XQ13tNCrGDpfJqffH0svPmzgzpeC
	 Q0fcgKrQugzSOjwfrVO1XtTn2TYhosyRtQRJIac1E06ILs+AXjPQwYPZK+Dg/nVB6o
	 gH+U30XuPxOB2Hs1jec9cwOIsyjjoptnmcITTDOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 182/349] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Thu, 16 Jul 2026 15:31:56 +0200
Message-ID: <20260716133037.452780842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit b86467cd2691192ad4809a5a6e922fc24b8e9839 upstream.

The server controls create-context DataOffset, so the POSIX context data
pointer may be misaligned on strict-alignment architectures. Use
get_unaligned_le32() when reading nlink, reparse_tag, and mode.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2313,9 +2313,9 @@ parse_posix_ctxt(struct create_context *
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);


