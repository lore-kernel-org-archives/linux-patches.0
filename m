Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585523;
	b=NWxMTT9TLPduTeh7lxm0tr4zLMJB2fBcsrmnldAnW6MfzrZpoqE3wsrljmNkLzacNWAi
	 bx3Z93uMsMJlqsiW3MUTyrs81EFYRMxcWEyj0mXGskY8urr2ZWp4M0HXrz/8yLlKsFx3M
	 yMdrBb5KE1XKffmbXGYQw7r/4E2TH7S6iBXmWoSfo7Wo/5XsR0G/FWRHcgauL9MdZW6e/
	 I5LQ8wunssMB1BR1ZSXuTXFLI3SLuRBxkM41YYUhYrmR4VpxlrrS3CVEoyNK7o6GC9Pme
	 KVUi9iLC8pJofb3E60OANBldFnahiD0UTTsYuWUtQPHtEVgxUFjRm8H9uoBuqWhC2JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bZwAxVcLChhSIDqwiLFVhYLUcHwucW5TLJa6Ioavdx0=;
	b=kkUC4BxNWwMgiK8r03p1kPi9uhA7CtQafnfFHH8e9ZAo0lYQSQEKt7VNU9Nlf2X7tr5v
	 S5AxC+gNQddC8j3m0GjTRI8vkKjDnu+uHPUMQroNVE3soFPT1ZQUpxxeQxr5D7hNsi14a
	 C2tVD9tAKDbYdqbyAWRCpPH8c2N9CFGbPcj2fD1VftBXeXmWGksmLKSruiMiP3gjxD2ac
	 Lc/KIXTWUnA2ZhvglDlMpxj2ZXcuJ3A4W8cMsSXi96nSTg9FobId3xIYm/HIIhuxIP4sb
	 AlriYle+oz3j5SMszrjq72Pe+k2mPTYbcmtqq/vaiMYf98RZAVb0DiFIa/BcZxAffOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jWdzMhZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759CB606D447;
	Fri, 13 Nov 2026 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jWdzMhZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212061F000C4;
	Fri, 13 Nov 2026 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585523;
	bh=bZwAxVcLChhSIDqwiLFVhYLUcHwucW5TLJa6Ioavdx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jWdzMhZ9gKgpVBrRk69a+hXgTYfv/FQuFmuCHZ/OLqR4sIZbbVwBPSE9C8x0nQPd
	 gpJ/m9Lv1Jif2hd961B/fwXfjQ8DFele0mByzewM5hj4BDJFNWhWMA4m4msqw7ITjG
	 JbMSBgtIpojFuTluZ9A1larpzXaN9olOrXNeX9l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 166/507] vringh: reject empty / undersized indirect descriptor tables
Date: Fri, 13 Nov 2026 10:47:50 -0500
Message-ID: <20261113153800.112413716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit 60a792b97933a686316737838cd007d27963011e ]

move_to_indirect() validates an indirect descriptor table only with
"len % sizeof(struct vring_desc)".  A descriptor flagged
VRING_DESC_F_INDIRECT with len == 0 passes that test, so *desc_max is
set to 0 while *descs points at the empty table.  __vringh_iov() then
copies one struct vring_desc from descs[0] -- 16 bytes past the end of
the table -- before the "indirect_count > desc_max" loop detection
aborts the walk.  The over-read value is discarded when the walk aborts
and is never used to map anything, but the access itself is out of
bounds.

Reject any len smaller than one descriptor, alongside the existing
stride check, so an empty table is refused with -EINVAL and no
descriptor is ever fetched from it.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Message-ID: <20260926160755.21485-1-fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index f672e1115d13c..f027f669460f4 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -197,8 +197,9 @@ static int move_to_indirect(const struct vringh *vrh,
 	}
 
 	len = vringh32_to_cpu(vrh, desc->len);
-	if (unlikely(len % sizeof(struct vring_desc))) {
-		vringh_bad("Strange indirect len %u", desc->len);
+	if (unlikely(len < sizeof(struct vring_desc) ||
+		     len % sizeof(struct vring_desc))) {
+		vringh_bad("Invalid indirect len %u", desc->len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



