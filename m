Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90E8200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/IEyRTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683FBC433C8;
	Mon,  6 Nov 2023 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276133;
	bh=feyuOLWqPrG8Bx7tyYavcftjgvsOJWb2Dxxz+KozNN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/IEyRTUydrXYehUdkvWemEYah7X8ZlZZFUPt79c/61sfqE1Av37fWsoMrzwDq3sH
	 e6oeftMtY7elzBA+BojLSW7aMMyRxT4i7Lx/RK2GbT2Qn10d/bpseBL4AjrxJRhdq7
	 y1f3OdsCiAhaYSCJCQpGOZjd52zIgXpj9UwVUGsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ajay Kaher <akaher@vmware.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 05/30] eventfs: Remove "is_freed" union with rcu head
Date: Mon,  6 Nov 2023 14:03:23 +0100
Message-ID: <20231106130258.101305850@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
References: <20231106130257.903265688@linuxfoundation.org>
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

commit f2f496370afcbc5227d7002da28c74b91fed12ff upstream

The eventfs_inode->is_freed was a union with the rcu_head with the
assumption that when it was on the srcu list the head would contain a
pointer which would make "is_freed" true. But that was a wrong assumption
as the rcu head is a single link list where the last element is NULL.

Instead, split the nr_entries integer so that "is_freed" is one bit and
the nr_entries is the next 31 bits. As there shouldn't be more than 10
(currently there's at most 5 to 7 depending on the config), this should
not be a problem.

Link: https://lkml.kernel.org/r/20231101172649.049758712@goodmis.org

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ajay Kaher <akaher@vmware.com>
Fixes: 63940449555e7 ("eventfs: Implement eventfs lookup, read, open functions")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -38,6 +38,7 @@ struct eventfs_inode {
  * @fop:	file_operations for file or directory
  * @iop:	inode_operations for file or directory
  * @data:	something that the caller will want to get to later on
+ * @is_freed:	Flag set if the eventfs is on its way to be freed
  * @mode:	the permission that the file or directory should have
  */
 struct eventfs_file {
@@ -52,15 +53,14 @@ struct eventfs_file {
 	 * Union - used for deletion
 	 * @del_list:	list of eventfs_file to delete
 	 * @rcu:	eventfs_file to delete in RCU
-	 * @is_freed:	node is freed if one of the above is set
 	 */
 	union {
 		struct list_head	del_list;
 		struct rcu_head		rcu;
-		unsigned long		is_freed;
 	};
 	void				*data;
-	umode_t				mode;
+	unsigned int			is_freed:1;
+	unsigned int			mode:31;
 };
 
 static DEFINE_MUTEX(eventfs_mutex);
@@ -814,6 +814,8 @@ static void eventfs_remove_rec(struct ev
 		}
 	}
 
+	ef->is_freed = 1;
+
 	list_del_rcu(&ef->list);
 	list_add_tail(&ef->del_list, head);
 }


