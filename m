Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5D026D4F2;
	Tue, 15 Jul 2025 13:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586981; cv=none; b=o4N3P/77bvUPAedZ7ORkKSZURv9WPMN1pSYIg6ImLo9h/bymh11NTLyirLIwZ61fd9irm3Q+lZWbUogPOXyVr0Tv/iA1ZqSpE1c8p3h+qjDBnHx8pl/gieDQu1o/cOA3KR7p1kRgaq3dMi/LtEjkaDCmhNeNwmTb/3Hwinq7Ge8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586981; c=relaxed/simple;
	bh=ciZ5tTOE/RRCVcTmEvg/0sIty5SGjH1x82wtQ7aU0kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2MOJg1KQtiZZ8LBt+6A/Vu8TWPShkUXmqouz7FUcJ1J0wX2jNIT4mZTd2Yr+WbrGAj3HlMpeZP80yNEWqhjjPXSdVMrKILrj9uit3m/rb8rnOo+MxFbb7DkQ2GFJmjMymB5V88cpayCWMUnJMgzARKEkWDVWQlndccepJGY/dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCbEK86B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCbEK86B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B88C4CEE3;
	Tue, 15 Jul 2025 13:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586981;
	bh=ciZ5tTOE/RRCVcTmEvg/0sIty5SGjH1x82wtQ7aU0kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCbEK86BvlUjPQjru2/19W7eqay1ggy9kSy93yJNJDMJBOJP8qa3oEYyFheeA2sff
	 SpBCl3hBlHbItaylg+/825+dYTPIsJ8ZO6X3ySFDxgCXpWHGe0OVKWl/Rds563wfe3
	 9hfiPGemusg/zavcNrfSUqykW5F0d92QOGFU0TOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 120/192] ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()
Date: Tue, 15 Jul 2025 15:13:35 +0200
Message-ID: <20250715130819.703460783@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 277627b431a0a6401635c416a21b2a0f77a77347 upstream.

If the call of ksmbd_vfs_lock_parent() fails, we drop the parent_path
references and return an error.  We need to drop the write access we
just got on parent_path->mnt before we drop the mount reference - callers
assume that ksmbd_vfs_kern_path_locked() returns with mount write
access grabbed if and only if it has returned 0.

Fixes: 864fb5d37163 ("ksmbd: fix possible deadlock in smb2_open")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1280,6 +1280,7 @@ out1:
 
 		err = ksmbd_vfs_lock_parent(parent_path->dentry, path->dentry);
 		if (err) {
+			mnt_drop_write(parent_path->mnt);
 			path_put(path);
 			path_put(parent_path);
 		}


