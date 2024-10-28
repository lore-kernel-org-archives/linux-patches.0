Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8B72AF07;
	Mon, 28 Oct 2024 06:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098496; cv=none; b=g63MWFJCrUt+9c0Bow0C46Grqi6gEJwG3HPak9zPrK9HxHodw6lNp0xlJh0AAHMyKLF0lTErumNVPtPenvMgdZGmUU7qOYCB5I7ZyVUw8N9lSKcj8tQLHGzvo1p//Y3Yf22WYHhF+HNp+MjmNYl5UDVLnX1kNqKR0zgiJlsed1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098496; c=relaxed/simple;
	bh=SHrWFhB8H0KrJIHY8brPWEeQTdm2j1fTqFJjBKq/nUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smwaIE/ZiAxo7N/YkQLW3E2Zc04e7pjHFuQ6LxBWOxRkvoYb7vPm+Zwa7MhnY/XGkUC4s/wTdc4UvUFkNMBaFj7PGybcIpxi0OSHSa8lSpCs0JW3N7kVSRNNXj68RdgfzbVPpE4WX+Z/wVz/3E+k3yUrVePmvJkZFElt9MonCzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAS+Cht2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAS+Cht2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CECC4CEC3;
	Mon, 28 Oct 2024 06:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098495;
	bh=SHrWFhB8H0KrJIHY8brPWEeQTdm2j1fTqFJjBKq/nUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAS+Cht2Zb3+Coise9MtcSK+MvmqyZzAQWE/vHM11595pU1uzbECv4tVoEw0Y/c+K
	 0Z4zLeeRI1fZMGsbsKCUuB/KgP1tI5Gl7OW8HBnCyV7a9ptTHXi7+yXK/UDU1dqYsd
	 Qj67flKDP9DjmfgMoCKVDKZxKVXAkTEJ61ha2YWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Spengler <spender@grsecurity.net>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.11 215/261] fs: dont try and remove empty rbtree node
Date: Mon, 28 Oct 2024 07:25:57 +0100
Message-ID: <20241028062317.480482748@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 229fd15908fe1f99b1de4cde3326e62d1e892611 upstream.

When copying a namespace we won't have added the new copy into the
namespace rbtree until after the copy succeeded. Calling free_mnt_ns()
will try to remove the copy from the rbtree which is invalid. Simply
free the namespace skeleton directly.

Link: https://lore.kernel.org/r/20241016-adapter-seilwinde-83c508a7bde1@brauner
Fixes: 1901c92497bd ("fs: keep an index of current mount namespaces")
Tested-by: Brad Spengler <spender@grsecurity.net>
Cc: stable@vger.kernel.org # v6.11+
Reported-by: Brad Spengler <spender@grsecurity.net>
Suggested-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3917,7 +3917,9 @@ struct mnt_namespace *copy_mnt_ns(unsign
 	new = copy_tree(old, old->mnt.mnt_root, copy_flags);
 	if (IS_ERR(new)) {
 		namespace_unlock();
-		free_mnt_ns(new_ns);
+		ns_free_inum(&new_ns->ns);
+		dec_mnt_namespaces(new_ns->ucounts);
+		mnt_ns_release(new_ns);
 		return ERR_CAST(new);
 	}
 	if (user_ns != ns->user_ns) {


