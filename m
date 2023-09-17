Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D56FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AE4C433C9;
	Sun, 17 Sep 2023 19:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979393;
	bh=6xG5K7B8vJ8lVlp1lFNORIztkhXDvRkj5f07odaHvLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSTR54Z4ot8AlcMgI0QOkxo75iZYMEYxIQFs5jsNHbkhmBqDaMD3PRfrE3yRt+ty7
	 3a+sg5FMXy2L18J+UqqU0SA4ahsuGkKxFU2nSQ79JCEjspaQQeufGs2MCTK3s9Tss4
	 mcfgxumhk4UrqEmnZSWz0QtvaOZXeaLrco79VFLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.10 299/406] fsverity: skip PKCS#7 parser when keyring is empty
Date: Sun, 17 Sep 2023 21:12:33 +0200
Message-ID: <20230917191109.207523272@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 919dc320956ea353a7fb2d84265195ad5ef525ac upstream.

If an fsverity builtin signature is given for a file but the
".fs-verity" keyring is empty, there's no real reason to run the PKCS#7
parser.  Skip this to avoid the PKCS#7 attack surface when builtin
signature support is configured into the kernel but is not being used.

This is a hardening improvement, not a fix per se, but I've added
Fixes and Cc stable to get it out to more users.

Fixes: 432434c9f8e1 ("fs-verity: support builtin file signatures")
Cc: stable@vger.kernel.org
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20230820173237.2579-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/signature.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -61,6 +61,22 @@ int fsverity_verify_signature(const stru
 		return -EBADMSG;
 	}
 
+	if (fsverity_keyring->keys.nr_leaves_on_tree == 0) {
+		/*
+		 * The ".fs-verity" keyring is empty, due to builtin signatures
+		 * being supported by the kernel but not actually being used.
+		 * In this case, verify_pkcs7_signature() would always return an
+		 * error, usually ENOKEY.  It could also be EBADMSG if the
+		 * PKCS#7 is malformed, but that isn't very important to
+		 * distinguish.  So, just skip to ENOKEY to avoid the attack
+		 * surface of the PKCS#7 parser, which would otherwise be
+		 * reachable by any task able to execute FS_IOC_ENABLE_VERITY.
+		 */
+		fsverity_err(inode,
+			     "fs-verity keyring is empty, rejecting signed file!");
+		return -ENOKEY;
+	}
+
 	d = kzalloc(sizeof(*d) + hash_alg->digest_size, GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;


