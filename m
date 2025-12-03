Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6066A252292;
	Wed,  3 Dec 2025 16:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779925; cv=none; b=UvwCaWzF0q1rd7uhnZILnEJ1Yj60M5OJrGkLneR9auIIlqCMhk8GElMKm1t5vNp28qBRqrqu8AUpDmHtfjBd+9a2YS/KpwjCW9/Y33EAulwJdsLIQdta2GIciod4gt5CW6eqFcWmiQfGGUySwUSSnMdXKcM1Ym9PTfbsZcMEOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779925; c=relaxed/simple;
	bh=6YFU/Nv6oKvqwN5+Fd2APeOkcJfPV0eQpTNcX8Yf0t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDJRZhepMx0B7UgBJgdXVaopQrHVBMY+EkVU/O6REJtEOBe0suwSLwkkhL2OJ4a1UgEJqVhvKyKaf60SKSLcgDIvq3eEzUMT5oZn77bVn5gNACrvenOIHM9p+16yCOxBnpVC08u8g7dcuQ/2cVwiNXUJFMSVAtoaBUXsKxUmYv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaKVI+TF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaKVI+TF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C7AC4CEF5;
	Wed,  3 Dec 2025 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779925;
	bh=6YFU/Nv6oKvqwN5+Fd2APeOkcJfPV0eQpTNcX8Yf0t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaKVI+TFUCk5bflPM58Vy8U7Ji9UaKEX/19wlyI0Y4NtaEGPRmhPPwktBRTMsS4AM
	 4+e9tfHsX3jLFNczzuGKW7KXEQN4WDAupl5UltP6itosaJbwKu8a1T9cdybDx4i8sr
	 jCh3bubwA6yJ7anD/3kSRHBUfCMQ9heoQwSTlqLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <albinwyang@tencent.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	wangzijie <wangzijie1@honor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 404/568] fs/proc: fix uaf in proc_readdir_de()
Date: Wed,  3 Dec 2025 16:26:46 +0100
Message-ID: <20251203152455.485490492@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <albinwyang@tencent.com>

commit 895b4c0c79b092d732544011c3cecaf7322c36a1 upstream.

Pde is erased from subdir rbtree through rb_erase(), but not set the node
to EMPTY, which may result in uaf access.  We should use RB_CLEAR_NODE()
set the erased node to EMPTY, then pde_subdir_next() will return NULL to
avoid uaf access.

We found an uaf issue while using stress-ng testing, need to run testcase
getdent and tun in the same time.  The steps of the issue is as follows:

1) use getdent to traverse dir /proc/pid/net/dev_snmp6/, and current
   pde is tun3;

2) in the [time windows] unregister netdevice tun3 and tun2, and erase
   them from rbtree.  erase tun3 first, and then erase tun2.  the
   pde(tun2) will be released to slab;

3) continue to getdent process, then pde_subdir_next() will return
   pde(tun2) which is released, it will case uaf access.

CPU 0                                      |    CPU 1
-------------------------------------------------------------------------
traverse dir /proc/pid/net/dev_snmp6/      |   unregister_netdevice(tun->dev)   //tun3 tun2
sys_getdents64()                           |
  iterate_dir()                            |
    proc_readdir()                         |
      proc_readdir_de()                    |     snmp6_unregister_dev()
        pde_get(de);                       |       proc_remove()
        read_unlock(&proc_subdir_lock);    |         remove_proc_subtree()
                                           |           write_lock(&proc_subdir_lock);
        [time window]                      |           rb_erase(&root->subdir_node, &parent->subdir);
                                           |           write_unlock(&proc_subdir_lock);
        read_lock(&proc_subdir_lock);      |
        next = pde_subdir_next(de);        |
        pde_put(de);                       |
        de = next;    //UAF                |

rbtree of dev_snmp6
                        |
                    pde(tun3)
                     /    \
                  NULL  pde(tun2)

Link: https://lkml.kernel.org/r/20251025024233.158363-1-albin_yang@163.com
Signed-off-by: Wei Yang <albinwyang@tencent.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: wangzijie <wangzijie1@honor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/generic.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -695,6 +695,12 @@ void pde_put(struct proc_dir_entry *pde)
 	}
 }
 
+static void pde_erase(struct proc_dir_entry *pde, struct proc_dir_entry *parent)
+{
+	rb_erase(&pde->subdir_node, &parent->subdir);
+	RB_CLEAR_NODE(&pde->subdir_node);
+}
+
 /*
  * Remove a /proc entry and free it if it's not currently in use.
  */
@@ -717,7 +723,7 @@ void remove_proc_entry(const char *name,
 			WARN(1, "removing permanent /proc entry '%s'", de->name);
 			de = NULL;
 		} else {
-			rb_erase(&de->subdir_node, &parent->subdir);
+			pde_erase(de, parent);
 			if (S_ISDIR(de->mode))
 				parent->nlink--;
 		}
@@ -761,7 +767,7 @@ int remove_proc_subtree(const char *name
 			root->parent->name, root->name);
 		return -EINVAL;
 	}
-	rb_erase(&root->subdir_node, &parent->subdir);
+	pde_erase(root, parent);
 
 	de = root;
 	while (1) {
@@ -773,7 +779,7 @@ int remove_proc_subtree(const char *name
 					next->parent->name, next->name);
 				return -EINVAL;
 			}
-			rb_erase(&next->subdir_node, &de->subdir);
+			pde_erase(next, de);
 			de = next;
 			continue;
 		}


