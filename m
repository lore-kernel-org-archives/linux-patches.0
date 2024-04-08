Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885202DF73;
	Mon,  8 Apr 2024 13:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583757; cv=none; b=pzGeGReAXGtXfqXYgx8bHlNSs/ae+64XMAS9Tzq18OgvhrW/vJxUybHyT7T/e4BXvYt4WuMdCEF1Eav7kTNtX17eEAqc3F01TOr7m4rzNd2nSqeROqPT5fyO2nEBx9YoaUqTbRXOcnearjIxN5zM9qka0VNlLJozrILJyms1xRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583757; c=relaxed/simple;
	bh=RBh5aMIbaLhFTsS93lJ3Uo/K7X3VdCYEU8s3mbEEw0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCkvc5SBBYdfAjEl5SOWuipgD6MfOXH6p0qgIXGp0zkW1TZf+CCEK2hozaxa6QHVeUtXPU2RYdix4sUmiEVz8+Jv1zCi0rpyUYgI78km7HBE/aNGA16k+REiOLBY4CiEk/WbBOU2A1+HEUH8/cHDqK/kB4hzgpF+Pz+ZUJDUDi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQqqTMVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQqqTMVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E91DC433C7;
	Mon,  8 Apr 2024 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583757;
	bh=RBh5aMIbaLhFTsS93lJ3Uo/K7X3VdCYEU8s3mbEEw0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQqqTMVKZNXk+pptcH5NHXgDvcEk80M98MdPlKaMHcRFLDMpG68N735qxBgLX+SbV
	 QmJR1gNd0Qk6/jk/msQQ+5Z1ij/QhJuh49bp0q78blFzY9VMujGxrDFLrBNcXTEqzU
	 eJlqguVSrowGj8s5ugde8YHOi6TpcSmZWeI00bwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 230/252] smb: client: fix potential UAF in cifs_stats_proc_write()
Date: Mon,  8 Apr 2024 14:58:49 +0200
Message-ID: <20240408125313.794154575@linuxfoundation.org>
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

commit d3da25c5ac84430f89875ca7485a3828150a7e0a upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -656,6 +656,8 @@ static ssize_t cifs_stats_proc_write(str
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+				if (cifs_ses_exiting(ses))
+					continue;
 				list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 					atomic_set(&tcon->num_smbs_sent, 0);
 					spin_lock(&tcon->stat_lock);


