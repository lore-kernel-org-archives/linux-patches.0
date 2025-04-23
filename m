Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C6D1F5435;
	Wed, 23 Apr 2025 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421634; cv=none; b=UoscFsVJJA+QeO2voti/Xos/CzGBucmn125sI/Ah7voHAJ5aTn9iBUAVrSRaf1QC6kFMxCRaonhImjhJ9/86CiYmgwdouthk1LW1xRjNIQMz7hJzGoWWdojd9CFO+FnjMgcOM8mKLWXD3bebbLm+SZuRl+19qv0YZDUCYeDOAsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421634; c=relaxed/simple;
	bh=sZnjlKvQANVcvSlFTfGPqdt0mZm81gxDhhXLaLWtXMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfm2p7vu2jw/sj5iF+psBLvWeH2ZVwUr+RmykZ6zTr4s8T5L19ZEcpZQCGRf7m0NnYh5ugyrfi9uiyC/s6ySEOTNnJkgp6aPhtJz4VlZ9IGEIloWe7jzdEJjXZAwhmgEqVS6q/QoA7nNyv8N3veRJlnXY6fUbwlL0p8NvfGhmMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9kk+4Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9kk+4Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F2BC4CEE2;
	Wed, 23 Apr 2025 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421633;
	bh=sZnjlKvQANVcvSlFTfGPqdt0mZm81gxDhhXLaLWtXMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9kk+4XjDKHrBZ89a2obazGpegJ/GCEaU5yY4if7LY8airWAMMNpIX2bT+Gdt+UkO
	 FfBy+dwlislvKRd2XeQzMOuyzyiG2zJGkk8ISxRsng7M5+ETU2T8lzkb5PbOR0W+AL
	 AVyqMiFVZJCbjiuo80mLZTYyAX5DzrUXjoEuYmYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 202/393] cifs: fix integer overflow in match_server()
Date: Wed, 23 Apr 2025 16:41:38 +0200
Message-ID: <20250423142651.734313351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

commit 2510859475d7f46ed7940db0853f3342bf1b65ee upstream.

The echo_interval is not limited in any way during mounting,
which makes it possible to write a large number to it. This can
cause an overflow when multiplying ctx->echo_interval by HZ in
match_server().

Add constraints for echo_interval to smb3_fs_context_parse_param().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: adfeb3e00e8e1 ("cifs: Make echo interval tunable")
Cc: stable@vger.kernel.org
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1299,6 +1299,11 @@ static int smb3_fs_context_parse_param(s
 		ctx->closetimeo = HZ * result.uint_32;
 		break;
 	case Opt_echo_interval:
+		if (result.uint_32 < SMB_ECHO_INTERVAL_MIN ||
+		    result.uint_32 > SMB_ECHO_INTERVAL_MAX) {
+			cifs_errorf(fc, "echo interval is out of bounds\n");
+			goto cifs_parse_mount_err;
+		}
 		ctx->echo_interval = result.uint_32;
 		break;
 	case Opt_snapshot:


