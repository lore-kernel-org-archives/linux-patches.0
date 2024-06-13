Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20503145A05;
	Thu, 13 Jun 2024 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280659; cv=none; b=V1BZae29OzfHL8NtU9CDpohVg5C38DMAguJumvmj8geISgFXCXE+lSxfyH8y7k/94Mn+2CNyCbYDXqlnDGsooEj9xyytZ4FEYSO/E/b+eJeNMK/tO4E5sThTxaTSG7qJwXqI6rno6OcHkhHtC39Gv0LvKVwWjXr3OGSy+Euy4Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280659; c=relaxed/simple;
	bh=MCczSXHnqyPV9RP5FlNOzxoFfwtw6WWHuu80EhXBIcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NisyyyrieI8lyYgDpO2jQUAWXC815PozesZUgJo6rj4Yh1/6wq957sh3ILL/GDfNBJzmqTg0xfA9j0emlpVrxoU8Ad0mccKdVsiKyCCR6fI9D/dCFqWQgjPguWXZPCQB2a58VlvoE2DHQXl17TIXy3kjef7O0vNkqv2n1vao23g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnFBbWj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnFBbWj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A839C2BBFC;
	Thu, 13 Jun 2024 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280659;
	bh=MCczSXHnqyPV9RP5FlNOzxoFfwtw6WWHuu80EhXBIcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnFBbWj6YCYVmH9LPDQrGYPTSnBQHzIO9nF44LuQEIBjPePnskCQ8DNRzDVcGg+3v
	 mbWcA1r0adyu6mAO25H+sGR0qka+won0Xfro6fx1qt8wYOsl2ciH5XQ89CVCiO64ac
	 7M1mbeU2PUyAKOComIbITmCqDTtI5atpBbIxkIFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 128/137] eventfs: Fix a possible null pointer dereference in eventfs_find_events()
Date: Thu, 13 Jun 2024 13:35:08 +0200
Message-ID: <20240613113228.265771784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Hao Ge <gehao@kylinos.cn>

commit d4e9a968738bf66d3bb852dd5588d4c7afd6d7f4 upstream.

In function eventfs_find_events,there is a potential null pointer
that may be caused by calling update_events_attr which will perform
some operations on the members of the ei struct when ei is NULL.

Hence,When ei->is_freed is set,return NULL directly.

Link: https://lore.kernel.org/linux-trace-kernel/20240513053338.63017-1-hao.ge@linux.dev

Cc: stable@vger.kernel.org
Fixes: 8186fff7ab64 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index a878cea70f4c..0256afdd4acf 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -345,10 +345,9 @@ static struct eventfs_inode *eventfs_find_events(struct dentry *dentry)
 		 * If the ei is being freed, the ownership of the children
 		 * doesn't matter.
 		 */
-		if (ei->is_freed) {
-			ei = NULL;
-			break;
-		}
+		if (ei->is_freed)
+			return NULL;
+
 		// Walk upwards until you find the events inode
 	} while (!ei->is_events);
 
-- 
2.45.2



