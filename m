Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F6021894A;
	Tue, 12 Nov 2024 10:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408199; cv=none; b=f02Pn0k7r6rgzaMh1/6pvhI4XlnnfnntzDmpqpADf9s7YEwQ3g5R0Ja4vCgfN9WB3ptl3av3Qa1if6960zvwyZURqW9CMJpI/kkEpAUW8lPgLJNooHJD1fppBs6jlDxjJwdLbeF+lg4n/P42ayzAYbCADWmm0AZNxI7JESoUzMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408199; c=relaxed/simple;
	bh=8+hBto+PJu14FOudWVTO8FG8W3R83wSWgW8t1A0GRV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoBS1AfFoLroWYykIFbgBvyYz/5YaFHCdL+KIjydwVNaH1mwMW7nchBdz8fs8dRqOEnBwtgIZ8yRRK9tsI4AAZQ7Wzb60UuUd2ADb9PegHHJGItGOGSMl3EOKFrip05S5tF0PyKVuSpO993hhe12PjHhu8u58YYbpyj5bLHHmCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p14AW6/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p14AW6/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12595C4CECD;
	Tue, 12 Nov 2024 10:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408199;
	bh=8+hBto+PJu14FOudWVTO8FG8W3R83wSWgW8t1A0GRV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p14AW6/YQ7BOYEy+s28mfoLTKUll9lh6IPsXMg8I3FxT/SsClSyhmec0PzQ40ynOd
	 adnVNFgkQGATtxUW6x2JQulKtULmEbw/6mD97POW0LIOFh7wwNjfZp89aIDRaZikIA
	 EtSdlko2rY9yv7QwttvhAgVjK6HaeQSJt64CJ2dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 089/184] ksmbd: fix slab-use-after-free in ksmbd_smb2_session_create
Date: Tue, 12 Nov 2024 11:20:47 +0100
Message-ID: <20241112101904.274189939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 0a77715db22611df50b178374c51e2ba0d58866e upstream.

There is a race condition between ksmbd_smb2_session_create and
ksmbd_expire_session. This patch add missing sessions_table_lock
while adding/deleting session from global session table.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -175,6 +175,7 @@ static void ksmbd_expire_session(struct
 	unsigned long id;
 	struct ksmbd_session *sess;
 
+	down_write(&sessions_table_lock);
 	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
 		if (atomic_read(&sess->refcnt) == 0 &&
@@ -188,6 +189,7 @@ static void ksmbd_expire_session(struct
 		}
 	}
 	up_write(&conn->session_lock);
+	up_write(&sessions_table_lock);
 }
 
 int ksmbd_session_register(struct ksmbd_conn *conn,
@@ -229,7 +231,6 @@ void ksmbd_sessions_deregister(struct ks
 			}
 		}
 	}
-	up_write(&sessions_table_lock);
 
 	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
@@ -249,6 +250,7 @@ void ksmbd_sessions_deregister(struct ks
 		}
 	}
 	up_write(&conn->session_lock);
+	up_write(&sessions_table_lock);
 }
 
 struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,


