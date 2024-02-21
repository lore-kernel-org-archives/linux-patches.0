Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0166E76C99;
	Wed, 21 Feb 2024 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523943; cv=none; b=nIClIq4FKJ14okx2oftsklv0JrciibPZ1pfsxzpMDn68pHL4BBcDXSZZz3JhqXVYJkQjM73BLwsIgls34Q7RcjrTvYU8D/wo52eI9qjQMC3DP+yziBmoG+tIZEAPzO7zZfQID8U8h0l49MYtGr8cMxguEh70dCsVRGv1YjeGUkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523943; c=relaxed/simple;
	bh=i6GB1Amkyo19BaT+l4gCi6TYq1NcjGofduHMXUyGSJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vk2D4MKht54qZ1uJb1nwe6KONYs5Zj0ZxOV2jm7Kf6/Dy72owm/hjCPxFYO1ODtbh368JhP2uWFH4JtkFFaRSfw2Hnzc0R4EXT/WXeNBvYWVVaMNyyYK7mqMws12+vbp5cp0UHij7cWJ66JN2g2RdgnVw6jt5u2qs+0iu7K5Ldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQWH+V0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQWH+V0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CAAC43394;
	Wed, 21 Feb 2024 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523942;
	bh=i6GB1Amkyo19BaT+l4gCi6TYq1NcjGofduHMXUyGSJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQWH+V0AwFf7yrr3QcTzKbZy86DrSPiT0vRJQiQS/Mhu9AmPgLthyPaG6PwedXtl6
	 GbSV+gHiFN1AbSyLkEqpMReQbD25Nx9RmtXXTGTrRn6snFgSsqjPd6Q4Z6BJQX1ymT
	 5l0KGY0DX54HhwGDDkUemy/trmESKUjnhSX+lLHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Edlinger <bernd.edlinger@hotmail.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 068/379] exec: Fix error handling in begin_new_exec()
Date: Wed, 21 Feb 2024 14:04:07 +0100
Message-ID: <20240221125956.927091696@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
@@ -1392,6 +1392,9 @@ int begin_new_exec(struct linux_binprm *
 
 out_unlock:
 	up_write(&me->signal->exec_update_lock);
+	if (!bprm->cred)
+		mutex_unlock(&me->signal->cred_guard_mutex);
+
 out:
 	return retval;
 }


