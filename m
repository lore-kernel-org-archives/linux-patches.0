Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FF620330;
	Tue,  8 Apr 2025 12:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115514; cv=none; b=cnuFmwYwcYvXfVVyIiXalYOxD8shjPMQYWfNuUCNkbD8iqfdOi9ibbq7J7T1tb2RelnbWAVdrD8bXx9gzqA5jKyuSCWNvJ2TStjy1FZYln3j/0CV5XnyYJ8AGt7FsbF68MItycwnEc2qipZxfg0eGCA/tex86BZrVnd4/qas2Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115514; c=relaxed/simple;
	bh=aCGpLjgJrIaZWYIsj/D7OQvsYudIcJrrj19pEyjjZTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+TPiCOm5fCRPzVq1FzAH0+IWUchLvycFSlpkA//gLkD5H4tUUZ1Om9W6b7jG0naRghDM0YNWY/ie3XpzfGvrUM/1tncfvp5OlXlK6/gTBVqzJuTbJC/mECY5/7HtiBtyfczc1QAogAeAUWqySaIO0LgXR+Fe2jQbCsC0HYgicU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3SXz0D5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3SXz0D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F913C4CEE5;
	Tue,  8 Apr 2025 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115514;
	bh=aCGpLjgJrIaZWYIsj/D7OQvsYudIcJrrj19pEyjjZTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3SXz0D5KqKMQq7kkI5qK9hLauRI20Pr5TueHv/CjyNsfOdwWHMWvFOBKH0+KOM8q
	 n3ed/3/Y4QW9OhAugLcL1mrvAof++jq4SqzyZ9/FfIw/lceiSB4aLUgf1nA22Qmn3a
	 SBesk360Z2vwaJwbwEqMSPJ2aX4y3ACEDk6SBmuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 468/499] ksmbd: fix use-after-free in ksmbd_sessions_deregister()
Date: Tue,  8 Apr 2025 12:51:20 +0200
Message-ID: <20250408104902.912326694@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


