Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F49243364;
	Tue, 29 Apr 2025 17:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949215; cv=none; b=t3g93WktW4ZQbd/lzwKQVzbiDXpguvkCagGeeMgkDz4wZITQcKpIcq1avZ1bCWOe4dTjSzWO3/wjqUNB5HF1pK1ODRB26+6CMe42G+UN8BQoqLXeZDZkCukJpzHZ1yyLhpJA1gSJE56kjdG3wgVjTwXWXLEAPJaEWO1Np078Z0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949215; c=relaxed/simple;
	bh=I1NlgHPwswv4OeATSi2GUg08zdJxO86n4cpLqb7N69o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNKp2UdKU9UbL/TiZ3PJvL189WlTRDSifw36kwIjh/YjUDimRUQfFCHGDZDk6/vbA+ZE1Y6le2L2yOPsUa/vq61WmkHOZcdOoqp5pTdNwVSvX03J47J45eTWwyVnr/1Y9pLlQ1g8yHRBfgBTGXqfZ4pkqOP6elv9kGZvPxce4RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIsiV5rV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIsiV5rV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0E3C4CEE3;
	Tue, 29 Apr 2025 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949214;
	bh=I1NlgHPwswv4OeATSi2GUg08zdJxO86n4cpLqb7N69o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIsiV5rVJNNxCGY7o+8f/DmNP8ngH1/w/1UZhNs+EBkad+vOmRojyNKUDk1WPh3Yv
	 EozjwA8UZdv9MOxcViVY36DZfEIeQhsRhH+3MG37H4uypcsQ3SzQQCkiLOFCGMe/3S
	 6HvyYtTxkBSVK26r8CY4ZqBm9Q++pDRYer/g5Ee8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 219/373] smb: client: fix potential UAF in cifs_dump_full_key()
Date: Tue, 29 Apr 2025 18:41:36 +0200
Message-ID: <20250429161132.163977179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 58acd1f497162e7d282077f816faa519487be045 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ This patch removes lock/unlock operation in routine cifs_dump_full_key()
  for ses_lock is not present in v5.15 and not ported yet. ses->status
  is protected by a global lock, cifs_tcp_ses_lock, in v5.15.  ]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -232,7 +232,8 @@ static int cifs_dump_full_key(struct cif
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
 			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
-				if (ses_it->Suid == out.session_id) {
+				if (ses_it->status != CifsExiting &&
+				    ses_it->Suid == out.session_id) {
 					ses = ses_it;
 					/*
 					 * since we are using the session outside the crit


