Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A291A76DD;
	Tue, 30 Jul 2024 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360064; cv=none; b=QXoya7+RjAetWFquOFaRKbfB2laVqpwZqNMK/wRZELL9X3BR4Vits+Z1oRBTBEqC1Tdfqh8Codag8nisKJzR03hwN9V4y4KgPCLF0bDDtW4Jv9QEXbrGeeBDSctWaJ/APEUYsX/NBco5/V7g+xTcRk2v9r4Pp4MAGSEQ6ihv+ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360064; c=relaxed/simple;
	bh=jBpXa+xh8BVh2MEQUtxZBuZsk2dfGzG/dy2WdPbuFaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3m7ppW3mOV0RtPZIO+qssvkEk2m3C2s00pKYEoeGF7HG+vZjS403gbmV7L9OhLVL9iw+RiaODjiweLXlHk98Ih1OSBsRU57lBVQMsF0dljUqH8mJ7sC101vb+V7RSX5MkYkLcCaWaSAm0YSfL6sGKhKWUzrj1mZ9Dnvvi+HXj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4Qmx/6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4Qmx/6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4D4C32782;
	Tue, 30 Jul 2024 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360064;
	bh=jBpXa+xh8BVh2MEQUtxZBuZsk2dfGzG/dy2WdPbuFaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4Qmx/6Fz97Yu0abOSo0A0vqsSPzQJ5SZvYAe0E7okmAZLKw2akDw21Zj6VYGuMRo
	 6mEeliaQJRlLiXjH4nT/otbkHotiHTsMUzCAxP9l7Bbr+e5e/pFHruJxVgoWXWZwLn
	 eJyNCxTZY3rtC7VKd/L1JikDVlF57E+5e5kSL33A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 585/809] cifs: fix reconnect with SMB1 UNIX Extensions
Date: Tue, 30 Jul 2024 17:47:41 +0200
Message-ID: <20240730151747.935630897@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit a214384ce26b6111ea8c8d58fa82a1ca63996c38 upstream.

When mounting with the SMB1 Unix Extensions (e.g. mounts
to Samba with vers=1.0), reconnects no longer reset the
Unix Extensions (SetFSInfo SET_FILE_UNIX_BASIC) after tcon so most
operations (e.g. stat, ls, open, statfs) will fail continuously
with:
        "Operation not supported"
if the connection ever resets (e.g. due to brief network disconnect)

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3686,6 +3686,7 @@ error:
 }
 #endif
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 /*
  * Issue a TREE_CONNECT request.
  */
@@ -3807,11 +3808,25 @@ CIFSTCon(const unsigned int xid, struct
 		else
 			tcon->Flags = 0;
 		cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
-	}
 
+		/*
+		 * reset_cifs_unix_caps calls QFSInfo which requires
+		 * need_reconnect to be false, but we would not need to call
+		 * reset_caps if this were not a reconnect case so must check
+		 * need_reconnect flag here.  The caller will also clear
+		 * need_reconnect when tcon was successful but needed to be
+		 * cleared earlier in the case of unix extensions reconnect
+		 */
+		if (tcon->need_reconnect && tcon->unix_ext) {
+			cifs_dbg(FYI, "resetting caps for %s\n", tcon->tree_name);
+			tcon->need_reconnect = false;
+			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
+		}
+	}
 	cifs_buf_release(smb_buffer);
 	return rc;
 }
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 static void delayed_free(struct rcu_head *p)
 {


