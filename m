Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B527B7D07E;
	Mon,  8 Apr 2024 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584001; cv=none; b=JrN8r23zBEBp9XoH0Q95ydQNyiy7BjoXkVs1flN/JFZGCFVvYfdyLuLtyg1ffMhsDzeJ8bau6t7xrFZGPVs5KNbsxsF6jqKgPbA2wb4SwWH0YjxbRjsOvj/V5qg89H3rSyMFoZRrg2Cw6uozg1FR4NrPkuZ5KtyGEZjc0j919m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584001; c=relaxed/simple;
	bh=DhCE44rGo9Q1AC0KtQ78880apy9K3tzXOZ2YW3ZV+eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE8wYGDwyLSkXM319ojWjm5Xs0pVpgd475/htV6w5O8np6RnZdPJcmS6pa/C6EBQS6+nnkf+0TQBVyy3+a+2r4S9lfCrcpgrooLbwSvaO1g+bjjt5zbF3dvofRmExwB7j9u0tytSAnOTsdG2BGIOyvWonPdJWbCKymYbflbdEVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHQt4GeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHQt4GeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296B1C433C7;
	Mon,  8 Apr 2024 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584001;
	bh=DhCE44rGo9Q1AC0KtQ78880apy9K3tzXOZ2YW3ZV+eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHQt4GeMlEpN+Y578tk/ds4tnYpmhV+Y5ELfPNPnFeMQBQPDmZPfw+P2U/PKIG2hQ
	 32fzdMspdV8l0bd9fglEnhhwTdMzfnB76LbwN1UnoKYV7rcrnkm7kqDOnFr4lPQP6V
	 5xDrM8PaAHlHINxYlWzJTCLD5Q1x/OfAuPeRWx1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 237/252] smb: client: fix potential UAF in cifs_signal_cifsd_for_reconnect()
Date: Mon,  8 Apr 2024 14:58:56 +0200
Message-ID: <20240408125314.006347842@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paulo Alcantara <pc@manguebit.com>

commit e0e50401cc3921c9eaf1b0e667db174519ea939f upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -178,6 +178,8 @@ cifs_signal_cifsd_for_reconnect(struct T
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++) {
 			if (!ses->chans[i].server)


