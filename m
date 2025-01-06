Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54851607AA;
	Mon,  6 Jan 2025 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178650; cv=none; b=GHH7v5OZ/dgDWpBKW7E5Gy8Bg12EG9Hn7UafHL5DjFR9fWuGvNW03hDXvulWsddr+JuN3Q+KmnG/TZyvQvsCpLHttLSQjSpVFfsbEVVE5nHtPR+fD98FzJ8mRA4rsbXFzZOON5YliUCxl6hXyeTJBsLrJOSFHhJ470gQMRbTFHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178650; c=relaxed/simple;
	bh=O4hKSF9UrrlxwQt6m3ecEvhUpz9Ab+pCbcSMi+2h5zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Umb0RAY5784mBOZydrMb8PINnL6E4A2oObrQospITJiInvEK5aRtCROD/VHRo79+Ec6Zdoa5B+6+rZhz+NwcKojV9jW+xaLJezv9Knk25brwczjrfwCETiZ+wvObAXmSr6gQ44dkbmVhLHS+TqSuDutHZ4vW1AryARe/3ratTXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVIBLgIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVIBLgIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E42C4CED2;
	Mon,  6 Jan 2025 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178650;
	bh=O4hKSF9UrrlxwQt6m3ecEvhUpz9Ab+pCbcSMi+2h5zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVIBLgIajRBTb/uo9Jj3Bo/SNK8gECpeEcqz1GCwv+8mk5P+ZBfyjtGbF26ZarD1E
	 PKr1nXDLnd1WlG4r9AHEMFwQawVWdeJ58EQlcrVmMfBFzzowSRI8lPpsbl8Ezr7O5j
	 64EoEg4gMBuQ/9B0dSYDPnVEQ6w71iLqaQyk9J5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 048/168] NFS/pnfs: Fix a live lock between recalled layouts and layoutget
Date: Mon,  6 Jan 2025 16:15:56 +0100
Message-ID: <20250106151140.279118870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 62e2a47ceab8f3f7d2e3f0e03fdd1c5e0059fd8b upstream.

When the server is recalling a layout, we should ignore the count of
outstanding layoutget calls, since the server is expected to return
either NFS4ERR_RECALLCONFLICT or NFS4ERR_RETURNCONFLICT for as long as
the recall is outstanding.
Currently, we may end up livelocking, causing the layout to eventually
be forcibly revoked.

Fixes: bf0291dd2267 ("pNFS: Ensure LAYOUTGET and LAYOUTRETURN are properly serialised")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1193,7 +1193,7 @@ pnfs_prepare_layoutreturn(struct pnfs_la
 		enum pnfs_iomode *iomode)
 {
 	/* Serialise LAYOUTGET/LAYOUTRETURN */
-	if (atomic_read(&lo->plh_outstanding) != 0)
+	if (atomic_read(&lo->plh_outstanding) != 0 && lo->plh_return_seq == 0)
 		return false;
 	if (test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		return false;


