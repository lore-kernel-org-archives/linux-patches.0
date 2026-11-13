Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585965;
	b=WQggEF2HNyStYII1eMmbRuEYcHJWAtUrZSh0cTmRSopv/OcKR4kOGP9VPNWyVdZhjyaO
	 /PwnOn3yvmG7yiJQ5TmlBA9h8JzbfqwCCUnSCM4/x3UFp5vn24P4duIfiRR1UDqjESfRQ
	 cMyUTM/0LkKn4xSwZ29Y1ueuTNzf0RxEhLEQTki2ZjSkZhnAGFjmYyFwUFzZIiNddxNWk
	 Ph/TvJAg2vXjgxP7XYF3dOJvC/cA8Afrjas2ovumUUyr0ZoUSr14HBDqEiXAZd+GRRJzx
	 N501i6GL62+9g1CQLPh7fRYUgsHfgI6dhwsVPQW12imGi4h4ua8R+TIFXNFJ/7nZU/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aHlvN08YGQ6XOb50sTyPrjiKwrHTO6A5kzS55rCYA7U=;
	b=OxuaBrMIKshtDj1PMh/sRdAoCZ1NmII21nFRUFE6b34FCOVPsIVk8/CLIvJqsyZbFpGz
	 WXVsvq7B71b/41PxdghWD7uxpAo9hJ618E6VxetdMdQB+Q4b5kvfYkgbFn5TByC916dLk
	 JjUo3xp3ii3MCChWEEM4nmQ0ByI0E9DYhS9S41+aCis1A2pkYkQhcl4cXTLX7R+XrLtaw
	 h/j9w6NOkMXLa4Gl4R+KzQgU4a6+/OV8FbhoczlKlNcwAVWMaH5uAne7A84AbYCEiyX2B
	 zwCMUETV3+C/1QpGQVzb8aATTzzaGzpr7JlDMR+fHEXalXtXeA64wY4k4yhQiE9ccVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEFfbMV8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D450D6072305;
	Fri, 13 Nov 2026 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEFfbMV8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F361F000C4;
	Fri, 13 Nov 2026 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585965;
	bh=aHlvN08YGQ6XOb50sTyPrjiKwrHTO6A5kzS55rCYA7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEFfbMV8C0R+UWrwYzduAQSrSdkUcPOsf557ugIwNMtQ/BhfKK62t8DEDDj+n1pC+
	 Sx27QrbxCt4ga5MH4rlPOvc+Zo9mPl9oCGcAmaXz1nbVoojdQj2bi6d32Zic/68qYw
	 7+2hly3cCR7JFJMqkSI6zZXufjB/FZzv2sh9qos0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/686] fsverity: Tell LSMs about signature only after verity is enabled
Date: Fri, 13 Nov 2026 10:42:20 -0500
Message-ID: <20261113153821.177318266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/enable.c           |  8 ++++++
 fs/verity/fsverity_private.h |  8 ++++++
 fs/verity/open.c             |  9 ++++++
 fs/verity/signature.c        | 55 ++++++++++++++++++++++++++----------
 4 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 95ec42b847972..05fbcae57e5db 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -287,6 +287,14 @@ static int enable_verity(struct file *filp,
 		 * just after the filesystem has successfully enabled verity.
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
index dd20b138d452f..0a2ddca3c838d 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -142,6 +142,8 @@ void __init fsverity_init_info_cache(void);
 extern int fsverity_require_signatures;
 int fsverity_verify_signature(const struct fsverity_info *vi,
 			      const u8 *signature, size_t sig_size);
+void fsverity_report_valid_sig(const struct inode *inode, const u8 *signature,
+			       size_t sig_size);
 
 void __init fsverity_init_signature(void);
 #else /* !CONFIG_FS_VERITY_BUILTIN_SIGNATURES */
@@ -152,6 +154,12 @@ fsverity_verify_signature(const struct fsverity_info *vi,
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
index 02e2c14ab3ffb..dbc2a25e9158e 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -369,6 +369,15 @@ static int ensure_verity_info(struct inode *inode)
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



