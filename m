Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCCB12CDB0;
	Tue, 23 Jan 2024 00:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968988; cv=none; b=q7WKeKvpUlSRECW2BFkleIQjURFnYgJglUbWFm7QstaXNn3rChvDdmpD88ufk0t7Ic6HyXntOt/zLEmHDR5itId+tYZaDLHt+1CLVm7SpbhvMo9RP0Puu8wKFMwShyI+dgKMzYQ8Ln6mTzQ5yaZGku27rXm4bimuJcCci/nkdcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968988; c=relaxed/simple;
	bh=FRHtxzrRRWwMAGFADF2cSP829IE1r2almeQAl8Hkm7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwAJ6W/xmrDvgOqJfczG4prOz+pEuG7DR3PxUN+jiCqeVMIqj4XHMkPFiskvduHye72RtRzNB0RHXcm9M5gaapuG//qqqYKzaUew7KsPSavLnBh4GkrDci4uEhweaEqJgNFi79+B5P7bC66DwwMlgfmr/MKzF7J0s/e3IYWhsxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZDRaWyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZDRaWyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DD7C433F1;
	Tue, 23 Jan 2024 00:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968988;
	bh=FRHtxzrRRWwMAGFADF2cSP829IE1r2almeQAl8Hkm7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZDRaWyp/E/XcvcgGYEICxTI7Q2pGZhj5LznfCToT79Y9TX0pzY0XCBfSIiNXZUBM
	 SKPDpxrkImnXMjyeqnMAAaecAQm2tsJXYkYlj+Wg5wM3QJRka/3WZdpca+SsaN6gXO
	 EvbpiMqH9xdkrLJgp2aObBl702QmHEWKVvEiVX1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 144/194] binder: fix race between mmput() and do_exit()
Date: Mon, 22 Jan 2024 15:57:54 -0800
Message-ID: <20240122235725.412437948@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[cmllamas: fix trivial conflict with missing d8ed45c5dcd4.]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -272,7 +272,7 @@ static int binder_update_page_range(stru
 	}
 	if (mm) {
 		up_write(&mm->mmap_sem);
-		mmput(mm);
+		mmput_async(mm);
 	}
 	return 0;
 
@@ -305,7 +305,7 @@ err_page_ptr_cleared:
 err_no_vma:
 	if (mm) {
 		up_write(&mm->mmap_sem);
-		mmput(mm);
+		mmput_async(mm);
 	}
 	return vma ? -ENOMEM : -ESRCH;
 }


