Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133ED15AADF;
	Mon, 29 Jan 2024 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548187; cv=none; b=tcNJID7V+XZ3Y7TNWyRAyfQx9gSwvvLX7otk+lDvYj4qsjdkVN8oJH+LNIPgL3/KVkL3qy4iQ8tO63A/pLfRf9cGCeq1BqQyoIs3GQtO1eqPxKYwUXpxrHMe4JSrX+/G66FKNqmgRQCOcMWy7i80AIYCxLuL0faUszAxl5WG5Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548187; c=relaxed/simple;
	bh=yzsPJbtDIVkEhjOi70nFFtR3Es8tRPNtkK3RoND000w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpyGmMYgQcwsIQKzvveBADeePOWAIBnwZBUw9IjxffXk601/QucBP3ATrOsNNWmqIceemh8GYWvs+K29PYosUOUwQT7KOpp3hzQTCKTHyrxD6Y5btRrWfaIEkjdaAcCf4zXp4pjXmxVIw4zFJe4ZbFrdF7uusCxM8cVE58zPJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEtY/iYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEtY/iYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF863C43394;
	Mon, 29 Jan 2024 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548186;
	bh=yzsPJbtDIVkEhjOi70nFFtR3Es8tRPNtkK3RoND000w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEtY/iYxIMY8/GLWffXmSdB7uK9YT9J7TSU+8bSntI4S7lYI9tgB13TkODVrGv76k
	 oWZwbxIQsXUe879JOCvy67m7Hd2YP6RheFEsvO52pdmHncroEDo7h5k+/Dgrq0seQ8
	 8Nsl60RC//nJK1/ELP2v9Bm/YILGWKg8idQTKUag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Edlinger <bernd.edlinger@hotmail.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.7 230/346] exec: Fix error handling in begin_new_exec()
Date: Mon, 29 Jan 2024 09:04:21 -0800
Message-ID: <20240129170023.159783482@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1408,6 +1408,9 @@ int begin_new_exec(struct linux_binprm *
 
 out_unlock:
 	up_write(&me->signal->exec_update_lock);
+	if (!bprm->cred)
+		mutex_unlock(&me->signal->cred_guard_mutex);
+
 out:
 	return retval;
 }


