Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585793;
	b=B96tBys3xQlEUWzkR4PCTHXv3f74AzkRI8VftFZt+w4D2kdIxwESghz9G3Uftb6b+ty7
	 Gf/DaAjXHvUi2CrcWTdwXF51Jbhgno19H3IqVvVqln7GrBpCxRiRxGwUPFZvUBoIOoTkZ
	 p8Fjg0PBHFxVBdbKmyV3VXa1PTHbDHouXf9ul7idERfvJHiuiqnJlFWwRw6y2ZeKWm5JK
	 d2TcLtRuH4/WKI2w+evJ0x5yl29v3D7kWI77aJwd5qwnu/LEl65kdLpdu7LVXUmxUqcpc
	 SEqXikvvyNc2zW7SheNRJLT11bKzG8M8KDuZc7JLFXiGQsLKVt8C6iEZIXxGF0+moNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ko8L29rSOnZ+DJxitoyV9VpLkb4+a2fDmiSjdIVZev0=;
	b=I5eVyldDhD6/biIpLqG40rEW58teU14Ug9aGnb51+AVXkPs9SueixM+f3KYYVf3x0CMm
	 Zqg05YLFSDNFSEQTNwcSVcwHX9sTUTHENarfVJxx4RjjFIgOTvhiyq7r3m9njCxPuOdQT
	 frI64uY6L+Dh6MNt8S2mb5hYeSWRpF0d+m/zqzIXZQUTVmuD5x+1Qo/DfP194hBcj4UUc
	 xQq73Ofy71/v+foTqPY0qxP8WuosgoYQuN1XBuW8NR4yS5bwvOoc+M65FtNeQm6skstAO
	 DvRvWCUphN3en73yEh7FEsniq9N8xyjB47WvYrWyrsTl9xTNkzvEFzm+t6bqALNIjdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ndUUfGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0334D606EBBA;
	Fri, 13 Nov 2026 16:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ndUUfGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C9D1F000C6;
	Fri, 13 Nov 2026 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585792;
	bh=ko8L29rSOnZ+DJxitoyV9VpLkb4+a2fDmiSjdIVZev0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ndUUfGlrifaI6THzAdC1ar4eKzHMeAwOO/D1Dyf0k+vfuZzallRR1LkZY7UBUaCp
	 qMaUZrbOt5q6QiTkbsAx4U/+Q5m25z1b3HWzZaJ90JZZHNM+NiznFEMZ2EPVRSC9ml
	 ypcMV+8EBYVNhg7B7JGhipCcY5qfan4khFDXq00o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 381/507] nvmet: dont return memory contents beyond valid data when reading ANA log page
Date: Fri, 13 Nov 2026 10:51:25 -0500
Message-ID: <20261113153809.266323820@linuxfoundation.org>
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

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 29b8758b4700357909f06705a0c48c7a60c556d5 ]

The host side does not know how much valid data will be returned by the target
so it will typically provide a buffer larger than the amount of valid data in
the ANA log page.  The memory allocation used by the target does not guarantee
that prior kernel memory contents will not be returned past the end of the valid
page data.  Fix this to ensure that the SGL is zeroed before copying the data.

Fixes: 72efd25dcf4f ("nvmet: add minimal ANA support")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index e76d4f7453004..3704493dbec97 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -543,6 +543,15 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	u16 ngrps = 0;
 	u16 status;
 
+	/*
+	 * The header and one descriptor per enabled group are the only bytes
+	 * written below; zero the whole transfer first so the unwritten tail
+	 * does not leak stale kernel memory to the host.
+	 */
+	status = nvmet_zero_sgl(req, 0, req->transfer_len);
+	if (status)
+		goto out;
+
 	status = NVME_SC_INTERNAL;
 	desc = kmalloc_flex(*desc, nsids, NVMET_MAX_NAMESPACES);
 	if (!desc)
-- 
2.53.0



