Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F541DE2AE;
	Tue,  8 Oct 2024 13:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392687; cv=none; b=VOUJUpUoE9eRVW+r4QABCLuc2Jf5qLrHnhOpMn/9VB/eIlaaftkna5fBGsSM/e7Ol1Xi4bbMlel7awr3L6FM+A76VIKSkwe/wzMWFEAtbpii6Vfelt/esHfdrPTNtER4L2YA9hNpw0gtlVOuViDeo3Q7v6R4X14IWel1j25D5kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392687; c=relaxed/simple;
	bh=VPjIIHpQ8pErmnRRdacAykWJBGWW/DJNDT7i+SN+qzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpOw2P4N3x50UFk2s5zO8HY/e+d4K+YmbNkpLog8bBdwE+mATfWFj3PcxZHI0LJ/B3R/yuIILo3moKkjBKZlVOzFs/beDFUnUWsdB8BpvfIu3GZLDVcWdQDCUbCf11vfbcCiBtCj3McfwEaHcTK9rm4b94YuTkviwWRe77sYlZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CljZnbNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CljZnbNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B9EC4CEC7;
	Tue,  8 Oct 2024 13:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392687;
	bh=VPjIIHpQ8pErmnRRdacAykWJBGWW/DJNDT7i+SN+qzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CljZnbNZRruZRql2kjdaEjkktkj5lavVbl53OH5765ZF69ZJNgQqq8Erv7FR0sqDc
	 0JTN726D/iT98tPV25CoU8Cw5Imy6F3yUv3ehDmJrjFYY38EJZgzioViZPcJGwPUdt
	 77elzoYFoFgzjNnZp5P2m4dc6xxTsgFbnT53f9Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.11 490/558] pidfs: check for valid pid namespace
Date: Tue,  8 Oct 2024 14:08:40 +0200
Message-ID: <20241008115721.515038266@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 8a46067783bdff222d1fb8f8c20e3b7b711e3ce5 upstream.

When we access a no-current task's pid namespace we need check that the
task hasn't been reaped in the meantime and it's pid namespace isn't
accessible anymore.

The user namespace is fine because it is only released when the last
reference to struct task_struct is put and exit_creds() is called.

Link: https://lore.kernel.org/r/20240926-klebt-altgedienten-0415ad4d273c@brauner
Fixes: 5b08bd408534 ("pidfs: allow retrieval of namespace file descriptors")
CC: stable@vger.kernel.org # v6.11
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 7ffdc88dfb52..80675b6bf884 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -120,6 +120,7 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct nsproxy *nsp __free(put_nsproxy) = NULL;
 	struct pid *pid = pidfd_pid(file);
 	struct ns_common *ns_common = NULL;
+	struct pid_namespace *pid_ns;
 
 	if (arg)
 		return -EINVAL;
@@ -202,7 +203,9 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PIDFD_GET_PID_NAMESPACE:
 		if (IS_ENABLED(CONFIG_PID_NS)) {
 			rcu_read_lock();
-			ns_common = to_ns_common( get_pid_ns(task_active_pid_ns(task)));
+			pid_ns = task_active_pid_ns(task);
+			if (pid_ns)
+				ns_common = to_ns_common(get_pid_ns(pid_ns));
 			rcu_read_unlock();
 		}
 		break;
-- 
2.46.2



