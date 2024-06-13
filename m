Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646CF144313;
	Thu, 13 Jun 2024 11:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279634; cv=none; b=lhtTSbRLAuR6rvrPkItoIhGlPnsq8KZXdozWDpVaptYeEK7r38Rownwz14ZFLUywYpZqQQovR0p3Q/XlJEkkqvrkHCmPyzwE5J8gztgjNFxuBh7mOBLPf1RCPpO3Z3qgzy3378sQ0xxiWUqMYcna8jQJCEOa+Qx/9ZXLZpvbJNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279634; c=relaxed/simple;
	bh=9JIp2fpqavnZo5EhJc3e1g4yX5rqsc3roZ6Ve2fG3LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq+ETROcnzpJUU4ZhwqAXt8/0/GMlWbOSfbyrH7ALpswC3DiJw3YtoGQanC83aG5PMRfUrjTuFcg9iHF88KS0n+j6xWs/PVoLmJSLZJuAdJex0QRlh1KVZGHkZLEDrnvVnG95WJ7X8UwNPMYleu6Jcp2+GonzQP2iNLYj9CY8mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RB2RTBUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RB2RTBUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07B8C2BBFC;
	Thu, 13 Jun 2024 11:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279634;
	bh=9JIp2fpqavnZo5EhJc3e1g4yX5rqsc3roZ6Ve2fG3LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB2RTBUFsYXpzzwaBtDu/pxbz9z2rBY/+j6N/4UgQedn0fMrQ+qnEa0XkW43U3PPZ
	 djAsP1F6CQ1Idot4C8P8+8kjJ5H+E4cjgEehaHoWp/9sRwbzkciIhD8la9rakCKqfr
	 IDcQfX1i9NPxp+uFgIkIa0IfDJwBZVx0mYgN5hxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.9 142/157] eventfs: Fix a possible null pointer dereference in eventfs_find_events()
Date: Thu, 13 Jun 2024 13:34:27 +0200
Message-ID: <20240613113232.897716484@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 fs/tracefs/event_inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -345,10 +345,9 @@ static struct eventfs_inode *eventfs_fin
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
 


