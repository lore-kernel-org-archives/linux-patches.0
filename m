Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4E94119FD;
	Fri,  4 Sep 2026 05:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498698; cv=none; b=Q+FS+VTdPZ3digQoJeiy5iXYnCMwXrHtmWcvK/7Rnn+ad4XbSGWlYzVYezdLUFjRKNSDntrJk9nZec1so4NfP06pvJR2D71Rhgl5uwpkWMmnYSAHWfQdLbKKImC/TPbhHjeGFq9FcCBJ8rqUFTXgidH93MylBrEHXXkcsS7g6mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498698; c=relaxed/simple;
	bh=GUxK/sLkt72ffFqHA2cE7T1p/OSS1/U4Fgan8wiNBR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdlIIVYDtLq1IGKIDKIQg6g0CufJVpfHktYhGYPHA+d/3ykz80WPH8SOeYqOkcncx2z6YDHQrnZ1wVgZmkHDnW28RgGo6ER1hnanOQJtxUVhoR/XHA3ZAA02WQ+kjKzbFPlPAdPhkalPfRdeF6H0tIeQSeDQ1ORGe+Bx1lJ8QPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxIIchC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxIIchC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA2B1F00A3D;
	Fri,  4 Sep 2026 05:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498697;
	bh=66pvR8EudnFT3o6Peic8KV7WpFzgZP/3jQIkI54pCbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxIIchC9Hto7RL3sf+CXEL3GL9EHzLqQcz+bufRbPpdQBPTqDUy/orMEsfwaEGiTg
	 5MMp1bVamfUrqOQwM8QgHvdYel555Yzyv7EWSOGfcBy39b7twXipyshS9JuFfOiDDO
	 XoVhCIzjPalWG7eBzSvS36JnhAdSF5VPjIx9MXhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 154/713] nfsd: set SC_STATUS_FREED in nfsd4_drop_revoked_stid for delegations
Date: Fri,  4 Sep 2026 06:52:02 +0200
Message-ID: <20260904045807.279688201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenghang Xiao <kipreyyy@gmail.com>

commit 650d370cfbc66a96dd14d517bd704689b5bda4e5 upstream.

nfsd4_drop_revoked_stid() handles FREE_STATEID for admin-revoked
delegations but does not set SC_STATUS_FREED before releasing cl_lock.
revoke_delegation() uses this flag to detect whether FREE_STATEID has
already processed the delegation -- without it, the freed delegation is
added to cl_revoked via list_add(), producing a use-after-free when
cl_revoked is later traversed in __destroy_client().

The SC_STATUS_REVOKED path in nfsd4_free_stateid() (line 7983) already
sets SC_STATUS_FREED correctly. Apply the same pattern to the
SC_STATUS_ADMIN_REVOKED path in nfsd4_drop_revoked_stid().

Fixes: 8dd91e8d31fe ("nfsd: fix race between laundromat and free_stateid")
Cc: stable@vger.kernel.org
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526104554.46262-1-kipreyyy@gmail.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5172,6 +5172,7 @@ static void nfsd4_drop_revoked_stid(stru
 	case SC_TYPE_DELEG:
 		dp = delegstateid(s);
 		list_del_init(&dp->dl_recall_lru);
+		s->sc_status |= SC_STATUS_FREED;
 		spin_unlock(&cl->cl_lock);
 		nfs4_put_stid(s);
 		break;


