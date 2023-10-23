Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59E014A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaHp70BR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF24C433C8;
	Mon, 23 Oct 2023 11:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059085;
	bh=A9ENBREbf22c592yixCuzCdwmRf66Vs+ntCMfFNChEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaHp70BRqk+7RO4oLXGr9npHhMpSsvzmkH3J04KgHRYhEvLmv1HjBFZJ22OkQVtjm
	 TUCnUDpUvEB23YXtwxXG1m2FVEZxx86kFNLYXyYNxIJwJQVCzZ9vCwBHjZpU+0KheW
	 ggmfOhsy7hlSXYr4gvRLtsu3HWHW1W3mF0rLorNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+60cf892fc31d1f4358fc@syzkaller.appspotmail.com,
	Ziqi Zhao <astrajoan@yahoo.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.5 031/241] fs/ntfs3: Fix possible null-pointer dereference in hdr_find_e()
Date: Mon, 23 Oct 2023 12:53:37 +0200
Message-ID: <20231023104834.686945569@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziqi Zhao <astrajoan@yahoo.com>

commit 1f9b94af923c88539426ed811ae7e9543834a5c5 upstream.

Upon investigation of the C reproducer provided by Syzbot, it seemed
the reproducer was trying to mount a corrupted NTFS filesystem, then
issue a rename syscall to some nodes in the filesystem. This can be
shown by modifying the reproducer to only include the mount syscall,
and investigating the filesystem by e.g. `ls` and `rm` commands. As a
result, during the problematic call to `hdr_fine_e`, the `inode` being
supplied did not go through `indx_init`, hence the `cmp` function
pointer was never set.

The fix is simply to check whether `cmp` is not set, and return NULL
if that's the case, in order to be consistent with other error
scenarios of the `hdr_find_e` method. The rationale behind this patch
is that:

- We should prevent crashing the kernel even if the mounted filesystem
  is corrupted. Any syscalls made on the filesystem could return
  invalid, but the kernel should be able to sustain these calls.

- Only very specific corruption would lead to this bug, so it would be
  a pretty rare case in actual usage anyways. Therefore, introducing a
  check to specifically protect against this bug seems appropriate.
  Because of its rarity, an `unlikely` clause is used to wrap around
  this nullity check.

Reported-by: syzbot+60cf892fc31d1f4358fc@syzkaller.appspotmail.com
Signed-off-by: Ziqi Zhao <astrajoan@yahoo.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/index.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -729,6 +729,9 @@ static struct NTFS_DE *hdr_find_e(const
 	u32 total = le32_to_cpu(hdr->total);
 	u16 offs[128];
 
+	if (unlikely(!cmp))
+		return NULL;
+
 fill_table:
 	if (end > total)
 		return NULL;


