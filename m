Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435141E4B2;
	Wed, 21 Feb 2024 13:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522271; cv=none; b=Ayl7oolmSM3qI3RkLQHs90xTK9O3BV45J+5CcMXwn5ISq+0KqtpHAbvFIKCgGPdOd8rWHRFaUy0+nBgmYcSD8uldK36E9K6V8W8xcQerOMQUJJ6hsHAQQf1In2xtLaYDQZ8LCDvU4Nc9QN2J+Av1au7pc8PK+y07Gy3awJT77mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522271; c=relaxed/simple;
	bh=NiJFV67jbUMfxXNMaw1+sOvvaOF6/PuBuzFxI1blTBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYfpBYaZByoyUT05g1CRuL83BFFh/Nod2vB7L9CusxYWePwbpAfGd0VJ2suFPTxk9sY6WWJGx9ackhtib2OZcSaDOXExGfepb29ZvE1QVcDnuN0ihfiCCxsiH4nscQwWHNzjkV5n5oNUUJZ6F0oSQHalo5EREs6ZSoZw50sVtnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kV9QW0ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kV9QW0ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D596C433F1;
	Wed, 21 Feb 2024 13:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522271;
	bh=NiJFV67jbUMfxXNMaw1+sOvvaOF6/PuBuzFxI1blTBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kV9QW0rywv9Z9ZBVef9e+0fLmXk/XiKxtyG6jYFpQLYpnNgol2Muz509R9SuypkKG
	 oruJ0t3eeJJw8o4aclwh4ebWbOtawcfD9E3Ez9ouGzDN/6qMnzYeIJ3kaBmifeCAKl
	 nKM27CzxvkLDEBM7psJNEzvJaIHmj1CUMQLeHUOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Edlinger <bernd.edlinger@hotmail.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 083/476] exec: Fix error handling in begin_new_exec()
Date: Wed, 21 Feb 2024 14:02:14 +0100
Message-ID: <20240221130011.052680877@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


