Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362549;
	b=QXuLc2iTBLrtSGcnJRIIOTO0WnjJ9E7Y/WT2Lj08vPLgDfNxkJtK6/OGuoXprukp/Zjy
	 I3eYl5tdNZta+XSFYAEoSyieLq1AV0x2nFmkDOQmBrk+PzpKJc5x8gvQfhU69/RZYd9+Y
	 3bximTD1Zkm1UfD5vsSO5ft247Ygp1ufc/XQWeI2L9PZUhZhtk1Zn0oonZ8U48yZrqSOf
	 H2QbEPohHfoRVOrcKR/HvT8vfxX4rpRXP+ZzshZIzvCmOmMsoENSKK0BmZWkOg5e7dkbE
	 fnnW49tG77ZSgKsv2F4oBExq1pXkfEMx5vBdojmwIiwydd7mMG/6+sSUMzj0pNPoIvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJXxmoNyx6TiprH093Zk91HOoA/Zq2pHyVmj++0hP7A=;
	b=RRNeyAowKMp35ofOTQmHEA+Bjo/NH+7f49PvZ2DcOwvWLgVQLS92vIGq749lDnx7TvVQ
	 XdkHpBQ1/8TG91hkIFRmJxmIn/7pe10Q6/9xu3nou2kkISahKDpMJhtua1K/oAfIZmZdZ
	 tkj9UVTqG466pDa/QJRkQzC6ItInVAPy2qrvs0j7Saz2kqDuRnaB3IGei2SZTwCfp4QKn
	 bXeMC1kZh5DjGhy28CfDt0d5pRx6DtDOQ1jwXMhdduAFheR4VDcMqpr1tFqkG14klcGS5
	 24BiN61naPkDBFz4sKBffc2+0SD6JxxowcT92uu8TSkB8f3g9mfe+1A5EEpQaItBX+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a0kFLypY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7360606A31C;
	Fri, 30 Oct 2026 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a0kFLypY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECC31F000C1;
	Fri, 30 Oct 2026 12:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362548;
	bh=zJXxmoNyx6TiprH093Zk91HOoA/Zq2pHyVmj++0hP7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0kFLypYyfxy2+9nfnzGMh1x6KkRNgopgsbbg04AZFQYODBGVqoeVZR45aG87xSn5
	 /eQyr/hgSWDWOu2sOPMz40TelNTqziM3Kpsjm0Kx0KykhtZOWTLD9YW7uVSrPdlYOA
	 omRz+aQnxNvV0rQRkV169m9WMgf7VZqvP8csh4gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 09/10] fork: move the coredump and exec checks into create_io_thread()
Date: Fri, 30 Oct 2026 13:15:10 +0100
Message-ID: <20261030121255.481827147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e760200370e4de054b6b5f568a7faa911e2956bb ]

Only a PF_USER_WORKER thread returns from get_signal() after a fatal
signal and can go on to create a thread. get_signal() sets PF_SIGNALED
before it dumps core and before it lets a PF_USER_WORKER thread return.
That flags sticks.

The exec'ing thread itself is never signaled. But it doesn't need the check
anyway as we moved cancellation of io_uring requests before de_thread().
create_io_thread() is the only way a signaled thread creates another
one. vhost_task_create() is reached from ioctls alone.

io_should_retry_thread() doesn't retry -EINTR, so io-wq callers give up
the same way they did when copy_process() refused.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/aq0VLTyxNatFmLOK@redhat.com
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-13-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 1f978881ce6c ("fork: don't create io threads once PF_POSTCOREDUMP is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2689,6 +2689,10 @@ struct task_struct *create_io_thread(int
 		.user_worker	= 1,
 	};
 
+	/* A creator past its fatal signal gets no thread. */
+	if (current->flags & PF_SIGNALED)
+		return ERR_PTR(-EINTR);
+
 	return copy_process(NULL, 0, node, &args);
 }
 


