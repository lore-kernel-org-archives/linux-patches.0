Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7671CAA7D;
	Thu, 17 Apr 2025 18:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913552; cv=none; b=UQCDJoWpE2hM2rrHk8RJ7YwKeFYF57n7K96TYDGVzcZFvI7bnZoDdsQpq+skUnqHZWJJ2TZzPYCDzDSp7q0OgVox2s96hSuQc/bg1tfZLhgRNan/qm5agR428ogscVO5qMpUWqA/PqNLiGZRGbPYDa34CKhqmSisvvA0SB3RrLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913552; c=relaxed/simple;
	bh=FfEVs+lA4/gLmLSmoYgS694s6nHlb8T/Vjg7+obbRMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsLBnPA0V65Ytf+si181bNv43uHm4V3tJuzqCzBR2a8VugVcWOPmSlp/NKIJ8pAi/FQ2vFh4XQaB67iRXLc3MV16naRZ5lB/lu8NC8UqTZSSmfECaCf16f2EP9LU/tt8+ZKYDPFnBvXNudO2QKmWKwLRXbKuw0b5RzTP9F2Dcds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzzQeWCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzzQeWCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96605C4CEE4;
	Thu, 17 Apr 2025 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913552;
	bh=FfEVs+lA4/gLmLSmoYgS694s6nHlb8T/Vjg7+obbRMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzzQeWCoyUzkYc2OYfaDytq6Zo+bLP5WHYVuZkhUQddhS19gDQWO0c7hJ3oD2LbIE
	 Ct2YYHePCxngEzDLcWp2jrilzAF+S7ex05/fhyrJ+2I9jepnEjRmpW/HT42Fg0JXY2
	 q6KIeJYeB1lmULpBIM1VzgaOsUfWd8c3VfboKJSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 376/449] cifs: fix integer overflow in match_server()
Date: Thu, 17 Apr 2025 19:51:04 +0200
Message-ID: <20250417175133.389271957@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1377,6 +1377,11 @@ static int smb3_fs_context_parse_param(s
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


