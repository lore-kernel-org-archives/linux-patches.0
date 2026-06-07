Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB91C5F27;
	Sun,  7 Jun 2026 10:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828056; cv=none; b=CiMpw1sygByZ557h6gGN4PUM8/mdQF83cjKgt5Bx013054ebwgMQYE8o2lywhJJo/kUM0Mz8qB+4D0V6a3C71FaV6znCaPCuWu0yfXGgiYffGy0r/nNtYBK/e9114OFUy8fwB60CpvtA/ihBYeI5IVDmQF1JRSqfOenWj88hKko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828056; c=relaxed/simple;
	bh=KZNbvooBaBlsTS7bCPsXKutY8m5Mhov9lCEA2SLvvZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCPKofxttZA0pU1RiTPqn4HCwfWNYajvWixm1ByHgxXWNbn1kVT010ASxEMNy1FM4M9D2QSMHXeum7F+uhfNQT3tYmWM9QuB9frJ/kKUxHMS+B500F5Y7gRIIHWTfnm26kKUU3Nw1+n3K8o60higKrWp+crCSmqgjPL5gHGYmgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPqf7S4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPqf7S4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9721F00893;
	Sun,  7 Jun 2026 10:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828055;
	bh=2V0dwLcxcrx19ts06zdnzQ364/Do0lrJw/CixTEMXrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPqf7S4xC6wEySHs7OogwoGtgyXd7//UD+bXEGVBF6fUMwKM9R/drn9qx02cD4qhH
	 M1PTDlZZUKILtAIF7LWxAbUDPbCv4yOvONI+8BdPbXYfFSVvaGPNXVOxUhFIQVeL6V
	 FwnKTEjLlC9enMVux22Pz5fbsY8g8NvC9cQ9ofsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jeff Xu <jeffxu@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <jackmanb@google.com>,
	Greg Thelen <gthelen@google.com>,
	Hugh Dickins <hughd@google.com>,
	Kees Cook <kees@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 124/315] memfd: deny writeable mappings when implying SEAL_WRITE
Date: Sun,  7 Jun 2026 11:58:31 +0200
Message-ID: <20260607095732.176645045@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav (Google) <pratyush@kernel.org>

commit 3b041514cb6eae45869b020f743c14d983363222 upstream.

When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X.  But the
implied seal is set after the check that makes sure the memfd can not have
any writable mappings.  This means one can use SEAL_EXEC to apply
SEAL_WRITE while having writeable mappings.

This breaks the contract that SEAL_WRITE provides and can be used by an
attacker to pass a memfd that appears to be write sealed but can still be
modified arbitrarily.

Fix this by adding the implied seals before the call for
mapping_deny_writable() is done.

Link: https://lore.kernel.org/20260505133922.797635-1-pratyush@kernel.org
Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Jeff Xu <jeffxu@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -284,6 +284,12 @@ static int memfd_add_seals(struct file *
 		goto unlock;
 	}
 
+	/*
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
+	 */
+	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
+		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
+
 	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
 		error = mapping_deny_writable(file->f_mapping);
 		if (error)
@@ -296,12 +302,6 @@ static int memfd_add_seals(struct file *
 		}
 	}
 
-	/*
-	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
-	 */
-	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
-		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
-
 	*file_seals |= seals;
 	error = 0;
 


