Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6551607B7;
	Wed,  5 Feb 2025 15:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768667; cv=none; b=ltXg/C7s0SVOUwzmnH3ckSN6UPjosIJFIBgearpwN1Z1+1RYMZ8kE7zc0UNEvVBLhzq0eqIj0bCzBjNgpt9DOxTTOcwvOlxOcKpYfLmcHthE1lE2tuo0kSzxx+IwuhOjGVi0qdUufEeNAb7dNntoOamoGJ4zW+haGwojAoq4e2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768667; c=relaxed/simple;
	bh=VnBsYUSxQn7kZKnX3bEXVsyNmfXC+ZkrOgT0Ke2KVNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQMsQWOp1KxuV5UBwtKzVSlWFxQ+7n1bRwhaL8fXLmAdxPCEox0OH1C10Ih/oB1KN0CPtR8MzSCcB/juDm2NtHz+IeZOKVRKnz6up2/Ylkn1JrXYlguyx6Tob0NtkFZRAKcB7l9mzzv4laXH/fFQnLcWiquNPfPtTak/NaNlaG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFnvJBrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFnvJBrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C89CC4CED1;
	Wed,  5 Feb 2025 15:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768667;
	bh=VnBsYUSxQn7kZKnX3bEXVsyNmfXC+ZkrOgT0Ke2KVNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFnvJBrz9xwZavfFPs8zSev7rLavHExOiHTTb0ZB7nNte0bHcJYiiSZdb3BK3nN91
	 LBiCXKAqoXirNfOxU6v1fiNX5JYOh+o6FfZkvHusl5qQRQNoTDhGCtGM+TZIZC7rh3
	 qI54Z6OKrjYB6VBXXEZRvFQODXTNb+Ohba32NLcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.13 581/623] selftests/ftrace: Fix to use remount when testing mount GID option
Date: Wed,  5 Feb 2025 14:45:23 +0100
Message-ID: <20250205134518.447881693@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 159ca65c42d90d5ab98fc31b708b12c0be2c26e0 upstream.

Fix mount_options.tc to use remount option to mount the tracefs.
Since the current implementation does not umount the tracefs,
this test always fails because of -EBUSY error.
Using remount option will allow us to change the mount option.

Link: https://lore.kernel.org/r/173625186741.1383744.16707876180798573039.stgit@devnote2
Fixes: 8b55572e5180 ("tracing/selftests: Add tracefs mount options test")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/00basic/mount_options.tc |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/00basic/mount_options.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/mount_options.tc
@@ -15,11 +15,11 @@ find_alternate_gid() {
 	tac /etc/group | grep -v ":$original_gid:" | head -1 | cut -d: -f3
 }
 
-mount_tracefs_with_options() {
+remount_tracefs_with_options() {
 	local mount_point="$1"
 	local options="$2"
 
-	mount -t tracefs -o "$options" nodev "$mount_point"
+	mount -t tracefs -o "remount,$options" nodev "$mount_point"
 
 	setup
 }
@@ -81,7 +81,7 @@ test_gid_mount_option() {
 
 	# Unmount existing tracefs instance and mount with new GID
 	unmount_tracefs "$mount_point"
-	mount_tracefs_with_options "$mount_point" "$new_options"
+	remount_tracefs_with_options "$mount_point" "$new_options"
 
 	check_gid "$mount_point" "$other_group"
 
@@ -92,7 +92,7 @@ test_gid_mount_option() {
 
 	# Unmount and remount with the original GID
 	unmount_tracefs "$mount_point"
-	mount_tracefs_with_options "$mount_point" "$mount_options"
+	remount_tracefs_with_options "$mount_point" "$mount_options"
 	check_gid "$mount_point" "$original_group"
 }
 


