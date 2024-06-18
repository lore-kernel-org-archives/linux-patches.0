Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA016EB48;
	Tue, 18 Jun 2024 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715399; cv=none; b=F8XJa/BPM2j6eN2KB7UpBA9rjsoWn6qEu6KCWJf1c7VtexiQ6gdw+rm923BDVKPUx2DTuTk9StZHwFKbhK6sPL/h6j/6a9gFCONn7ZF3SkTWmxmI/G6pCO2XCdw55PV6anxoLptMleQpLzTaPwHG3xCSN/zSY6aCA6L89o77WZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715399; c=relaxed/simple;
	bh=4+F4Pj5StI35apxIunb9I6fPO0n2bC2hwbwmM/jgGA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdgH/RVhovAt5EEp/J+ymYuQPj87WAQ4899yKx4o1UAu/E46qc/gLLjebSM8d5c1VdCgzw9apLxDjHlkRicyfvcpHHw3iEopLWKktcanKnUdgXE8EerqIn1C8B5BT07lZp6bkUshkIxIuLUqUJUIVBaTnx96nrexxnfPHnvECTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdCYMX6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdCYMX6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4521C3277B;
	Tue, 18 Jun 2024 12:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715399;
	bh=4+F4Pj5StI35apxIunb9I6fPO0n2bC2hwbwmM/jgGA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdCYMX6bp0U5yiXyZAT4an0Pcne25YGg7jyJBbQ0oMS+McAVaN4+M+6yyi9PG65/0
	 +XZOkK0tbeIDkzOsUboIU98+/icySFTDs/Zy5zhFvS416bl3IqR6ZGfyLTmQg1N15F
	 kVfaBRa3lX6zLzAQEk0ZBY4neNaSpU5xQCDirdSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Wysochanski <dwysocha@redhat.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/770] nfsd4: Expose the callback address and state of each NFS4 client
Date: Tue, 18 Jun 2024 14:32:28 +0200
Message-ID: <20240618123418.649820742@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit 3518c8666f15cdd5d38878005dab1d589add1c19 ]

In addition to the client's address, display the callback channel
state and address in the 'info' file.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4e14a9f6dfd39..a20cdb1910048 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2376,6 +2376,21 @@ static void seq_quote_mem(struct seq_file *m, char *data, int len)
 	seq_printf(m, "\"");
 }
 
+static const char *cb_state2str(int state)
+{
+	switch (state) {
+	case NFSD4_CB_UP:
+		return "UP";
+	case NFSD4_CB_UNKNOWN:
+		return "UNKNOWN";
+	case NFSD4_CB_DOWN:
+		return "DOWN";
+	case NFSD4_CB_FAULT:
+		return "FAULT";
+	}
+	return "UNDEFINED";
+}
+
 static int client_info_show(struct seq_file *m, void *v)
 {
 	struct inode *inode = m->private;
@@ -2404,6 +2419,8 @@ static int client_info_show(struct seq_file *m, void *v)
 		seq_printf(m, "\nImplementation time: [%lld, %ld]\n",
 			clp->cl_nii_time.tv_sec, clp->cl_nii_time.tv_nsec);
 	}
+	seq_printf(m, "callback state: %s\n", cb_state2str(clp->cl_cb_state));
+	seq_printf(m, "callback address: %pISpc\n", &clp->cl_cb_conn.cb_addr);
 	drop_client(clp);
 
 	return 0;
-- 
2.43.0



