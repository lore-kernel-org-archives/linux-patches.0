Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABAA15AAA7;
	Mon, 29 Jan 2024 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548359; cv=none; b=gWqALhar/PiQJvOk+VgOUwlyVejP2BDXu5fgmrRbDuktpFhTYx1jHCG6BGLmt5iJvfjULYPUJrs4WJjhw1zCCdYyxGI+XETwagKPXixU38C7o6LM6Y9jLZ7KEQZ2UZNMx/QPTU6TZQZBG3Wg1hBUtsxy7kDjJkzDNM33+rDKbTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548359; c=relaxed/simple;
	bh=eKOuAzqse9ADdgUrzG6iBzna7RHJ/0R1DFAWdhct5zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8/ILLGQKlDTfibn2rJzupc6m3iFH3Y07VI0gdoF5uCyHgkbaz95PYr1S6tOpeW870ZVyVO7PxrDjcfc7lVXAglRBVhPWK/zGzd18bfAIL1z+cqlrVx4L76251w1fxfDEUsZkv7EwV87ATmIQZbiogZ5SvC7cBD7CEYSMGEkte0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+IYM4im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+IYM4im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E95C43390;
	Mon, 29 Jan 2024 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548359;
	bh=eKOuAzqse9ADdgUrzG6iBzna7RHJ/0R1DFAWdhct5zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+IYM4im/05XbWCF97H9parYikoltnkMC5fgER2L0nFnnXm3b9Pt8cj+hI/4t1y8M
	 hmWjZHciECX9fwkm4+rq6xdfaDJWE99xWwOgg7HUQSm4cu5PaISzfapsu1ctrBzS54
	 VEXwzBljFHd3aF6IRIYgwnSJ/9U6LxmUGqUeVZaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Edlinger <bernd.edlinger@hotmail.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 122/185] exec: Fix error handling in begin_new_exec()
Date: Mon, 29 Jan 2024 09:05:22 -0800
Message-ID: <20240129170002.512665907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

commit 84c39ec57d409e803a9bb6e4e85daf1243e0e80b upstream.

If get_unused_fd_flags() fails, the error handling is incomplete because
bprm->cred is already set to NULL, and therefore free_bprm will not
unlock the cred_guard_mutex. Note there are two error conditions which
end up here, one before and one after bprm->cred is cleared.

Fixes: b8a61c9e7b4a ("exec: Generic execfd support")
Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Link: https://lore.kernel.org/r/AS8P193MB128517ADB5EFF29E04389EDAE4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1410,6 +1410,9 @@ int begin_new_exec(struct linux_binprm *
 
 out_unlock:
 	up_write(&me->signal->exec_update_lock);
+	if (!bprm->cred)
+		mutex_unlock(&me->signal->cred_guard_mutex);
+
 out:
 	return retval;
 }


