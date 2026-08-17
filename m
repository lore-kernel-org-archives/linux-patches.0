Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134E1175A99;
	Mon, 17 Aug 2026 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976812; cv=none; b=sl6DWW40qrChOOKRP5PxEcHuntSO9qfSpDrWdYfq5xoXL0sDU5qMkLtC+7n2PHLpy7PtcOJ35WDyBFIgvmZgtUJ3dVwqV20om7j5Azmle24/16cIkHbxjvjW2wcyE2QdQF2u3+b01pWkXem/BxQJXqs93l/5wxYBsA2hul7VSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976812; c=relaxed/simple;
	bh=RR1v0FIj+uB+NHIS0EHZBrBwmFnPUcj7FEYieVI0zfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYqD5qiM1fiNiiCMLaxxXdEDOG2ROsdBALJsZkRnLnDZoiq2IocKsrezCLnF/d461dohNWZcU1R1miH6jB3nK5f5sc0UoSWNZnHfREQRILChY5iFYwozKN0NxyAXbwkCX6jNKnBtxyvxis3rUrzAnMJ2W6H2g6Bwi/irHBeEkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4nmyrnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4nmyrnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4F31F000E9;
	Mon, 17 Aug 2026 14:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976810;
	bh=bRgEPEDTirl+LMFFpcZZXuh7sG3Eff81BDOjHrFSn5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4nmyrnMnaT/OrSghuKAiimLwbLrJuapUwY3HpiSV2GpgXvBz9LQTXXw6QwnetzFC
	 051/Bm6A5OkjGIMF21qNx6D0mhM6wNOT5QAR/7QN/Hfb5qasL5sgvtlqHiMwPLgAXY
	 STttfkCCB4qUkOkq2D6jS+l6bwuVlBuRBmTYuHPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+85d0bec020d805014a3a@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/456] tipc: fix infinite loop in __tipc_nl_compat_dumpit
Date: Mon, 17 Aug 2026 15:28:23 +0200
Message-ID: <20260817132544.505946992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <koike@igalia.com>

[ Upstream commit 22f8aa35964e8f2ab026578f45befc9605fd1b28 ]

cmd->dumpit callback can return a negative errno, causing an infinite
loop due to the while(len) condition. As the loop never terminates,
genl_mutex is never released, and other tasks waiting on it starve in D
state.

Check dumpit's return value, propagate it and jump to err_out on error.

Reported-by: syzbot+85d0bec020d805014a3a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=85d0bec020d805014a3a
Fixes: d0796d1ef63d ("tipc: convert legacy nl bearer dump to nl compat")
Signed-off-by: Helen Koike <koike@igalia.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260713204940.647668-1-koike@igalia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 116a97e301443a..a8aef355bedc67 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -226,6 +226,10 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 		int rem;
 
 		len = (*cmd->dumpit)(buf, &cb);
+		if (len < 0) {
+			err = len;
+			goto err_out;
+		}
 
 		nlmsg_for_each_msg(nlmsg, nlmsg_hdr(buf), len, rem) {
 			err = nlmsg_parse_deprecated(nlmsg, GENL_HDRLEN,
-- 
2.53.0



