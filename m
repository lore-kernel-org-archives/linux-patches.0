Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FA4267703;
	Tue, 25 Mar 2025 12:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905809; cv=none; b=ojxeraeyhkLDrFv7J5w7Dsh/fgFeb/Ge/s1RSqcHIqETlnbw3kfq/ESiSUrj3ul7MoCyAf6kBMcycEeOqBzV1M3wviPJvkGUewxgMW7UIRMUpMa86YsRUQXolDrthw/FdnikiZTaIzLA/9lu+l2Ib6JYnaMxcxFj2xyj7UaNJNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905809; c=relaxed/simple;
	bh=mlCX3o1UccWhTnRZjgVJtTYHYyTKZRViN5Kqs/wV/8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSpBn7G43T/DMqQgdkjDzm5siErhu2QF+CjR1xiELTbLAfQyPSLGo4HCsmWQ562PzNSZ1EgR9spSYDrGkxjFv3wUCqcNJGao0LXW/QX+byU0pRqv/L4ASHBKS1NlCJNEmL2u+xYOR66tHpMbOxqlbsUsIxTmthHwY+n/Y9g9vFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuqIx8Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuqIx8Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760F6C4CEE4;
	Tue, 25 Mar 2025 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905809;
	bh=mlCX3o1UccWhTnRZjgVJtTYHYyTKZRViN5Kqs/wV/8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuqIx8PnHYT5j+OyDAeE4H/cN0N5p42pxb8wYTAll5ZWPfxWpjlxkpRIlmYPY/I0K
	 hjWya5/XSgIweRDMatTSthYpYZJ5Vp/81e/pFbPd9XsV36knpz2V914O6ElHr263S9
	 /ugr/n60yuo8wOVG0mVj5JF9/4/Evye0LacmHj5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 145/198] smb: client: fix potential UAF in cifs_dump_full_key()
Date: Tue, 25 Mar 2025 08:21:47 -0400
Message-ID: <20250325122200.462937228@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 58acd1f497162e7d282077f816faa519487be045 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/ioctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -246,7 +246,9 @@ static int cifs_dump_full_key(struct cif
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
 			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
-				if (ses_it->Suid == out.session_id) {
+				spin_lock(&ses_it->ses_lock);
+				if (ses_it->ses_status != SES_EXITING &&
+				    ses_it->Suid == out.session_id) {
 					ses = ses_it;
 					/*
 					 * since we are using the session outside the crit
@@ -254,9 +256,11 @@ static int cifs_dump_full_key(struct cif
 					 * so increment its refcount
 					 */
 					ses->ses_count++;
+					spin_unlock(&ses_it->ses_lock);
 					found = true;
 					goto search_end;
 				}
+				spin_unlock(&ses_it->ses_lock);
 			}
 		}
 search_end:


