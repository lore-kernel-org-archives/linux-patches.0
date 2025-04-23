Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBCF28D856;
	Wed, 23 Apr 2025 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421440; cv=none; b=ftB+Yu+y7gHtdkM8kCqKF3X2FNs54WPk1Kfi2BTy1OsHiB9fgfmQxC2dvad8yxJ64uQjmDv8QxZalFYyn8R9k+s5NS7lWgyAD7q8chC8NLtscq9ueR1MovlqVnD8qcrlXk0Kt8HUHBE0Ct00plb0+dC0o+1Njwrhvz4xHwWJMh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421440; c=relaxed/simple;
	bh=LqFHXLQnO3pbL5ia+1YBfu69gf1YxnArb4Xccr+OOgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLkD7H0gBLvGWiR+lG+a/5FKBJaprAIer/ETDowd3MuU0qeQrsas7D84zLLHYIUsIleLMawq8xP0I4FWkssXTNPynLo1AhOJ+IkjoTBFuk6++afF8/GLA2WA2coEZMNTm9oJljS8eKZSNRWHkbI48WdH2iTIspaU1OWS0GFLJ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kj+JUjFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kj+JUjFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55291C4CEE2;
	Wed, 23 Apr 2025 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421439;
	bh=LqFHXLQnO3pbL5ia+1YBfu69gf1YxnArb4Xccr+OOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kj+JUjFv5JAkNx5fkNMm1nE3kjY5IUsT5yaEgurWgqXIV5ypIPiuZ21FHjZlLXG38
	 yUwwQaHi+zIxSLR676w8ky4qDHkJVno/DBYl6KApsxtBnrRFWFvmJIquenR2iKfOPB
	 /Q4+kzr1jDgHuZZZ8J9YhCskCar50ORx0YYdDEXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 137/291] cifs: fix integer overflow in match_server()
Date: Wed, 23 Apr 2025 16:42:06 +0200
Message-ID: <20250423142630.007014255@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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
@@ -1111,6 +1111,11 @@ static int smb3_fs_context_parse_param(s
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


