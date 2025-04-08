Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D91BB663;
	Tue,  8 Apr 2025 12:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116021; cv=none; b=QkVNTsdFU0yZt3vPZgfS44kGDFKj1ke+jvGUZ0+jAiYlElH1CgnK1vhPUN9XfBqDPbxsBtU29L0cbgHuJ0rDqUZddz5tFAwfD5Rx5fG7kRaNmArfp3IFWhcIdB2mwd6VQ3dsY81eNboNpEOi/63kBs0/ECxiT5XjI5obIOK9Rw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116021; c=relaxed/simple;
	bh=zrq5A9UeTf2nA/K+RjawC9RucAvkIYREm+ArNm1cVx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfpKsezrrns7d3t0oerRLTpHp0OhmCpb7b2qL1qmbxs7eBqxRbNBn8WRyq2MSTJJ+TELN+Io/Z3aUarptHB/iRl3v8kF67RNIs6sRYUkiCX7pO7+u+dRi/mhkQXZLykoCvqPs4TsZ327+YU6K/TZs9hyVRz0MX4rpUsPWToOCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhYoT8j7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhYoT8j7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC6DC4CEE5;
	Tue,  8 Apr 2025 12:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116021;
	bh=zrq5A9UeTf2nA/K+RjawC9RucAvkIYREm+ArNm1cVx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhYoT8j7466nvc3J4PjGOckyF36KpYAqa9Sh0rG3btp5bMNwbzw+cAuMqEvuW1kHn
	 EHcecPb8YMDC4QDWzVx27p5yo13Oz2RPAUOsMcqPu8tJpjsMTqjqhvXC4Qvd8632xy
	 W4rHSkNC5wpW8dx/4Doo9GwNGRKTNx4rUI3Ql3uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 190/204] ksmbd: fix use-after-free in ksmbd_sessions_deregister()
Date: Tue,  8 Apr 2025 12:52:00 +0200
Message-ID: <20250408104825.888920471@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
@@ -229,6 +229,9 @@ void ksmbd_sessions_deregister(struct ks
 			if (!ksmbd_chann_del(conn, sess) &&
 			    xa_empty(&sess->ksmbd_chann_list)) {
 				hash_del(&sess->hlist);
+				down_write(&conn->session_lock);
+				xa_erase(&conn->sessions, sess->id);
+				up_write(&conn->session_lock);
 				ksmbd_session_destroy(sess);
 			}
 		}


