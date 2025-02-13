Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE9178F30;
	Thu, 13 Feb 2025 15:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460050; cv=none; b=ga9dA2WG1+KM6hsKOrRSiZQAyLAfYtl5STIqET9u6SgkxkB51/OCegPvshxfLxSI20v/xzaMrW09Mfe0MB/o3Z+NM+3G33rhuIH/8yc9V6xaIoAUFZPo4iX2UVMJw6sKnLnWhMDdt646OyBD1TmLvmmwfclR5LGFvW4VQcXpB2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460050; c=relaxed/simple;
	bh=+t1rjCkVx1wCL8mOJTs+4dU3EYp4NI2FXkD9RAkrHqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ec07IFPTdgCBAMUfd4LwjIBab4aiFd5ekvm0WU0uqdXMX6whLgiAMjOVHL4c7uSTMStOzuTiGS+5BD63NIaRURkQ3HLtwQcc9X2r8PurrVRE4zk8dzvGHgZFcyQjbdxqLI8gnDq7kgHEHrUkoGucGfbpZoz5ZL/clwaPIn7XY5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixuq1xQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixuq1xQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07577C4CED1;
	Thu, 13 Feb 2025 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460050;
	bh=+t1rjCkVx1wCL8mOJTs+4dU3EYp4NI2FXkD9RAkrHqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixuq1xQSut2C7QyVXJgYeiiOQRzoagDK9vc4kMhLJ1X9WVuNsCptxi8ZBS3Mh0YEC
	 RXu96CpbTrBj1Wrf+BwXzVMyA93kM4qhwz34L1rYZGaPNYohKXqAMhPHhu0yseLjlP
	 V5dJtkplbtOUnr8N5npE9cHvsnbH07varWLhX7ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 442/443] fs: prepend statmount.mnt_opts string with security_sb_mnt_opts()
Date: Thu, 13 Feb 2025 15:30:07 +0100
Message-ID: <20250213142457.670252582@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 056d33137bf9364456ee70aa265ccbb948daee49 upstream.

Currently these mount options aren't accessible via statmount().

The read handler for /proc/#/mountinfo calls security_sb_show_options()
to emit the security options after emitting superblock flag options, but
before calling sb->s_op->show_options.

Have statmount_mnt_opts() call security_sb_show_options() before
calling ->show_options.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20241115-statmount-v2-2-cd29aeff9cbb@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5eb987105357 ("fs: fix adding security options to statmount.mnt_opt")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5042,6 +5042,10 @@ static int statmount_mnt_opts(struct kst
 	if (sb->s_op->show_options) {
 		size_t start = seq->count;
 
+		err = security_sb_show_options(seq, sb);
+		if (err)
+			return err;
+
 		err = sb->s_op->show_options(seq, mnt->mnt_root);
 		if (err)
 			return err;


