Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7481476C9C;
	Tue, 20 Feb 2024 21:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464122; cv=none; b=fQBxf/IbUe5TH1y7F+Q40vwtPwXDnavENOcSQ2/Xa1A/akxgGQ1He5zxuY/bHea96iGxKDvqntG8DlQIGE+2lZi2gu4a8YpBQlgl2EoTcAD9NpqBvr9XTF8P6Cv6rzKX7Z2iMESwsSuicDtL2347csUCu6zqW9G/mUxzdS8xTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464122; c=relaxed/simple;
	bh=azkOpGFvsZK8ByFHmLqygj+RSgkfYsp35KX3xNB4gKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t17S6wFA7hFjXpF0k+xDHnIwcUlZbyPOyqxENPdTJAmgSSVCtpLvC2UBUpWrUThxvDyROhU08wW9RvC8NmB0H1d/Wn3rzbEYPblFRTyCVKwA99zgyXV2plTu/AoUllrChZmgAwvwQXJ3yE5ahdqRVOCPl4u9gQGND08frerQPI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjeeqSFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjeeqSFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E51C433F1;
	Tue, 20 Feb 2024 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464122;
	bh=azkOpGFvsZK8ByFHmLqygj+RSgkfYsp35KX3xNB4gKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjeeqSFmFjtvUsyeRk3WmVucBWas8tr8REu4e2htwsAiEUOBsdYCOR5L8bVmCxplL
	 NE1obww6i0zPWRpKjKirDdPFTMnDbMufOmG2p2JHgRWDmzuyy84RJQS6Y8B1i8ZUIY
	 OzYiUPYPzeHqzZtIMSGKPdrzq4+MC1LdVDoQWZ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 259/331] Revert "eventfs: Check for NULL ef in eventfs_set_attr()"
Date: Tue, 20 Feb 2024 21:56:15 +0100
Message-ID: <20240220205646.000257023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This reverts commit d8f492a059728bbd397defbc9b8d2f4159d869b5.

The eventfs was not designed properly and may have some hidden bugs in it.
Linus rewrote it properly and I trust his version more than this one. Revert
the backported patches for 6.6 and re-apply all the changes to make it
equivalent to Linus's version.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -113,14 +113,14 @@ static int eventfs_set_attr(struct mnt_i
 
 	mutex_lock(&eventfs_mutex);
 	ef = dentry->d_fsdata;
-	if (ef && ef->is_freed) {
+	if (ef->is_freed) {
 		/* Do not allow changes if the event is about to be removed. */
 		mutex_unlock(&eventfs_mutex);
 		return -ENODEV;
 	}
 
 	ret = simple_setattr(idmap, dentry, iattr);
-	if (!ret && ef)
+	if (!ret)
 		update_attr(ef, iattr);
 	mutex_unlock(&eventfs_mutex);
 	return ret;


