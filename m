Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E053B3C0A;
	Tue, 21 Jul 2026 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665938; cv=none; b=XQjqfPZJqBtNU5FC+nEB3KfGogo1qwz8omEF1preR6yUb1KKYXKT9eMMo/s1mJuN86YWDAyWjYXIN/qOLOLlSxYGCE30klba2xqGs9c38xaU5nRIqqLP+feTOO6dFxYIWFxTkGrT3cRhMBPWVPER8LvIURy1gybkpIykGNu/a9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665938; c=relaxed/simple;
	bh=XMOAgkw8RhaYdA5QDwjeqGoT0gIekXqfzcBAik0GSRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlpxxGLQyiPGWsTBa9uvir5o5o+TchqKsvGxiYbnVVItGts/a+Wpuo2SHouOVIG81S5j/WwsEM8D4RbQtXHIfWuIrCszYLIzKw6OAuVvn/48dCzntV3C+4F8/SXoi5Jo6Et/pkVEiI7i0UtDVg4mArSl8CtnJm0+f+Yj8uioSYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTmCZEzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTmCZEzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43021F000E9;
	Tue, 21 Jul 2026 20:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665937;
	bh=AbSsKT/1ptK1iRlaty4g/6h7M4Nf31LJaKdbtk/ArYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTmCZEzd6C7CYBg6Ko0e+Lwo8v2C92FsgNA1BA/24+xLtUTMZF5CFfp7fcAjg8nEQ
	 FPAjN9nYBw3sNV51vzMirmN+WXYN1f9kvY4YOl36etiDJjDHY+r+XYk6gCb7n/7X+N
	 TXCgHmEwaHX+PvQcYxeB3F6IU+ws/sDwWnFnozZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ginger <ginger.jzllee@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0492/1266] ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()
Date: Tue, 21 Jul 2026 17:15:29 +0200
Message-ID: <20260721152452.853128234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 57dcfd9049d497c31151787a0696d59f0a98f8e6 ]

Move atomic_inc(&ocfs2_control_opened) and the handshake state update
inside ocfs2_control_lock to close a race window where
ocfs2_control_release() can observe ocfs2_control_opened dropping to zero
(resetting ocfs2_control_this_node and running_proto) while
ocfs2_control_install_private() is about to bump the counter and mark the
connection valid.

Link: https://lore.kernel.org/20260601121618.1263346-1-joseph.qi@linux.alibaba.com
Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Ginger <ginger.jzllee@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/stack_user.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 38c0d6f64fce38..eeb1c29b033e63 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -327,18 +327,14 @@ static int ocfs2_control_install_private(struct file *file)
 		ocfs2_control_this_node = p->op_this_node;
 		running_proto.pv_major = p->op_proto.pv_major;
 		running_proto.pv_minor = p->op_proto.pv_minor;
-	}
-
-out_unlock:
-	mutex_unlock(&ocfs2_control_lock);
-
-	if (!rc && set_p) {
-		/* We set the global values successfully */
 		atomic_inc(&ocfs2_control_opened);
 		ocfs2_control_set_handshake_state(file,
 					OCFS2_CONTROL_HANDSHAKE_VALID);
 	}
 
+out_unlock:
+	mutex_unlock(&ocfs2_control_lock);
+
 	return rc;
 }
 
-- 
2.53.0



