Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A8C3EDE70;
	Tue, 12 May 2026 17:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608541; cv=none; b=KSkMDcigjNYXTi4U+zxcSqGC0Gw64i01ijwxQSys7YsZdkYC+SuC0z1ZW33HewfXGG92+20rfpEq6Rj1goj23jxgALIl7ESiyC6Cp0mZR2mrkd7LbXJxI4u7pOT724uEJuOB5f1t4N4yBpn4WOYlAgUoszy+heD8qkuIctbBTHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608541; c=relaxed/simple;
	bh=T70OtSjLYze/rtizp7YN/4Pa8NV77BvGkfFsY/2UoOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIhQ1U7QGs6BcPB38LaSOzh0DytdV+wu6ZM+Bs1bBwXqqjaVuTomcLBNu5MhwwW8FN84ktUjneQ7Rqfw4+fRMbM17wdcsyTj5Xd/Ony6ajRjvdzFUWE/aDyW0spFU6yFmZ65wDIg0H1l1pB6Y2YAD5YQr9fvyeppuWi+RU11oV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElG25ji7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElG25ji7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACAAC2BCF5;
	Tue, 12 May 2026 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608540;
	bh=T70OtSjLYze/rtizp7YN/4Pa8NV77BvGkfFsY/2UoOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElG25ji727VY/9FAqOFzSZw3319xhqf9PlZhEdmN8Xfjk8/WbTEgiWqweQrVBnjL5
	 7TJWd969fIrWykZ3lNKRRpth/KKLBTu6OgkaWpWIwXmgXWfMdFMcTbueJv/pck5Oyc
	 aodKH3cvCsy5cVNsCkQr2+GEdGsHLqKwP79IfFIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 117/270] cifs: abort open_cached_dir if we dont request leases
Date: Tue, 12 May 2026 19:38:38 +0200
Message-ID: <20260512173940.921580119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit d68ce834f8cf6cb2e77f3331df65166b35466b53 upstream.

It is possible that SMB2_open_init may not set lease context based
on the requested oplock level. This can happen when leases have been
temporarily or permanently disabled. When this happens, we will have
open_cached_dir making an open without lease context and the response
will anyway be rejected by open_cached_dir (thereby forcing a close to
discard this open). That's unnecessary two round-trips to the server.

This change adds a check before making the open request to the server
to make sure that SMB2_open_init did add the expected lease context
to the open in open_cached_dir.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -286,6 +286,14 @@ replay_again:
 			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
+
+	if (oplock != SMB2_OPLOCK_LEVEL_II) {
+		rc = -EINVAL;
+		cifs_dbg(FYI, "%s: Oplock level %d not suitable for cached directory\n",
+			 __func__, oplock);
+		goto oshr_free;
+	}
+
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));


