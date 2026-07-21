Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C271143F8CF;
	Tue, 21 Jul 2026 21:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668361; cv=none; b=KCt4r348/EJjuhcle07vKLTfmywto1CAiGOgD2r1l3GFDYacn0qz/FxSov1pYnRY1OXD8JZ2ACQUYhRjtMl34XZnM9yw1kFLzuhrcCkE5mpupLYYvJZ4T93uRdzRtbjKnC5WmZvSu7Gv9FUyjhDIixwNYFQwlo2FFsUPGNZ3sbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668361; c=relaxed/simple;
	bh=49nnsHZYjAy4Fm86Lt/pfRDZ0QZUGx67iW32oVVp3hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GL9QxOu72WdM79LUm0eEYYrNZiIJnFIjXCZ3CLlasoy/mOPXRqkPTVyVGTqNT9wtrZgfGxJNhsa1k0vVmQXUJghOlP/LA5bLr7l0yIBKtC4ZQD+CGdQUBxbz8lnlaTMYJDV8RMFmLNA2RvjMRxWUvIuMYrZF0l6PphFkp0Ch4Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBFMH2lM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBFMH2lM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9C01F000E9;
	Tue, 21 Jul 2026 21:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668359;
	bh=6i3CXa/QY7wiav4F2q4molayY0ydsZ8k4XToFJFZ+tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBFMH2lMsD+OfzL/F/Ns5kpm+r4p8Mmod/i1AF8fuu6SejLm3g5CXoHlyM1t3JtJU
	 cBcadCbjkGd1lRNmsRlgMWNNCzI6ohP7Q8HfneALti83Uj+hwXf9LR2QbdXKBG6GRH
	 5sR0YHB6z1CbQOslTM1p/oRX7Q3pKP9tNSREbslI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0144/1067] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Tue, 21 Jul 2026 17:12:25 +0200
Message-ID: <20260721152427.817516746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2130,9 +2130,9 @@ parse_posix_ctxt(struct create_context *
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);


