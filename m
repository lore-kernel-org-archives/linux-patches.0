Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211541;
	b=rHTUsojr5FEX9AJmbyys2lF/ON12OnBbooiuYkshYt0qyElxdw3BNdYwylJGKNq8tHyP
	 Klvgrjhgnd2Enwe5GX1Z+eB25WqEELX3dCfwQSuTujrjr3QWDUZOvR0DZ+irLba3WwPpb
	 tID72rjDT0qCuELAoFBWrLTLTLoNnOmupeFfv2sbS9GzV0Y1Z5WPHq0dtkxW1AHFxKtXq
	 aGcjcJJgo+hFgtIJIkPYArsjmcYGA9ljK1CrmdYSxkdlVKGr30Txfkpz6BDlFGg5wEP2O
	 MfYZIn0OnExOideZ5buHGcq4xjgsDud0D2VtSzhjWuIoJgG3szp9mvrlOdQDR8g5lZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LEgvvu+mhROAPlV40K6X+0LXfLvVsfMu/LpT8ttV4mQ=;
	b=ZnRn7n0+yjQv+TiC1f5norOC38Z+xO4DeDMu1pi5PX0isEroqQfl23l9PZdYlJ03ox9a
	 MxXklw8BVF+ybejehLrwpyr9a/jUX9SvOuawS8HpDxZiaeBfehNsh3ldpCvTXMsVmTG+r
	 amjOw0+q+Oe4RTxjbXCtAKYtXy70+3LqPzPH+TtLcBVoAGjYXWNiSHyxXAM0YP7NgcyL0
	 n4/Dd3HoQNi+vd7VO/vYM2yAtQyl6GamxXL55UM8PdEqt2VvORkevZHKCrl5r5PRPqYa9
	 lLlmc9WGHXv985dDHQHef4+yKcCQ9WaNeoUiLbu5PP0DEYKNx6cFT6FA8FG3EsX/LTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEEQbrg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B211606A31C;
	Wed, 28 Oct 2026 18:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEEQbrg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5AC1F01828;
	Wed, 28 Oct 2026 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211541;
	bh=LEgvvu+mhROAPlV40K6X+0LXfLvVsfMu/LpT8ttV4mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEEQbrg3XPMesHm0EaWRkvcpkG7ARLnIL7/Cu5bKSoW5i7a+lwqnK/S5xGdoza+8w
	 FT8Y/fmQT8U+YbxmnZXXgeQbD04fQsJVZmS4bfylMn2ECVm1RZXK7RBmgzPiYRy7qd
	 VatXTiWLMUEhV+K/WFh4u+FbBRMA2Oszf6h1EaDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/571] cifs: fix underflow in parse_server_interfaces()
Date: Wed, 28 Oct 2026 17:59:19 +0100
Message-ID: <20261028170017.789480148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cffe487026be13eaf37ea28b783d9638ab147204 ]

In this loop, we step through the buffer and after each item we check
if the size_left is greater than the minimum size we need.  However,
the problem is that "bytes_left" is type ssize_t while sizeof() is type
size_t.  That means that because of type promotion, the comparison is
done as an unsigned and if we have negative bytes left the loop
continues instead of ending.

Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
(cherry picked from commit cffe487026be13eaf37ea28b783d9638ab147204)
[Harshit: Apply the signed guard to both 5.15 parser passes]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2f5c446de223c..88ae29c66becb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -521,7 +521,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 
 	bytes_left = buf_len;
 	p = buf;
-	while (bytes_left >= sizeof(*p)) {
+	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		nb_iface++;
 		next = le32_to_cpu(p->Next);
 		if (!next) {
@@ -556,7 +556,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	info = *iface_list;
 	bytes_left = buf_len;
 	p = buf;
-	while (bytes_left >= sizeof(*p)) {
+	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		info->speed = le64_to_cpu(p->LinkSpeed);
 		info->rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE) ? 1 : 0;
 		info->rss_capable = le32_to_cpu(p->Capability & RSS_CAPABLE) ? 1 : 0;
-- 
2.53.0



