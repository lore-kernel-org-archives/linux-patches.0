Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A02571A0;
	Thu, 17 Apr 2025 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914916; cv=none; b=AXN+lUhW/EKbgGMnfibx5/flRyddAdbbh0pHC5brJQlIEhb3dQB2kPKKFoj633F306vXXF7ZrMYwo+RUpZAMEfDSrJjVmmW1yLgbCokB15pT2FhbMujY8IO5KkUO1KaIj5BqduqtW4kV5NYWfQlO7dtVNxV9f4TC285yVL3jpEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914916; c=relaxed/simple;
	bh=R3e/QihGWdHavcLKzksIhnAy7G6ZyGajqhJjUW0+tFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/kVW5K+C2BGVRhaXAF1Ws3NjFoGjy3glI2hX/73HzREaq2Dng8xEOa/uup2sllguxYpQfHv4eC0frzXQ3COTV70F7zO57KXBkHNRgAV/uQcact7UVcrgSquvRenIsp+lVv0EdDB3VCsy0TuNCZN8UnH5quZYubD4OpsQbfxpKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnPFtlIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnPFtlIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344AAC4CEE7;
	Thu, 17 Apr 2025 18:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914916;
	bh=R3e/QihGWdHavcLKzksIhnAy7G6ZyGajqhJjUW0+tFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnPFtlIC/Avo4Z3ciKltzc9wdjouJ0ZYkV54Nz7xaGtS//PvRujx9Jbhtt9cYZJA+
	 +Ez+SYU3hD9Q4ZJv/4FmnXakRcfiGwreI8B/8OS2S63P8UWIVbiPeRcy/wwAK76awn
	 JIIwxZ9hONIbbcQzdkGX71bmebFc9sDXHTAHP4vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 342/414] cifs: fix integer overflow in match_server()
Date: Thu, 17 Apr 2025 19:51:40 +0200
Message-ID: <20250417175125.185023513@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1317,6 +1317,11 @@ static int smb3_fs_context_parse_param(s
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


