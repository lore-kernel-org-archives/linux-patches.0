Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1751356C;
	Wed, 30 Sep 2026 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790246; cv=none; b=fVqtUV1qgSQPCm+13/WAoKw/z3s6nwxSI3JZ6ubd02znuXVTZOcgUzAvZ/SJdLf9v03KPv1OGneu4I0IRPdsgQ5Zbdk6XxYpqMYxmODMHDaM4bCLbenxk+FpflJbFoxrTtT3gEIIJCfrFIGnUmwG3Y7qMGX8Qg0HC5Va96kLnbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790246; c=relaxed/simple;
	bh=2RSanxlYnN3/AK5UEiBEDImjkCJ534TSSDdllJzXIfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9Razy5OBllJIGA5DnAgznA713CmvcAwri7fOKFqJ8Fz1DQoDC2/vLVZ/0ebe2+BIdXa+VSI+9PUzDn1ojszf8HOFUvkjjLOIEnHBkYqyGe8xZvU1OctyilhlpIkUW/1GNpco0evuOLca4Vu/GmAfWuN4bqNlcy90JDAfo1d/Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Spd90UGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Spd90UGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB2A1F000FF;
	Wed, 30 Sep 2026 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790244;
	bh=utH4ZhL9HWWEO52krFz+1DLbnVez06Cx9mBjm3y42ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Spd90UGtDNcyeOSPVQW8EQTNhoymQ+sPrcEv4MMOGpcO0+dcBxzOnigCeCc9rmozW
	 L7m5cpQIUlZ2GItylhA1PyxaHeincDq08ZvHB3fXmMd/NH9nk1z8ALr7w1I75BNTgZ
	 pmdGmGlhGQQ3jVvBAfqlrw2JdQMvgMZerjiwGapg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 761/877] mptcp: use sock_kmemdup for address entry
Date: Wed, 30 Sep 2026 17:27:52 +0200
Message-ID: <20260930152431.124902926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 52f83c0b5f857dbe24f66fc9a7f035523e9ffbc9 ]

Instead of using sock_kmalloc() to allocate an address
entry "e" and then immediately duplicate the input "entry"
to it, the newly added sock_kmemdup() helper can be used in
mptcp_userspace_pm_append_new_local_addr() to simplify the code.

More importantly, the code "*e = *entry;" that assigns "entry"
to "e" is not easy to implemented in BPF if we use the same code
to implement an append_new_local_addr() helper of a BFP path
manager. This patch avoids this type of memory assignment
operation.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/3e5a307aed213038a87e44ff93b5793229b16279.1740735165.git.tanggeliang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -68,13 +68,12 @@ static int mptcp_userspace_pm_append_new
 		/* Memory for the entry is allocated from the
 		 * sock option buffer.
 		 */
-		e = sock_kmalloc(sk, sizeof(*e), GFP_ATOMIC);
+		e = sock_kmemdup(sk, entry, sizeof(*entry), GFP_ATOMIC);
 		if (!e) {
 			ret = -ENOMEM;
 			goto append_err;
 		}
 
-		*e = *entry;
 		if (!e->addr.id && needs_id)
 			e->addr.id = find_next_zero_bit(id_bitmap,
 							MPTCP_PM_MAX_ADDR_ID + 1,


