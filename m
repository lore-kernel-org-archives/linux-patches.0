Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6783016E0;
	Thu, 28 May 2026 20:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999473; cv=none; b=d9w6jHznnTmd3nGdcILa8U/OP7Wrz3lQ4Jdax//JL1ygNCzBxoByIBz7xtXb0wf/WKd5j4986POHlCrL60TTn4iRPgnCYFRclMX+NL2q4xscbti6K3GyotQoTA2ugJjZg4z0Vt39MpD+SulNmHmWqyycCT13bqpkEEqiGymdVeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999473; c=relaxed/simple;
	bh=Wqszsedjo9sGsHt6U1mJd2tzsS8vqc04y3iil9yU64E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1HV51Caq1JyNXoyv+7CnQOP1PqjXmqr18F4VXcmtNXE4FDoLhlGZ8DlxuQCfH4931AIosPHl26HekrB3U0UWWYNLWOig647/7uPYHvBau8Sgl9APjftAITIOmwZgf+eAyklcyeTFin5Y7osvAjaY8RDiN1FK6Zzw0JZvZKdctA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFXDFQs3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFXDFQs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D451F000E9;
	Thu, 28 May 2026 20:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999472;
	bh=msZUBTj2E8boBxe7GR67XZhdnkvNtKw1BhlIYvdo/pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFXDFQs3P7vsQorgBrorxz3uYgdfAA4f8/j7O1nXLkENw0PHcD26I1r2yyHOYNeJE
	 hQ6AZX/A2dfmZybtSbsUwHz8EPtwxeTnmf5FQ2bghgHbdFXTjZdQx3sIWxJ7WBBJ7z
	 84FTQG/64Zr7txsNocKpXJWEHwsq8IE4qtPBDmiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 033/377] smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()
Date: Thu, 28 May 2026 21:44:31 +0200
Message-ID: <20260528194639.339535041@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 4d8690dace005a38e6dbde9ecce2da3ad85c7c41 upstream.

Commit 96c4af418586 ("cifs: Fix locking usage for tcon fields")
refactored cifs code to change cifs_tcp_ses_lock for tc_lock around
tc_count changes.

There was missing lock around tc_count increment inside
smb2_find_smb_sess_tcon_unlocked().

Cc: stable@vger.kernel.org
Fixes: 96c4af418586 ("cifs: Fix locking usage for tcon fields")
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -176,7 +176,9 @@ smb2_find_smb_sess_tcon_unlocked(struct
 	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 		if (tcon->tid != tid)
 			continue;
+		spin_lock(&tcon->tc_lock);
 		++tcon->tc_count;
+		spin_unlock(&tcon->tc_lock);
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_get_find_sess_tcon);
 		return tcon;


