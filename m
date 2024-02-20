Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05B976C9C;
	Tue, 20 Feb 2024 21:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464119; cv=none; b=GDbzNDbKltOINSSfT/x9L4oDXWQzSTbk+ZoScZv45vEtLY6P91tmAhAmlhP1NzwJFJ5iNC5Wt0OunvIUFA8Zv/5nFDgx3FeLC3UF8tGA5OeekpCpMXjeTkm7jpcVaQnDJyjK4nVR8GcKyaKBjXzbCOstlzvwOhXgdCNzY6lU98g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464119; c=relaxed/simple;
	bh=Vbkpe8WY5AAFjzNjDXPXBFT1oWhOcAPxt9+Q56m6K8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcCjNagDMJkx350rG/O5y/hmDMRoHOe+ajiyXFueoJzKFv49l87kEmOcsUiRAKGFhAeFR/MuVySMuk5sqF/bspbLvlOtjnD+/48+tZhXAXXGBWHqz7NSA/Fwr/kuxCG/Gdjkfdu+QuSe2CGJiTFoW6dcbf5aFQYEJA2cFfLAM4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0P+fJWGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0P+fJWGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24126C433F1;
	Tue, 20 Feb 2024 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464119;
	bh=Vbkpe8WY5AAFjzNjDXPXBFT1oWhOcAPxt9+Q56m6K8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0P+fJWGDllx7jwN7NeGNUd2LX3/zGXJTFg5LPrE41XlVNHtbQq927qCOZg/CxaKzL
	 9NnFP2829dMTb0bb4j+FX2RJCwTHmvAun90cf2zWaUsHQ6SPX+qDFKGSPSo7GTteEf
	 GRngSNcGH3IOLvDmqALja1gTCEHmVtFEiQpJZQg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 258/331] Revert "eventfs: Do not allow NULL parent to eventfs_start_creating()"
Date: Tue, 20 Feb 2024 21:56:14 +0100
Message-ID: <20240220205645.970252501@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This reverts commit 6abb8c223ce12078a0f2c129656a13338dfe960b.

The eventfs was not designed properly and may have some hidden bugs in it.
Linus rewrote it properly and I trust his version more than this one. Revert
the backported patches for 6.6 and re-apply all the changes to make it
equivalent to Linus's version.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -509,15 +509,20 @@ struct dentry *eventfs_start_creating(co
 	struct dentry *dentry;
 	int error;
 
-	/* Must always have a parent. */
-	if (WARN_ON_ONCE(!parent))
-		return ERR_PTR(-EINVAL);
-
 	error = simple_pin_fs(&trace_fs_type, &tracefs_mount,
 			      &tracefs_mount_count);
 	if (error)
 		return ERR_PTR(error);
 
+	/*
+	 * If the parent is not specified, we create it in the root.
+	 * We need the root dentry to do this, which is in the super
+	 * block. A pointer to that is in the struct vfsmount that we
+	 * have around.
+	 */
+	if (!parent)
+		parent = tracefs_mount->mnt_root;
+
 	if (unlikely(IS_DEADDIR(parent->d_inode)))
 		dentry = ERR_PTR(-ENOENT);
 	else


