Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080782D060B;
	Tue, 12 May 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609288; cv=none; b=lNMpWN+4jBmXLHBOQ/BcEat1TGvbXLAnQZzMG8gAMH+IR2aEy+snvHPnIQ2mgoyUrZBuuwAXV/O44jRGMFAQ19a8VEiKcw+nzRUJNVxIiwVyrLQqhL2N3bN8bh9ccsYv/1eD4hFVoXA1/LBKNKWItvGOTfDW2nOio1J7gcJ2SRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609288; c=relaxed/simple;
	bh=veFHlU/4nLs/cp9l7eJptQ8cPlmyH3Ye08NOCBMkbgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsTOA/AJTBRnQhcNMcsaDgjfbs4yVdTiWm5vjHNnNJ8NubGJ1AHMx2+vWfYOg9fP/XUiu2wWcFnCxjRnqsqpSqIVK9D9uz4Q/I1SmsBTeDq5oH6zICCutXnibxMTRoURLotGxFkMg/WPftwN5aQ9dF0vxeW2+ENXzECZ8tpABVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDPX6ijz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDPX6ijz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE03C2BCB0;
	Tue, 12 May 2026 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609287;
	bh=veFHlU/4nLs/cp9l7eJptQ8cPlmyH3Ye08NOCBMkbgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDPX6ijz/b4yuIy/Wt7wxNg+geDSDNcoF/uuKTDB2kI59Fju0kZdQvGiUjU7/PdAN
	 EEfdBDKRqB4e0vEARtlksER66C1//nujtD8RVL0cAjPIPrAvJcyOVS+r3Qw+PToQsW
	 rVgGMd6op+CBVDtTfv/Zki0yrAdbCE0LiJr+4l5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 137/307] cifs: abort open_cached_dir if we dont request leases
Date: Tue, 12 May 2026 19:38:52 +0200
Message-ID: <20260512173943.020453699@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


