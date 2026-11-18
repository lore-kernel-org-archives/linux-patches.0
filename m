Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045241;
	b=J6kls62Kuaq3refYW5K0+EXpKSyLHc5NUHZ//Yk25FBvoIfTBocRXqQweGl9UjMGk9Y2
	 gWTOdUHdcugJs0BJDjmq2qsx7Yuf2EMrRJbfxQSVO6R9oNeQsYYvR+tlQxNxsl2tIr2Jh
	 lkdEkvQB/Je06k2lDX6YSJv1ziGogB5K22bKeXZ16HAvvjKlIpVIZ0bzhFs66rAFdpH0L
	 WwzMkbnSFmyvAPuB0XU53+qQthxrghBfzUu5M7XZ4ZSXMPwQBtVsiB2uLer3BZsTJRNnC
	 hmBlK2Js3/nHD4ZEu0k5J9O1pzAgjQi1l2T/Sxf5MBDoHBUSe5+D0fgVaGjXipj/1AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qQkQP9OIKs36YzVTigVQ4WrU+e8+0Szxrk8T6EQnx5g=;
	b=1hpd07qKDUTqZnGNWgi4tiXk8grMoip+O98oYvtkMwwaiuRnhSW52q5vxKn/BF0TfGBz
	 p81IkHQkoMuwZlRmmv8Sgt0RjdnjaTd3ykoFOzFxIFVMLs47pLGU+5YrY5sxE17yXyL5m
	 45lIMClP1R4fPhxMW7/0Z1P1X1b65dKMGS7/ak0tdRgGH7lpR7No4er/bU1uOT8+cafWk
	 nIReL5Qea9arg9PoHeELzYJ38uelFtxwn/rL80RO0rR+SONg0IvS6bzkUie0iip7k5awc
	 ZJhR7kdPIkFkJzeQ2+wVjFlNO96q2BqOWr5iV3+LyZBD6hwCi7jqKnR26RrU61dJmKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pp4yRYQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F8A606A31C;
	Wed, 18 Nov 2026 23:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pp4yRYQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD5F1F000C4;
	Wed, 18 Nov 2026 23:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045241;
	bh=qQkQP9OIKs36YzVTigVQ4WrU+e8+0Szxrk8T6EQnx5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pp4yRYQE+EwmdbishhTdMJx/BeH7PppU4YZNrLGRTZxkE2wiu1eImSGab9IHqgO/V
	 k1PHGsFlPo3+vdY9cdYb037jdDCz8Bjf4Jqb2nRgkl93EsDMFQF7ihwztN/cP6nZRh
	 N6zFaxKtv5i3vwKNPuupv4rexSCaKn9rlRtQjYho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0854/2857] dm-writecache: fix a crash if we attempt to use non-dax device
Date: Wed, 18 Nov 2026 15:31:28 +0100
Message-ID: <20261118150232.317770460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit b15dc73f60ebf02410bc7014ce34fb7fd1040045 ]

If we specify a non-DAX device as a cache device in the 'P' mode,
dm-writecache crashes on NULL pointer dereference inside dax_synchronous.

Note that this is not a security bug because only root can trigger it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a46624580376 ("dm writecache: reject asynchronous pmem devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index e34af22c52a9c..97baa868eebe9 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2506,6 +2506,11 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	if (WC_MODE_PMEM(wc)) {
+		if (!wc->ssd_dev->dax_dev) {
+			r = -EOPNOTSUPP;
+			ti->error = "Cache device is not a DAX device";
+			goto bad;
+		}
 		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
 			r = -EOPNOTSUPP;
 			ti->error = "Asynchronous persistent memory not supported as pmem cache";
-- 
2.53.0



