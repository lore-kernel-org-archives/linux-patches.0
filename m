Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9FC76C9C;
	Tue, 20 Feb 2024 21:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464139; cv=none; b=Xfyay3C/gEl3V0EVXaTdak+KA9kTpsh4AEqYKSUHEvgafPkD+3o6vC2+fpQ61soovS4K0XX6REUmQI6i+VpJrlfFQyetNkQCQJtg6odqyH6ISokyl7FY/o0gWubUg/9LPMzQbLFjj0ceLqlm2EVmqBmsA6/9ZNiZ3UQfw4VFmKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464139; c=relaxed/simple;
	bh=4wr4veVWbJu0qg1hmzJz9zGkDjUdobuqfPI/NBH/Mlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZoxNWeMr4n6nhD0wNeUORE2tZJAUQh/rEPbClqvoGXGFkr8ES9edG68vMD0ZIQfbI5HztG9D3Ft6Lqo9fplQCAQpSgA+teXyk/5gcFVTt7n4bojZjmpVQB2g3xGmDYby+W0LiYmFXlBzj3fU1LoRu9lwttsvBUDxMF9R/aj+ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw1uQ4kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw1uQ4kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2A2C433C7;
	Tue, 20 Feb 2024 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464139;
	bh=4wr4veVWbJu0qg1hmzJz9zGkDjUdobuqfPI/NBH/Mlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw1uQ4ktXe5hlMOQqQe6B5OoP/NBRobYJNx99kQHBi5TtY/jnAjrYGqcBauvjibz5
	 wIpLFBvVcpU+h9RmdspYTw4+3VfGacM2n9XnXF8/ZnsrDLJzbPhtVG4q5C9VKkIsuT
	 Oie8PN2ZNE8DtvGeO74QR+cj+bQISH9yJ/L7nEKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 263/331] Revert "eventfs: Remove "is_freed" union with rcu head"
Date: Tue, 20 Feb 2024 21:56:19 +0100
Message-ID: <20240220205646.138174685@linuxfoundation.org>
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

This reverts commit fa18a8a0539b02cc621938091691f0b73f0b1288.

The eventfs was not designed properly and may have some hidden bugs in it.
Linus rewrote it properly and I trust his version more than this one. Revert
the backported patches for 6.6 and re-apply all the changes to make it
equivalent to Linus's version.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -38,7 +38,6 @@ struct eventfs_inode {
  * @fop:	file_operations for file or directory
  * @iop:	inode_operations for file or directory
  * @data:	something that the caller will want to get to later on
- * @is_freed:	Flag set if the eventfs is on its way to be freed
  * @mode:	the permission that the file or directory should have
  */
 struct eventfs_file {
@@ -53,14 +52,15 @@ struct eventfs_file {
 	 * Union - used for deletion
 	 * @del_list:	list of eventfs_file to delete
 	 * @rcu:	eventfs_file to delete in RCU
+	 * @is_freed:	node is freed if one of the above is set
 	 */
 	union {
 		struct list_head	del_list;
 		struct rcu_head		rcu;
+		unsigned long		is_freed;
 	};
 	void				*data;
-	unsigned int			is_freed:1;
-	unsigned int			mode:31;
+	umode_t				mode;
 };
 
 static DEFINE_MUTEX(eventfs_mutex);
@@ -814,8 +814,6 @@ static void eventfs_remove_rec(struct ev
 		}
 	}
 
-	ef->is_freed = 1;
-
 	list_del_rcu(&ef->list);
 	list_add_tail(&ef->del_list, head);
 }


