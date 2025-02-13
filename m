Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E4026B080;
	Thu, 13 Feb 2025 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459514; cv=none; b=TkMWoeh0CB5aThZIDCF/3cGSvDLZo8T0XLTmF0s4mldpaXYDCULWTYqm/gWEoT03g0NMUd7ye8bveKp0MPFRYHmQvYgMtEYphq4kOQ3hcZs4u1PdzGUQXCfywS8n0enUwOoJ5oGKuaRYkW0r0hnLzfpgSH9+DFbadFphcwu27Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459514; c=relaxed/simple;
	bh=XXWmfI7M0zIph9ElR1EX5jiQjWIUimP+O5xcpXDgZEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0QUzS6D2KzyCMqdhX1N8RnoMQXLoGBHifFHRCpz6M93BEHPMsBVg1Ros9k+QBHzmqrsGxU1iDzARKW1qQS0VluHiz/Hq0p4NShhA828VkrOyCe2SxBPkYBhA9gVcJhOo+09jiaKR6PGjuWEeV0UB6eARfSsa7UIyGgWWeexgAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i86fud1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i86fud1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA08C4CED1;
	Thu, 13 Feb 2025 15:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459514;
	bh=XXWmfI7M0zIph9ElR1EX5jiQjWIUimP+O5xcpXDgZEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i86fud1oDfEfmj7PQW1/E1rfBluKLdq4jlcxsCXTU+3b5E8TXMyL99QskXBjxgz9Q
	 /6pEipdTRAcYJZ2woeSuZL2o8pK3X2GQRJ5fsUADnMUG5vNnGdGN76VBQbK0v5Lg2H
	 Dq6OQ6jGvq7Ec+2TWVaMIADHnqppRC+oX2DN2nuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 288/443] pidfs: improve ioctl handling
Date: Thu, 13 Feb 2025 15:27:33 +0100
Message-ID: <20250213142451.724522082@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 091ee63e36e8289f9067f659a48d497911e49d6f upstream.

Pidfs supports extensible and non-extensible ioctls. The extensible
ioctls need to check for the ioctl number itself not just the ioctl
command otherwise both backward- and forward compatibility are broken.

The pidfs ioctl handler also needs to look at the type of the ioctl
command to guard against cases where "[...] a daemon receives some
random file descriptor from a (potentially less privileged) client and
expects the FD to be of some specific type, it might call ioctl() on
this FD with some type-specific command and expect the call to fail if
the FD is of the wrong type; but due to the missing type check, the
kernel instead performs some action that userspace didn't expect."
(cf. [1]]

Link: https://lore.kernel.org/r/20250204-work-pidfs-ioctl-v1-1-04987d239575@kernel.org
Link: https://lore.kernel.org/r/CAG48ez2K9A5GwtgqO31u9ZL292we8ZwAA=TJwwEv7wRuJ3j4Lw@mail.gmail.com [1]
Fixes: 8ce352818820 ("pidfs: check for valid ioctl commands")
Acked-by: Luca Boccassi <luca.boccassi@gmail.com>
Reported-by: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org # v6.13; please backport with 8ce352818820 ("pidfs: check for valid ioctl commands")
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -195,7 +195,6 @@ static bool pidfs_ioctl_valid(unsigned i
 	switch (cmd) {
 	case FS_IOC_GETVERSION:
 	case PIDFD_GET_CGROUP_NAMESPACE:
-	case PIDFD_GET_INFO:
 	case PIDFD_GET_IPC_NAMESPACE:
 	case PIDFD_GET_MNT_NAMESPACE:
 	case PIDFD_GET_NET_NAMESPACE:
@@ -208,6 +207,17 @@ static bool pidfs_ioctl_valid(unsigned i
 		return true;
 	}
 
+	/* Extensible ioctls require some more careful checks. */
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(PIDFD_GET_INFO):
+		/*
+		 * Try to prevent performing a pidfd ioctl when someone
+		 * erronously mistook the file descriptor for a pidfd.
+		 * This is not perfect but will catch most cases.
+		 */
+		return (_IOC_TYPE(cmd) == _IOC_TYPE(PIDFD_GET_INFO));
+	}
+
 	return false;
 }
 


