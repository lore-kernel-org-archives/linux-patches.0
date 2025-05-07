Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D559B28AAE9;
	Wed,  7 May 2025 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644448; cv=none; b=bj5zJrQcGjXbuzI2QpazG3UbH72OEMVWvBt7RlMZjoSpaBB0Or/GwAW+w2tCSGD5wc1wi6hBYpiLVJI/cfbfOloZ9h9Mc9R7t034p9ru6eO8j+hgOd5brcuABLaLFFardm5xegeDwynGPgKr9uYUNc9JAop0JM/Mc/fC1+LdFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644448; c=relaxed/simple;
	bh=ulB93sMs/WLB/Sfmc6HMHy53gVf3hhaK/F4ch+univE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss1DLVDAhL7efIzC1m+20bARb8t4T5+IPzXIBGClArZxKsygB5NGpegS5p8PCmsx5oeYmxT/AoqZU1ZpeOr6+7q9AkmiPkr5QiyvWpRf5u3hnjOIaXRKooMxPsQDd5unEQQwlN7qgpa7VDSFgW0Dg3aoAzuAYL1pPB9s9k2s1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fE4NV+Hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fE4NV+Hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03131C4CEE2;
	Wed,  7 May 2025 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644448;
	bh=ulB93sMs/WLB/Sfmc6HMHy53gVf3hhaK/F4ch+univE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fE4NV+HmKiPcyOti9nKTEWPtZJqfHrNNc3AkI7+qoYasDkXiLUFAX8/QFUUlBBgcN
	 AQEBwHFgh2VN20lq2JCi3v908KiaA5eAhyJhDMH7NV2brCydAXhlNCffLEx+Ghc8B8
	 uxyzx+FyGhSSB/Yc8a7mnLAN7WINcMNUCW6eIr7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 046/164] ksmbd: fix use-after-free in session logoff
Date: Wed,  7 May 2025 20:38:51 +0200
Message-ID: <20250507183822.747054515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Sean Heelan <seanheelan@gmail.com>

commit 2fc9feff45d92a92cd5f96487655d5be23fb7e2b upstream.

The sess->user object can currently be in use by another thread, for
example if another connection has sent a session setup request to
bind to the session being free'd. The handler for that connection could
be in the smb2_sess_setup function which makes use of sess->user.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2240,10 +2240,6 @@ int smb2_session_logoff(struct ksmbd_wor
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	if (sess->user) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);


