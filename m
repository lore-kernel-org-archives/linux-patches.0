Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590860;
	b=HZEQYXE5yWvwCs0MsgBjKWMua9acDJZEXPrwnDft6/0O8se57XKQ9kIf2CnnM9KINiXG
	 r4gJR++9ZoFAsrIZIG63NCKH+bPfFlpky09Mj654rmZ7G5P2fKnoZQijRr0doiH+eQ6fl
	 XzMkyLDpjLrdROQDeAKM/TRQiQCv4td/mWy8LxfFBHzLGcE+NNd1vqysvJIIDNxOzQL71
	 Wk1fM95C+kPm3xRXhs7fKDK8rn7OanAHX4O17Rvza1Yc10f+oC8TDjS/YXpwPbNHKEtAt
	 7m3lWurxYglBNvtJc+XVxHNOTEA//sGLSv02aV5mUCdUERQSek9xPdCtKymnL6SykmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8pckH/QRSftu90mYsEeL7EcKQgC63OY/mCucXolY9iY=;
	b=ytXu52+pHx2gxNqC4+zxD1p6Lcu/qsaxkTQD5ITCL2DrAHmK6SAUijOCCEG5Eqa6sclu
	 /JAbpQqHeEmcc9J+7zD/IKwEXw/YcAoEdc494PLkd37CIIQnvG4HU/zzpeYbBkiKQWQ/5
	 aJfj/zzGMh21CWbIkTXb2fpSue/WV96c5GbDVtw/N+UgSXYJysNbS284nfZo4vhPKnZ4d
	 TrDM+E/UWEOi/rN7tkqigsYspvTpu4JbFhxEE4gRKUia6BvSQKRDJhU+P/QCuwM4x+uHO
	 F5xYcu06FXv2rn4vZCzyhj6RQNQMwvDilX7SokfKZsXR1+r2xOdGh63kEn7jMVhPfDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KR+uEQjX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA504606D49F;
	Fri, 13 Nov 2026 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KR+uEQjX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAD31F000CD;
	Fri, 13 Nov 2026 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590860;
	bh=8pckH/QRSftu90mYsEeL7EcKQgC63OY/mCucXolY9iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KR+uEQjXcg/VgDJw4Ldn+Nt+uI26qKw5EnPTdy2bJkS/7dkrunyBjcvQFk0PHHkjt
	 XKNO72QF4ykFbKpVK23k0NDj18GvbWq5uWTG5x/iTuCDq2acCiWIx2cPLfMaipO/6d
	 ZCRuxvJPZOVaehjJFQCsZcr/zmx0o+tJ6PJeXLyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/670] fsverity: Tell LSMs about signature only after verity is enabled
Date: Fri, 13 Nov 2026 10:42:52 -0500
Message-ID: <20261113153811.469526850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 28d74059fddbd8ae83c7715056b303c402071f6f upstream.

FS_IOC_ENABLE_VERITY calls security_inode_setintegrity() before verity
has finished being enabled.  That's broken because enabling verity can
still fail at that point, e.g. due to insufficient xattr space.

Afterwards, arbitrary contents can be written to the file, which doesn't
actually have verity enabled.  The in-core inode stays the same, so the
LSM considers it to have verity enabled with a valid signature.  (Or
rather, in the case of IPE, which is the only LSM that implements
security_inode_setintegrity(), it also checks IS_VERITY(), which can be
bypassed by enabling verity with no signature after the file writes.)

Fix this by moving the call to security_inode_setintegrity() out of
fsverity_verify_signature() and into a new function that is called from
the appropriate places.

Fixes: 7c373e4f1445 ("fsverity: expose verified fsverity built-in signatures to LSMs")
Cc: stable@vger.kernel.org
Reviewed-by: Fan Wu <wufan@kernel.org>
Tested-by: Fan Wu <wufan@kernel.org>
Link: https://patch.msgid.link/20261025204534.122506-1-ebiggers@kernel.org
(6.12: resolved conflicts with this version storing the fsverity_info
 pointer in the inode instead of using a hash table)
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/enable.c           |  8 ++++++
 fs/verity/fsverity_private.h |  8 ++++++
 fs/verity/open.c             |  9 ++++++
 fs/verity/signature.c        | 55 ++++++++++++++++++++++++++----------
 4 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index c284f46d1b535..197564ecd3ef6 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -292,6 +292,14 @@ static int enable_verity(struct file *filp,
 		 * after the filesystem has successfully enabled verity.
 		 */
 		fsverity_set_info(inode, vi);
+
+		/*
+		 * Now that verity is enabled, report the signature (if any) to
+		 * LSMs.  We tolerate that a process racing with this ioctl can
+		 * briefly see verity enabled with no signature reported yet.
+		 */
+		fsverity_report_valid_sig(inode, desc->signature,
+					  le32_to_cpu(desc->sig_size));
 	}
 out:
 	kfree(params.hashstate);
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index b3506f56e180b..760f2674c816e 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -135,6 +135,8 @@ void __init fsverity_init_info_cache(void);
 extern int fsverity_require_signatures;
 int fsverity_verify_signature(const struct fsverity_info *vi,
 			      const u8 *signature, size_t sig_size);
+void fsverity_report_valid_sig(const struct inode *inode, const u8 *signature,
+			       size_t sig_size);
 
 void __init fsverity_init_signature(void);
 #else /* !CONFIG_FS_VERITY_BUILTIN_SIGNATURES */
@@ -145,6 +147,12 @@ fsverity_verify_signature(const struct fsverity_info *vi,
 	return 0;
 }
 
+static inline void fsverity_report_valid_sig(const struct inode *inode,
+					     const u8 *signature,
+					     size_t sig_size)
+{
+}
+
 static inline void fsverity_init_signature(void)
 {
 }
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 9c1b37a3b96a8..dba70c0ab5b64 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -377,6 +377,15 @@ static int ensure_verity_info(struct inode *inode)
 		goto out_free_desc;
 	}
 
+	/*
+	 * Now that the signature (if any) has been verified, report it to LSMs.
+	 * Do this before setting the fsverity_info, so that anyone who
+	 * concurrently retrieves the fsverity_info for the same inode is
+	 * guaranteed to see the LSM's signature status populated.
+	 */
+	fsverity_report_valid_sig(inode, desc->signature,
+				  le32_to_cpu(desc->sig_size));
+
 	fsverity_set_info(inode, vi);
 	err = 0;
 out_free_desc:
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 0302a4e506ec4..212e873c84998 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -42,13 +42,16 @@ static struct key *fsverity_keyring;
  * @sig_size: size of signature in bytes, or 0 if no signature
  *
  * If the file includes a signature of its fs-verity file digest, verify it
- * against the certificates in the fs-verity keyring. Note that signatures
- * are verified regardless of the state of the 'fsverity_require_signatures'
- * variable and the LSM subsystem relies on this behavior to help enforce
- * file integrity policies. Please discuss changes with the LSM list
- * (thank you!).
+ * against the certificates in the fs-verity keyring.
  *
- * Return: 0 on success (signature valid or not required); -errno on failure
+ * Note that signatures are verified regardless of the state of the
+ * 'fsverity_require_signatures' variable, and the LSM subsystem relies on this
+ * behavior to help enforce file integrity policies.  (See
+ * fsverity_report_valid_sig(), which assumes that the signature, if present,
+ * was verified here.)  Please discuss changes with the LSM list (thank you!).
+ *
+ * Return: 0 if the signature is present and valid, or absent and not required;
+ *	   -errno on failure
  */
 int fsverity_verify_signature(const struct fsverity_info *vi,
 			      const u8 *signature, size_t sig_size)
@@ -111,18 +114,40 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		return err;
 	}
 
-	err = security_inode_setintegrity(inode,
-					  LSM_INT_FSVERITY_BUILTINSIG_VALID,
-					  signature,
-					  sig_size);
+	return 0;
+}
 
-	if (err) {
+/*
+ * If the signature exists, this tells the LSM that it was verified.
+ *
+ * fsverity_verify_signature() must have already been called with the same
+ * signature, *and* the inode must have verity enabled with the signature
+ * matching it.  If called from FS_IOC_ENABLE_VERITY, the latter means that we
+ * must be past the point of no return, i.e. verity won't fail to be enabled at
+ * a later point.  This is critical, since LSMs must be told about the signature
+ * only when the verity status is permanent in the in-core inode.
+ */
+void fsverity_report_valid_sig(const struct inode *inode, const u8 *signature,
+			       size_t sig_size)
+{
+	int err;
+
+	if (WARN_ON_ONCE(!IS_VERITY(inode)))
+		return;
+
+	if (sig_size == 0)
+		return;
+
+	err = security_inode_setintegrity(
+		inode, LSM_INT_FSVERITY_BUILTINSIG_VALID, signature, sig_size);
+	if (err)
 		fsverity_err(inode, "Error %d exposing file signature to LSMs",
 			     err);
-		return err;
-	}
-
-	return 0;
+	/*
+	 * Besides the logging above, ignore errors here.  The LSM hook just
+	 * records the signature and doesn't perform access control.  And in the
+	 * case of FS_IOC_ENABLE_VERITY verity was already enabled.
+	 */
 }
 
 void __init fsverity_init_signature(void)
-- 
2.53.0



