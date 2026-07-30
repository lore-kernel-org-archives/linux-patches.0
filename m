Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1186144CAC2;
	Thu, 30 Jul 2026 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427452; cv=none; b=aba5X4CKSecngrnHC5XVCk7EJhVp3tWkdcIXAwnTsV/19eTUDf9GOS/wMMVOUrSlKrV+oHBIuDLVF21NU5GojhoNxX8GMttDBRaPRd762tvjMaOtIvw9icAF/gmPjqLVmSotaAq1tx1OrjmBCtTemHDSqnveND88oi1d7Sp2mpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427452; c=relaxed/simple;
	bh=pzNQ9BNocjA4gUU2r7gfhrdz19aVGxGyhGnuilMFeV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jss2bzQO7cI04mBzhlLAlxPY9BVcrAMSePtojwB9vzAU+vzSZlxst0vlEZf5uYaQHYPV/Sz7bKM3/7d/9JNbbDpxNd8S57uhsNPDMVpO+y0QPZD7RVtR/U4h9gTepmf4fFVScRmNtxkan4HkwVsFiIws91NLh26yKb3JgI6OTg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtMUC0fk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtMUC0fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8A51F000E9;
	Thu, 30 Jul 2026 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427451;
	bh=3lOSDQ2ND+J0Pj9s/QzMZ+GP5yIbu7yWsRiO6T9lwkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtMUC0fkPN3L2JUCEiYlHIgPeiVaCJz7bj5+TfBcBn6pVdzD6cbhCRPxw72HP34Wb
	 0lxT9K+b0k3uHvOm8XLpgIjTdd8YpA4PE+/AvxXoauqQlArMMcyKn8zkophjm6o8FE
	 5hXE3tGOClvHokZb00fbWl4/yjcNzHzxpAqs9ZS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+85d0bec020d805014a3a@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/484] tipc: fix infinite loop in __tipc_nl_compat_dumpit
Date: Thu, 30 Jul 2026 16:11:10 +0200
Message-ID: <20260730141427.226606073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c763008a8adbaa..c760ba270547e1 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -222,6 +222,10 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
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



