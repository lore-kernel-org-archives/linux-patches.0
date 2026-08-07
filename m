Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1F937F8C2;
	Fri,  7 Aug 2026 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117354; cv=none; b=r+7MYqK1MuMKX6QQJl7hjkUg5IM8OoTlslvVvVBaD2tbwtrCJRk2fA2NOSJu8Zmacg6rFE7ipPREQKQ4fPfCe387WPfqCtqvBEzZ+IHHdmNIfYUhvGgfEsJsvVV6cUZeFQVYqCsRbrv0xVOpLGK9WMWLKne7vfq5i844Tu9KDu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117354; c=relaxed/simple;
	bh=vA4NlZbSdzJT0GBPi6b2KadizRqmVe0TAVoeAnoHVJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVg17aZj/tGdhhawKwMiWmVvUBbQfBEykKSOwyhRh8XdmvkMaf9rX2nfZZIHEYcdbTHl4xXLinuxIXdbvRRPLkPVxZrtjUuGl3uYuEGiWO5h9j5NxhAtBpDALAZBV0O2IjfENXQtRI1Wkep9e+f6+qss0qi7K7ve6UDVHWs9vUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9sbxzhm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9sbxzhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E8E1F000E9;
	Fri,  7 Aug 2026 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117352;
	bh=1jN+h819ANouk+UEhtbxWX4dNzzaSZC/Rn8kiD+W3A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9sbxzhmfW6s3XFQBulUaMpdYj1L+O7uJ5V8YWoiIzahmTWFmXtMux98lObiceR3P
	 yVtGhcLbA9G32dd00SBqG5bk+mG4Yi34os29tOvt8sm363PPafSUNxZTcBz4mE543/
	 tGCh3bwcbcXE5qkx8AMux8jLScwWWDNRzIBArZ14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 288/438] binfmt_misc: restore write access when removing an entry
Date: Fri,  7 Aug 2026 16:38:04 +0200
Message-ID: <20260807143434.117026346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit db1856ea9196cf6e015d12199a34c0b9313c7bfa upstream.

Registering an entry with the MISC_FMT_OPEN_FILE flag opens the
interpreter via open_exec() which denies write access to it for as
long as the entry exists. Removing the entry closes the interpreter
file via filp_close() but never restores write access, leaving the
inode's i_writecount permanently negative. Opening the interpreter
for writing keeps failing with ETXTBSY long after the entry is gone
until the inode is evicted from the inode cache.

Commit 90f601b497d7 ("binfmt_misc: restore write access before
closing files opened by open_exec()") fixed the same imbalance in the
error path of bm_register_write() but the actual removal path has
been leaking the write denial since the introduction of the flag.

Restore write access in put_binfmt_handler() before closing the
interpreter file.

Link: https://patch.msgid.link/20260710-work-binfmt_misc-locking-v3-1-a162f7cb58d6@kernel.org
Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -162,8 +162,10 @@ static Node *get_binfmt_handler(struct b
 static void put_binfmt_handler(Node *e)
 {
 	if (refcount_dec_and_test(&e->users)) {
-		if (e->flags & MISC_FMT_OPEN_FILE)
+		if (e->flags & MISC_FMT_OPEN_FILE) {
+			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
+		}
 		kfree(e);
 	}
 }


