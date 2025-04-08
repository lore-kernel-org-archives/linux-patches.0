Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184E2676E1;
	Tue,  8 Apr 2025 12:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113688; cv=none; b=HC2U2KZXDBF8lMFwJ1E/Jiaj5PfM0JTo13R6q5uGZKTlM7ZqnshEL/S3E3XrU0kENzKTDx1TvscR5suJnNBisSQJF5WKQDoZxajgO/algAC0WZsltEDFLG8G3XPbSE9XPMruESvs5ItZMzwcDNBjsuxNRce032eAaRj6K9Ew6t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113688; c=relaxed/simple;
	bh=9AAdLibJJ/hs88YGCFYrGPkWWP59rR9v+p70a8iWGGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3zjC71KWkbFt/7s9PvNqdBwluW1cIaTuwaVdLNLgydvza/G9aD7DKi+3Qf7U30TZKCXmSMrbORXify60JKTs4MZy/L0H9RBO926kJ95O0/cNhEeIKgPrh1Zshx6RpcpOjexORPQvUnatnrYNSq9PzHHe9J4ivnP/Eh55gDPS0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgG7F0tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgG7F0tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72881C4CEE5;
	Tue,  8 Apr 2025 12:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113687;
	bh=9AAdLibJJ/hs88YGCFYrGPkWWP59rR9v+p70a8iWGGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgG7F0twTuKNg/vN93IpR5X2BBu8OgMjv3758Xp4TiZhoDyt4GX+P4d76I2A7Jtzk
	 JvJoBYI+nzGP8+Oh0mcONlotuMujBcyQoQA4WsfPwte9sTYFADtxa52bN07EbCK9FO
	 CGHadow92X0ECIJMTRghurVgzF3gQcr9yEfLT/Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 253/268] ksmbd: fix use-after-free in ksmbd_sessions_deregister()
Date: Tue,  8 Apr 2025 12:51:04 +0200
Message-ID: <20250408104835.407908391@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


