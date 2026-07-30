Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D1A18DB1F;
	Thu, 30 Jul 2026 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424651; cv=none; b=IdsyH48yHCF+j4b7sOKjdGGhSteKF8Z3Ga4J6skhlJD4B1gFFFP9863Yy7DeQd3OhiFBZ4yI8Hd5Mu7zFjRe4TyZC6CMLS8dbAWCPxMOS7B4b0VUZ3bOly2JdjpY1FZMjAm+l72nGyrrLZAwM4gqe4Lw/Ta9FyjUktpCekAWv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424651; c=relaxed/simple;
	bh=rYq23HuamHOmJ431JeFlSdXv6JOJEs8laJxV2rw3hbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZAtmSOF2Qqm+WIEg/CEaDo6kNs7rOOYn/2gmi0p7lxLm4/+h8R+x16aCG/0LIgAFKUEIxdHXpkLNodlgKdLL0KGhVexJUW65y9ma2PpPPtP/X4p1x2q9IjSebf7/JpEwht+lNxaXQYXAqgvW9AYqOZTK5V6DmDJScowWKyoHGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsqCheEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsqCheEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA4A1F000E9;
	Thu, 30 Jul 2026 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424649;
	bh=eCy4Z9A8Al+7WmchnCUpM2IR9ABlIP1CPeMgkyK2nxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsqCheEHra1xvSV4Fw5Pns4cazPTFWL1Fw9KKtCSBY0jUewA4AYz4jXT6mTnlgzhl
	 SyorJ37GWbZE0X2L8MUNXwSQ7IJfj+KKMZ5m4piv5dqaSt18cg1UY59TwOT76i4WzP
	 kh00+9z/f0joomSuq224JH8rell5n+nm2T1XAdlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 469/675] rust_binder: only print failure if error has source
Date: Thu, 30 Jul 2026 16:13:19 +0200
Message-ID: <20260730141455.098384870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -1268,14 +1268,14 @@ impl Thread {
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
 


