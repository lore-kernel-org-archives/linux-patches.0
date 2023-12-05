Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9198F6FB1;
	Tue,  5 Dec 2023 03:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfsez5uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2728DC433C7;
	Tue,  5 Dec 2023 03:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747507;
	bh=AgGfTvR3dsNM8CeDPjXi9rdCdyAEuDxRfRaEsqicgbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gfsez5ukipszncaVsG5o4giPZxfAWIyK0RFUmi8k/aKWMbAlmt2Gh77tAmfWs1CtR
	 aLAsZ8ZNZ7DoBQxifTdwRNIt+KdtFTTdd03T76ZnBtyoFcoWYhya6ztvnTXuqYEkUa
	 vHwJtDlEegwHkRV53DL07nFJ9Ba2EkswY7SwAu4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bragatheswaran Manickavel <bragathemanick0908@gmail.com>,
	David Sterba <dsterba@suse.com>,
	syzbot+d66de4cbf532749df35f@syzkaller.appspotmail.com
Subject: [PATCH 5.10 084/135] btrfs: ref-verify: fix memory leaks in btrfs_ref_tree_mod()
Date: Tue,  5 Dec 2023 12:16:45 +0900
Message-ID: <20231205031535.838699785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bragatheswaran Manickavel <bragathemanick0908@gmail.com>

commit f91192cd68591c6b037da345bc9fcd5e50540358 upstream.

In btrfs_ref_tree_mod(), when !parent 're' was allocated through
kmalloc(). In the following code, if an error occurs, the execution will
be redirected to 'out' or 'out_unlock' and the function will be exited.
However, on some of the paths, 're' are not deallocated and may lead to
memory leaks.

For example: lookup_block_entry() for 'be' returns NULL, the out label
will be invoked. During that flow ref and 'ra' are freed but not 're',
which can potentially lead to a memory leak.

CC: stable@vger.kernel.org # 5.10+
Reported-and-tested-by: syzbot+d66de4cbf532749df35f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d66de4cbf532749df35f
Signed-off-by: Bragatheswaran Manickavel <bragathemanick0908@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ref-verify.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -804,6 +804,7 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 			dump_ref_action(fs_info, ra);
 			kfree(ref);
 			kfree(ra);
+			kfree(re);
 			goto out_unlock;
 		} else if (be->num_refs == 0) {
 			btrfs_err(fs_info,
@@ -813,6 +814,7 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 			dump_ref_action(fs_info, ra);
 			kfree(ref);
 			kfree(ra);
+			kfree(re);
 			goto out_unlock;
 		}
 


