Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B43B6366;
	Thu, 30 Jul 2026 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422806; cv=none; b=ZyVZySOYzR1W+qyoxFwdjuQQ+DKoTBd7uhu5h72rjZTlicI7aG6fsEK48L7fIbA/NPwcKBhClbDMWzZlVIy/uyipx/DzFpPPFUV3ehm6CmoLYYZxUhJooARNzODQw6diniMdYDAkVg6ptnxW6qldtcekRMUkziEvF8XvefUz+UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422806; c=relaxed/simple;
	bh=OI+SATb0Slw3/UJeGm8x3Y50j8Y9L0Qnao90L96cmgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puuiJp0S2joPKJx0beR/JE815+T2mM+ZyJS6dlI3UALSeX3aH0fa3x2XOezR9jlOK7eISGp4qi6HaTVkzArA+eP5BlENH2wTdQEltdA7HHqvQboO8kn105Li3OI0izPdC6t8SPBp+FaAZXp9EaUhEMeIREnHs8H6bGUW4tMV+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kx3DKP5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kx3DKP5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EE61F000E9;
	Thu, 30 Jul 2026 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422804;
	bh=rQ5caSI4pnqw0Ly0dcUBRuAzbcd0WvlObsNEe+k7jfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kx3DKP5qepJoF3ZCH9bgxXTr/p4kVQlUVJC8DJLAtyE8T53Vg4b5Kck+udXI+kjvW
	 ZBY1M2qKzfKd8h60MfT9OBu0lKXDSJws4oghCHK68q+3HLcPkLHt7BJZUEAcvowMHK
	 Ae7QwSDys9KbUup9My21NN84v6L90vZ2at4+usas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.1 563/744] rust_binder: only print failure if error has source
Date: Thu, 30 Jul 2026 16:13:56 +0200
Message-ID: <20260730141456.251097059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit bb66b1a3452534adb8b72abf2f761375970fe472 upstream.

The commit that fixes BINDER_GET_EXTENDED_ERROR changed the condition
for printing transaction failures so errors are printed even if the
cause is a dead or frozen process. Undo this change so that the error
is only printed if the failure has an errno associated with it.

Cc: stable@kernel.org
Fixes: 77bfebf11077 ("rust_binder: fix BINDER_GET_EXTENDED_ERROR")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260708-get-extended-error-fix-printing-v1-1-6e293b213b70@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/thread.rs |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -1273,14 +1273,14 @@ impl Thread {
                         inner.extended_error =
                             ExtendedError::new(info.debug_id as u32, err.reply, source.to_errno());
                     }
-                }
 
-                pr_warn!(
-                    "{}:{} transaction to {} failed: {err:?}",
-                    info.from_pid,
-                    info.from_tid,
-                    info.to_pid
-                );
+                    pr_warn!(
+                        "{}:{} transaction to {} failed: {err:?}",
+                        info.from_pid,
+                        info.from_tid,
+                        info.to_pid
+                    );
+                }
             }
         }
 


