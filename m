Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C58605A4;
	Tue, 23 Jan 2024 01:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974689; cv=none; b=QKVvQ2tNpW/YgUBTE7stBSyy3+QK2hgxmvoCJDO+IfX0Xg785911PiUHGNxYDiaVsZ19Q/GL7mmKRxaRKtXsMhOeRlVCyyyw+ZuqDA8rho6/Vqy7yO9etJege3looHXusALR2kt9NYkVvN4vagoMXzM3m0DWnC76JoeIlZ9b+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974689; c=relaxed/simple;
	bh=CFt5n9aJJovuveX0xeC9lp5fYtrxvBfCccFMMYE0//U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgo74w1gz/MkUyNY0qk8YP7owUH472f5UaeZ5LqqNGAxukpcEDtl7cJ+a7Tbicsb8fnPmg8RZcBh093qQgF7vlrl0gjbiWRmF6sI7w3Er3V4ESTVI7ax474nH63UZfk082cQ/4s3i6yvXpVghqmI4jU/rSv1lvD2CO/3KPYTa1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJwVjbpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJwVjbpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F46C433F1;
	Tue, 23 Jan 2024 01:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974688;
	bh=CFt5n9aJJovuveX0xeC9lp5fYtrxvBfCccFMMYE0//U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJwVjbpU7lgdnVhfjpoVd0rlgFs0s+BXqV4f6aW8x+af8XuLpQ1ivUk6sagnPMaR+
	 UY09QFle364FdT41+1C639BygP4/bqZr2X72w+RAFadYFahWrSyO1JrP7xuZeF9gM7
	 LzvRm+ykqlAwBp3xIW4jPzf+7rZEJ5cyNViFsUNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 251/374] binder: fix race between mmput() and do_exit()
Date: Mon, 22 Jan 2024 15:58:27 -0800
Message-ID: <20240122235753.499020645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 9a9ab0d963621d9d12199df9817e66982582d5a5 upstream.

Task A calls binder_update_page_range() to allocate and insert pages on
a remote address space from Task B. For this, Task A pins the remote mm
via mmget_not_zero() first. This can race with Task B do_exit() and the
final mmput() refcount decrement will come from Task A.

  Task A            | Task B
  ------------------+------------------
  mmget_not_zero()  |
                    |  do_exit()
                    |    exit_mm()
                    |      mmput()
  mmput()           |
    exit_mmap()     |
      remove_vma()  |
        fput()      |

In this case, the work of ____fput() from Task B is queued up in Task A
as TWA_RESUME. So in theory, Task A returns to userspace and the cleanup
work gets executed. However, Task A instead sleep, waiting for a reply
from Task B that never comes (it's dead).

This means the binder_deferred_release() is blocked until an unrelated
binder event forces Task A to go back to userspace. All the associated
death notifications will also be delayed until then.

In order to fix this use mmput_async() that will schedule the work in
the corresponding mm->async_put_work WQ instead of Task A.

Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-4-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -271,7 +271,7 @@ static int binder_update_page_range(stru
 	}
 	if (mm) {
 		mmap_write_unlock(mm);
-		mmput(mm);
+		mmput_async(mm);
 	}
 	return 0;
 
@@ -304,7 +304,7 @@ err_page_ptr_cleared:
 err_no_vma:
 	if (mm) {
 		mmap_write_unlock(mm);
-		mmput(mm);
+		mmput_async(mm);
 	}
 	return vma ? -ENOMEM : -ESRCH;
 }


