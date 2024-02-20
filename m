Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3172DF9F;
	Tue, 20 Feb 2024 21:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464150; cv=none; b=PP7P4L2VRTEVuLiziFn70rmAT/q8xkZCr8igx++kKEsuFPBt2QN74wethDowT9ln2tV521iGqmwmNe/2g5vGEmecsnEXLFUG1EmkFGYCUY02/3TyQwbz3ZZcEa+dDCTbaH9rkarUSIDLwzhC/GD2CMA0/7Gnj1L95pbpnbNeS+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464150; c=relaxed/simple;
	bh=dZMmch3aWK04y+Ew/LOH/zW1TIyelJi8O09KTAI8Mr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRElwAy7CwpENoZyFn0SEYR2tJp2yPkoCS/w5wo9x7UxIUmJB92RZaJQGx+PEA9U4OcamSwi45txhyJWPFPcEkRHIy524WcKbw2XQySGoY4hpMvFLMcdFQqXPAuuWCf6IDwILICVRM0Kcobh2hfYDaSI7TPdNrH1lIiumTKez24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otwrn/tT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otwrn/tT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A57C433F1;
	Tue, 20 Feb 2024 21:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464150;
	bh=dZMmch3aWK04y+Ew/LOH/zW1TIyelJi8O09KTAI8Mr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otwrn/tTKbhq7QwS8/ymp65/DDV9D7wRT+xIMCtDQ9wTPYzbzxyivi0eOrgVw7WR5
	 wG+vm429ZOXk1F0HwhhX2EWHI0lYtMs3ivmc9KY9hL7OYYRgBQ1nd1CzWjrF9xm3d1
	 HiorOI/7Fw9cixew8viT5wk8yZxYJY/7S/CmUZmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 266/331] eventfs: Use ERR_CAST() in eventfs_create_events_dir()
Date: Tue, 20 Feb 2024 21:56:22 +0100
Message-ID: <20240220205646.247345117@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit b8a555dc31e5aa18d976de0bc228006e398a2e7d upstream.

When building with clang and CONFIG_RANDSTRUCT_FULL=y, there is an error
due to a cast in eventfs_create_events_dir():

  fs/tracefs/event_inode.c:734:10: error: casting from randomized structure pointer type 'struct dentry *' to 'struct eventfs_inode *'
    734 |                 return (struct eventfs_inode *)dentry;
        |                        ^
  1 error generated.

Use the ERR_CAST() function to resolve the error, as it was designed for
this exact situation (casting an error pointer to another type).

Link: https://lore.kernel.org/linux-trace-kernel/20231018-ftrace-fix-clang-randstruct-v1-1-338cb214abfb@kernel.org

Closes: https://github.com/ClangBuiltLinux/linux/issues/1947
Fixes: 5790b1fb3d67 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -731,7 +731,7 @@ struct eventfs_inode *eventfs_create_eve
 		return NULL;
 
 	if (IS_ERR(dentry))
-		return (struct eventfs_inode *)dentry;
+		return ERR_CAST(dentry);
 
 	ei = kzalloc(sizeof(*ei), GFP_KERNEL);
 	if (!ei)


