Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774665;
	b=3n1Y0wjZfHGySh0Gb49bNrL+SdpixXM9S6F6EjRS03oV9kspkHbomehtzhlKfpBPyakB
	 EGkGxp9KZcP8h5Dlr6UpMUNrmDZjhMfrjMnU4+1X81sMSP3MCaLnoyswOQP2HJ5+fUMyr
	 a9oTcNG7iAGDvX7f8Sj0yiuDAIJS+SaYUeDO69p5Bk5ZzsAMsBYMigmF6uxu3/iSDUslz
	 J+2ptFbFK4AOel22E3VypaFeg8y3NRNlFqLI+hnerhYQr67vtlaxY1/yS2L9AnW0iDjeb
	 2dM3YS8p1xJJj2DCKXPoLiRdnJf84KnvzJvC0gTxC6PHTwg9dqPZZL5M5iO+pz4e6+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMCJkALgsAbo3zSBGE5n2BdgoOtQdLn4fUKoyUJq0+o=;
	b=i5z9+5PGy53rI3nhjRgnAl+bVPNP/IsqkGw5MUQs8Z9pwmYqaOB07hcRyUzdIOHbC8zp
	 BRgIPdPesCwfTYzViw5S3QCKt4+M42zhPhdWUCDF1oiPwwjAOvJukW7/hjq1samx81rQb
	 BYqrThW+eBE2q92UOGGDWUctdJh5MnHvj3zkt4Bl9unh5NAeJMcsObbSMnnmd3moM2KCP
	 1ce+8ZKQ7yIgNvxL/wRi36ZUqXpSy5UxlG7O6Blbq5+6k+emNyR8EPYYQan1VQZNSErhf
	 27LQz3LOm2xfmGN7wpFDk9XnXJ9PyfecB+85ym7LqgRf49yXBzr2zPMbiRs3Vj7YNBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVulGZ1i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147F9606A31D;
	Fri, 23 Oct 2026 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVulGZ1i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655F61F01825;
	Fri, 23 Oct 2026 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774664;
	bh=EMCJkALgsAbo3zSBGE5n2BdgoOtQdLn4fUKoyUJq0+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVulGZ1iROiKlUtdGOjhV+G2jn5DMIpcBPty5TXCsUl94XleZbTJol07fJkK8PCSa
	 5T2+CriDohmSCIZqTk3GCfs7bDKX3wg4C603o4R++FVuW3ngUUP0us9UkzZtDNwcMv
	 wA2ftCGdPbhvSD9mZRoS1n0UxOdrAXLIz2ZlvOJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 116/242] ipc: drop the mqueue mount with kern_unmount() on setup failure
Date: Fri, 23 Oct 2026 18:39:18 +0200
Message-ID: <20261023163716.521163481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

commit f0e48172a59e517e613b73f73cc35f24fd123aeb upstream.

mq_init_ns() creates the mqueue mount with fc_mount_longterm(), so its
->mnt_ns is MNT_NS_INTERNAL. When setting up the mqueue or ipc sysctls
or msg_init_ns() fails afterwards, create_ipc_ns() drops it with a plain
mntput(). With ->mnt_ns set that takes the fast path of
mntput_no_expire(). The count drops to zero and nothing ever kills the
mount, so the mount and the mqueue superblock are leaked.

Commit dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
added the first failure path after mq_init_ns() and never dropped the
mount. Commit 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on
sysctl setup failure") tried to fix that with a mntput() but that
doesn't help for a long-term mount.

Use kern_unmount(). free_ipc() open-codes the same thing for a namespace
that made it.

Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Fixes: 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-5-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -96,7 +96,7 @@ fail_ipc:
 fail_mq_sysctls:
 	retire_mq_sysctls(ns);
 fail_mq_mount:
-	mntput(ns->mq_mnt);
+	kern_unmount(ns->mq_mnt);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_common_free(ns);


