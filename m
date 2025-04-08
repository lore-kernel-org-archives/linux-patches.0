Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8F426F47A;
	Tue,  8 Apr 2025 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117130; cv=none; b=Rc+GOrEeqCQ3QRoXT2AG/Y5I514rNOwUxhCdAvqT1sN64rvy9rn6cxj/4fRTSGiAzXDjV5xC8Mf+0q+LgG6OsYxym2vAG/HN8QFKizFjWakdTTwO/KdaRPHmsK408jr16BKSpthFUT78obBBmrxMVJDSODeVp2Np3EsYfrN35rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117130; c=relaxed/simple;
	bh=Q4SFtYdLGQDVpEFXT1D/8dlijSc0SsT+cnYvD5IAf5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNhJWbDzWwRrXNhCbAN77cm8R6teWdwaUAvAelhBg6YzUNPC+dhnaD90SPUOLckFkIPqRTX+bZ5x1pZzmcCS+PEXpXT5rFwAXSglZbZJlZtymDzYzsu7Unasfp+XMeR/UNPCFeAnoo1OH8i7IBFchWqeH2IhFTrBPCZrfJ7Y5uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v20H8PMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v20H8PMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35593C4CEE5;
	Tue,  8 Apr 2025 12:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117130;
	bh=Q4SFtYdLGQDVpEFXT1D/8dlijSc0SsT+cnYvD5IAf5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v20H8PMmdRuEnp/NoHDmndCOaQNvKYwNGHbKBKm5EPq0Dg2a43CkEeKXDpz2TX7ax
	 79X2chRYrI5EfH1DavL1jREoWdCUxY8pS04uha8lBEVSpQwEAhhxvKClChAEBBg8pG
	 d30bvUFULvv6xCzW6HkAxbDCUf4T3nezLmjaFBcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 396/423] ksmbd: fix use-after-free in ksmbd_sessions_deregister()
Date: Tue,  8 Apr 2025 12:52:02 +0200
Message-ID: <20250408104855.123031333@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 15a9605f8d69dc85005b1a00c31a050b8625e1aa upstream.

In multichannel mode, UAF issue can occur in session_deregister
when the second channel sets up a session through the connection of
the first channel. session that is freed through the global session
table can be accessed again through ->sessions of connection.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -230,6 +230,9 @@ void ksmbd_sessions_deregister(struct ks
 			if (!ksmbd_chann_del(conn, sess) &&
 			    xa_empty(&sess->ksmbd_chann_list)) {
 				hash_del(&sess->hlist);
+				down_write(&conn->session_lock);
+				xa_erase(&conn->sessions, sess->id);
+				up_write(&conn->session_lock);
 				ksmbd_session_destroy(sess);
 			}
 		}


