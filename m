Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A6B676;
	Mon, 23 Jun 2025 22:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717089; cv=none; b=a0lGpUzt3Q7meo1TvqoftXN+BgBH2YrCDX8HFbpgqBvLMVwhVxn+PaUIIFaQ8unbPtNcq6eu4FbQjPIkEZ3VednRJoQ2coW8FNbTu3b//6HsTX0xv9HYT7EKrIEOwHunF/eb3u+NNb+Yqw8Q9jo7+fizkf+qCxKBKyKpK0JSep0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717089; c=relaxed/simple;
	bh=o580l8T7lFNvRe++amhizN7BGUKSFg66vM7rvxgtF70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYEwcXavC4reblLlEZDSfE3RIX7i6YLHq56KbhMSNTZLtK3HKmGZ+5NCUN5Qd4qXHFeoZDYXK3mXCin2oKCHMGDWAYabuveN0OGNEQ0IXcShNq2FWr38n5iBYPYDl/VIT6eTBazmrPo8Um8jEexvrlFBdtbM0H+mwS1Q88Ay4v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5CLPhNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5CLPhNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CE3C4CEEA;
	Mon, 23 Jun 2025 22:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717089;
	bh=o580l8T7lFNvRe++amhizN7BGUKSFg66vM7rvxgtF70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5CLPhNJxw2Lv/7EukHleHzG8Zc5VArdXliCppEx/aFfhL30o0+qKdPsNcxLb9XYJ
	 03jsXN+pzbqq1TikIavWVFvHjq4t2KFxlSqyijMC5O/xgqIYTib8pAqfNqIsnan/Cb
	 gjETJ/fwR8maOwE/DRdOCRcZW1v7/TwL/drytCds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 365/508] cifs: reset connections for all channels when reconnect requested
Date: Mon, 23 Jun 2025 15:06:50 +0200
Message-ID: <20250623130654.339885860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit 1f396b9bfe39aaf55ea74a7005806164b236653d upstream.

cifs_reconnect can be called with a flag to mark the session as needing
reconnect too. When this is done, we expect the connections of all
channels to be reconnected too, which is not happening today.

Without doing this, we have seen bad things happen when primary and
secondary channels are connected to different servers (in case of cloud
services like Azure Files SMB).

This change would force all connections to reconnect as well, not just
the sessions and tcons.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -410,6 +410,13 @@ static int __cifs_reconnect(struct TCP_S
 	if (!cifs_tcp_ses_needs_reconnect(server, 1))
 		return 0;
 
+	/*
+	 * if smb session has been marked for reconnect, also reconnect all
+	 * connections. This way, the other connections do not end up bad.
+	 */
+	if (mark_smb_session)
+		cifs_signal_cifsd_for_reconnect(server, mark_smb_session);
+
 	cifs_mark_tcp_ses_conns_for_reconnect(server, mark_smb_session);
 
 	cifs_abort_connection(server);


