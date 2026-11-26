Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705258;
	b=wm/0tEm54/19oGSrIXwBSJ+PY0cD3ZFlO7Hk/gQXgaVE0/Zqr2var0pO9Tlzjn1BcB1p
	 qFFYcYdPNjPhl1rqGbahIml/NxplVa/WgxUx4+oc4HIv/Oejw/qGvWkY+4o8genz4cpXp
	 ip09hHjz3ubX8hUxqS/fTfIy/k+V4SKqbqrit4jefpOoyCc7+1C/YKsxaCMhrP20wQ/Hp
	 UnvBEgXH2N3liLri7NnMvdTfX3kdfQpAATdgccys3SnyPiGw1ZJcFsTC7+lUFsxj4KEki
	 0rum4X70Pu51k+BOHt4yGvvlE+0wNWRAdnc9FSOfF8vtD+9CXdLXQre9TLTuPk2Pv8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hWg39kznLsQ/7kqxZVmWO6Mels7rIIeNvIp9bk/k124=;
	b=JilAD7Bi82pCeNDVwaCE2gs97y1psyttOBL4nswEWvP/2bLL0vFjwM4Y0waRJuPm0n2c
	 YIYVe0SU2EpAFXaiHv3eReVTBnBmJyz8tni9RQxYH1kiMB8COBFvRl5XXnT2FM2PTKzAg
	 evIIdBLDihFpU28rRBnHbM0Uk+cH6PM+J5Og3BuJL8bflyTTivx4ByS4ErFR6EehhEZES
	 VVfV8slgscKjmflLTFa52V4WQZ+LcL6cC0DlYzX+bR4PsJ+mdlvIKuRE8jNDMZp6K81Cz
	 bUI8trtk53NLBbw2W09m8998bfpxFDeHwRDZnbOSCftOwDYL3p+KGdtafMlkMqkJjQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBO9V3D8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C6606A334;
	Thu, 26 Nov 2026 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBO9V3D8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB62C1F000EC;
	Thu, 26 Nov 2026 15:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705258;
	bh=hWg39kznLsQ/7kqxZVmWO6Mels7rIIeNvIp9bk/k124=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBO9V3D8S3XfA1+Fsn+PDe3HKf+zbv+GQCbmh7/zdK95tVxJlUmJmdFXYMm0fj23a
	 5ODW/AhwbYMp1u1toTqb9XzZZzOjTAoCnnQUqw/41W7nCD8gXfkoMFYCIHF+PYn7/u
	 JeFvna/qM41qejotNgOnETW6UNNW8dRm7KUoglOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/319] SUNRPC: Balance switch queue length on transport removal
Date: Thu, 26 Nov 2026 15:38:27 +0100
Message-ID: <20261126144009.884126277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 8acd94f02a960c8936df25a7af9c02c8ea87064d ]

When call_connect_status() moves a task off a transport marked for
removal, it decrements xprt->queuelen but leaves the switch's
xps_queuelen unchanged. The stale count persists after the task
finishes and skews multipath transport selection.

Decrement xps_queuelen alongside xprt->queuelen, matching the normal
transport release path.

Fixes: 6f081693e7b2 ("sunrpc: remove an offlined xprt using sysfs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index de2d24a16087e..7d7950068b030 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2131,6 +2131,7 @@ call_connect_status(struct rpc_task *task)
 
 				xprt_release(task);
 				value = atomic_long_dec_return(&xprt->queuelen);
+				atomic_long_dec(&xps->xps_queuelen);
 				if (value == 0)
 					rpc_xprt_switch_remove_xprt(xps, saved);
 				xprt_put(saved);
-- 
2.53.0



